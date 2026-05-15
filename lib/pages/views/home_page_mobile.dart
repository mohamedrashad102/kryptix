import 'package:flutter/material.dart';
import '../../cubit/password_generator_cubit.dart';
import '../../widgets/master_key_input.dart';
import '../../widgets/service_input.dart';

/// The mobile layout view for the Home Page.
class HomePageMobileView extends StatelessWidget {
  /// Creates a [HomePageMobileView].
  const HomePageMobileView({
    required this.masterKeyController,
    required this.websiteController,
    required this.focusNodeMaster,
    required this.focusNodeWebsite,
    required this.state,
    required this.cubit,
    required this.onCopy,
    super.key,
  });

  /// The controller for the master key input.
  final TextEditingController masterKeyController;

  /// The controller for the service/website input.
  final TextEditingController websiteController;

  /// The focus node for the master key input.
  final FocusNode focusNodeMaster;

  /// The focus node for the service/website input.
  final FocusNode focusNodeWebsite;

  /// The current state of the password generator.
  final PasswordGeneratorState state;

  /// The cubit for the password generator.
  final PasswordGeneratorCubit cubit;

  /// Callback for when the generated password is copied.
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MasterKeyInput(
          controller: masterKeyController,
          focusNode: focusNodeMaster,
          obscureText: state.obscureMasterKey,
          onToggleObscure: cubit.toggleMasterKeyVisibility,
          onSubmitted: focusNodeWebsite.requestFocus,
          onChanged: cubit.updateMasterKey,
        ),
        const SizedBox(height: 20),
        ServiceInput(
          controller: websiteController,
          focusNode: focusNodeWebsite,
          recentServices: state.recentServices,
          onSubmitted: onCopy,
          onChanged: cubit.updateWebsite,
          onServiceSelected: cubit.selectService,
          onDeleteService: cubit.deleteService,
          onClearAll: cubit.clearAllHistory,
          version: state.version,
          onIncrementVersion: cubit.incrementVersion,
          onDecrementVersion: cubit.decrementVersion,
        ),
      ],
    );
  }
}
