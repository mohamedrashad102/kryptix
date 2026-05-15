import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/password_generator_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/saved_service.dart';
import '../widgets/bento_card.dart';
import '../widgets/kryptix_theme.dart';
import 'onboarding_page.dart';

/// A page to manage application settings and history.
class SettingsPage extends StatelessWidget {
  /// Creates a [SettingsPage].
  const SettingsPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showServiceDialog(
    BuildContext context, {
    SavedService? existingService,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: existingService?.name);
    final versionController = TextEditingController(
      text: existingService?.version.toString() ?? '1',
    );
    final isEditing = existingService != null;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(isEditing ? l10n.editService : l10n.addService),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.serviceName,
                    hintText: l10n.serviceExample,
                  ),
                  autofocus: !isEditing,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: versionController,
                  decoration: InputDecoration(
                    labelText: l10n.version,
                    hintText: 'e.g., 1',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final version = int.tryParse(versionController.text) ?? 1;

                  if (name.isNotEmpty) {
                    final newService = SavedService(
                      name: name,
                      version: version,
                    );
                    if (isEditing) {
                      unawaited(
                        context.read<PasswordGeneratorCubit>().updateService(
                          existingService.name,
                          newService,
                        ),
                      );
                    } else {
                      unawaited(
                        context.read<PasswordGeneratorCubit>().addService(
                          newService,
                        ),
                      );
                    }
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(isEditing ? l10n.update : l10n.add),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PasswordGeneratorCubit>();
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<PasswordGeneratorCubit, PasswordGeneratorState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              BentoCard(
                title: l10n.preferences,
                icon: Icons.settings_suggest_rounded,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(l10n.saveMasterKeyLocally),
                      subtitle: Text(
                        l10n.saveMasterKeySubtitle,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: state.saveMasterKeyPreference,
                      onChanged: (_) =>
                          unawaited(cubit.toggleSaveMasterKeyPreference()),
                      activeThumbColor: colorScheme.primary,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.language_rounded, size: 20),
                      title: Text(l10n.language),
                      trailing: SegmentedButton<String>(
                        segments: [
                          ButtonSegment(
                            value: 'en',
                            label: Text(
                              l10n.english,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ButtonSegment(
                            value: 'ar',
                            label: Text(
                              l10n.arabic,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                        selected: {state.locale},
                        onSelectionChanged: (newSelection) {
                          unawaited(cubit.updateLocale(newSelection.first));
                        },
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.school_rounded, size: 20),
                      title: Text(l10n.returnToOnboarding),
                      subtitle: Text(
                        l10n.returnToOnboardingSubtitle,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onTap: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            title: Text(l10n.returnToOnboarding),
                            content: Text(l10n.returnToOnboardingConfirm),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(l10n.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  await cubit.resetOnboarding();
                                  if (context.mounted) {
                                    unawaited(
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              const OnboardingPage(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(l10n.proceed),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BentoCard(
                title: l10n.savedServices,
                icon: Icons.history_rounded,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.servicesCount(state.recentServices.length),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showServiceDialog(context),
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            color: colorScheme.primary,
                            tooltip: l10n.addService,
                          ),
                        ],
                      ),
                    ),
                    if (state.recentServices.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            l10n.noSavedServices,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else ...[
                      ...state.recentServices.map((service) {
                        return ListTile(
                          title: Text(service.name),
                          subtitle: Text('${l10n.version} ${service.version}'),
                          onTap: () => _showServiceDialog(
                            context,
                            existingService: service,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () =>
                                unawaited(cubit.deleteService(service.name)),
                          ),
                        );
                      }),
                      const Divider(),
                      TextButton.icon(
                        onPressed: () {
                          unawaited(cubit.clearAllHistory());
                          KryptixTheme.showSuccessSnackBar(
                            context,
                            l10n.historyCleared,
                          );
                        },
                        icon: const Icon(Icons.delete_sweep_rounded),
                        label: Text(l10n.clearAllHistory),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BentoCard(
                title: l10n.privacyAndSecurity,
                icon: Icons.security_rounded,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.localOnly,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.privacyDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BentoCard(
                title: l10n.howItWorks,
                icon: Icons.auto_fix_high_rounded,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.zeroKnowledgeSecurity,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.howItWorksDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• ${l10n.howItWorksBullet1}\n'
                        '• ${l10n.howItWorksBullet2}\n'
                        '• ${l10n.howItWorksBullet3}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BentoCard(
                title: l10n.about,
                icon: Icons.info_outline_rounded,
                child: ListTile(
                  title: Text(l10n.githubRepository),
                  subtitle: Text(l10n.viewSourceCode),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => unawaited(
                    _launchUrl('https://github.com/mohamedrashad102/kryptix'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
