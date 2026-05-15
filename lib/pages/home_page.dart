import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/password_generator_cubit.dart';
import '../l10n/app_localizations.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/kryptix_theme.dart';
import '../widgets/length_control.dart';
import '../widgets/result_display.dart';
import 'views/home_page_desktop.dart';
import 'views/home_page_mobile.dart';

/// The main landing page of the Kryptix application.
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _masterKeyController = TextEditingController();
  final _websiteController = TextEditingController();
  final _focusNodeMaster = FocusNode();
  final _focusNodeWebsite = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodeMaster.requestFocus();
    });
  }

  @override
  void dispose() {
    _masterKeyController.dispose();
    _websiteController.dispose();
    _focusNodeMaster.dispose();
    _focusNodeWebsite.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard(String password) async {
    if (password.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: password));
      await HapticFeedback.lightImpact();
      if (!mounted) return;

      await context.read<PasswordGeneratorCubit>().saveCurrentService();
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      KryptixTheme.showSuccessSnackBar(context, l10n.passwordCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PasswordGeneratorCubit>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 40,
              ),
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Header(),
                    SizedBox(height: isMobile ? 40 : 60),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child:
                          BlocListener<
                            PasswordGeneratorCubit,
                            PasswordGeneratorState
                          >(
                            listenWhen: (previous, current) =>
                                previous.masterKey != current.masterKey ||
                                previous.website != current.website,
                            listener: (context, state) {
                              if (state.masterKey !=
                                  _masterKeyController.text) {
                                _masterKeyController.text = state.masterKey;
                              }
                              if (state.website != _websiteController.text) {
                                _websiteController.text = state.website;
                              }
                            },
                            child:
                                BlocBuilder<
                                  PasswordGeneratorCubit,
                                  PasswordGeneratorState
                                >(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        if (isMobile)
                                          HomePageMobileView(
                                            masterKeyController:
                                                _masterKeyController,
                                            websiteController:
                                                _websiteController,
                                            focusNodeMaster: _focusNodeMaster,
                                            focusNodeWebsite: _focusNodeWebsite,
                                            state: state,
                                            cubit: cubit,
                                            onCopy: () => _copyToClipboard(
                                              state.generatedPassword,
                                            ),
                                          )
                                        else
                                          HomePageDesktopView(
                                            masterKeyController:
                                                _masterKeyController,
                                            websiteController:
                                                _websiteController,
                                            focusNodeMaster: _focusNodeMaster,
                                            focusNodeWebsite: _focusNodeWebsite,
                                            state: state,
                                            cubit: cubit,
                                            onCopy: () => _copyToClipboard(
                                              state.generatedPassword,
                                            ),
                                          ),
                                        const SizedBox(height: 24),
                                        LengthControl(
                                          length: state.length.toDouble(),
                                          onChanged: (v) =>
                                              cubit.updateLength(v.round()),
                                        ),
                                        const SizedBox(height: 24),
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          transitionBuilder:
                                              (child, animation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(
                                                        0,
                                                        0.1,
                                                      ),
                                                      end: Offset.zero,
                                                    ).animate(animation),
                                                    child: child,
                                                  ),
                                                );
                                              },
                                          child: ResultDisplay(
                                            key: ValueKey(
                                              state
                                                  .generatedPassword
                                                  .isNotEmpty,
                                            ),
                                            password: state.generatedPassword,
                                            obscureText: state.obscureResult,
                                            onToggleObscure:
                                                cubit.toggleResultVisibility,
                                            onCopy: () => _copyToClipboard(
                                              state.generatedPassword,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                          ),
                    ),
                    SizedBox(height: isMobile ? 40 : 60),
                    const Footer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
