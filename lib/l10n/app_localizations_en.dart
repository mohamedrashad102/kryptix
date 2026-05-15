// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KRYPTIX';

  @override
  String get deterministicSecurity => 'DETERMINISTIC SECURITY';

  @override
  String get masterKey => 'Master Key';

  @override
  String get enterMasterKey => 'Enter your master key';

  @override
  String get serviceName => 'Service Name';

  @override
  String get serviceExample => 'e.g., google.com';

  @override
  String get passwordLength => 'Password Length';

  @override
  String get generatedPassword => 'Generated Password';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get passwordCopied => 'Encrypted password copied';

  @override
  String get settings => 'Settings';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get saveMasterKeyLocally => 'Save Master Key Locally';

  @override
  String get saveMasterKeySubtitle =>
      'Securely store your master key using biometric or device lock authentication.';

  @override
  String get savedServices => 'SAVED SERVICES';

  @override
  String servicesCount(int count) {
    return '$count SERVICES';
  }

  @override
  String get addService => 'Add Service';

  @override
  String get editService => 'Edit Service';

  @override
  String get noSavedServices => 'No saved services yet.';

  @override
  String get clearAllHistory => 'CLEAR ALL HISTORY';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get privacyAndSecurity => 'PRIVACY & SECURITY';

  @override
  String get localOnly => 'Local Only';

  @override
  String get privacyDescription =>
      'Kryptix does not send your data anywhere. Your master key, services, and generated passwords never leave your device. Everything is stored locally using industry-standard secure storage.';

  @override
  String get howItWorks => 'HOW IT WORKS';

  @override
  String get zeroKnowledgeSecurity => 'Zero-Knowledge Security';

  @override
  String get howItWorksDescription =>
      'Kryptix mathematically derives your passwords using SHA-256 with 50,000 iterations of key stretching.';

  @override
  String get howItWorksBullet1 => 'Your Master Key never leaves this device.';

  @override
  String get howItWorksBullet2 => 'Nothing is ever sent to a server.';

  @override
  String get howItWorksBullet3 =>
      'Passwords are generated on-the-fly when you need them.';

  @override
  String get about => 'ABOUT';

  @override
  String get githubRepository => 'GitHub Repository';

  @override
  String get viewSourceCode => 'View source code and contribute';

  @override
  String get cancel => 'CANCEL';

  @override
  String get add => 'ADD';

  @override
  String get update => 'UPDATE';

  @override
  String get version => 'Version';

  @override
  String masterKeyStrength(String strength) {
    return 'Strength: $strength';
  }

  @override
  String get waiting => 'Waiting...';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get chars => 'CHARS';

  @override
  String get weak => 'WEAK';

  @override
  String get medium => 'MEDIUM';

  @override
  String get strong => 'STRONG';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get onboarding1Title => 'Deterministic Security';

  @override
  String get onboarding1Subtitle =>
      'Passwords calculated, not stored. Your passwords are mathematically derived on-the-fly using advanced SHA-256 cryptography.';

  @override
  String get onboarding2Title => 'Absolute Privacy';

  @override
  String get onboarding2Subtitle =>
      'Your data never leaves your device. No cloud sync, no servers, no tracking. You are entirely in control.';

  @override
  String get onboarding3Title => 'One Key for Everything';

  @override
  String get onboarding3Subtitle =>
      'Memorize just one strong Master Key. Secure it locally using your device\'s biometric authentication.';

  @override
  String get getStarted => 'GET STARTED';

  @override
  String get next => 'NEXT';

  @override
  String get skip => 'SKIP';

  @override
  String get returnToOnboarding => 'Return to Onboarding';

  @override
  String get returnToOnboardingSubtitle =>
      'Go through the introductory slides again';

  @override
  String get returnToOnboardingConfirm =>
      'This will reset your onboarding status. Continue?';

  @override
  String get proceed => 'PROCEED';
}
