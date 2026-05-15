import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'KRYPTIX'**
  String get appTitle;

  /// No description provided for @deterministicSecurity.
  ///
  /// In en, this message translates to:
  /// **'DETERMINISTIC SECURITY'**
  String get deterministicSecurity;

  /// No description provided for @masterKey.
  ///
  /// In en, this message translates to:
  /// **'Master Key'**
  String get masterKey;

  /// No description provided for @enterMasterKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your master key'**
  String get enterMasterKey;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// No description provided for @serviceExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., google.com'**
  String get serviceExample;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password Length'**
  String get passwordLength;

  /// No description provided for @generatedPassword.
  ///
  /// In en, this message translates to:
  /// **'Generated Password'**
  String get generatedPassword;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Encrypted password copied'**
  String get passwordCopied;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @saveMasterKeyLocally.
  ///
  /// In en, this message translates to:
  /// **'Save Master Key Locally'**
  String get saveMasterKeyLocally;

  /// No description provided for @saveMasterKeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Securely store your master key using biometric or device lock authentication.'**
  String get saveMasterKeySubtitle;

  /// No description provided for @savedServices.
  ///
  /// In en, this message translates to:
  /// **'SAVED SERVICES'**
  String get savedServices;

  /// No description provided for @servicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} SERVICES'**
  String servicesCount(int count);

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @noSavedServices.
  ///
  /// In en, this message translates to:
  /// **'No saved services yet.'**
  String get noSavedServices;

  /// No description provided for @clearAllHistory.
  ///
  /// In en, this message translates to:
  /// **'CLEAR ALL HISTORY'**
  String get clearAllHistory;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY & SECURITY'**
  String get privacyAndSecurity;

  /// No description provided for @localOnly.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get localOnly;

  /// No description provided for @privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Kryptix does not send your data anywhere. Your master key, services, and generated passwords never leave your device. Everything is stored locally using industry-standard secure storage.'**
  String get privacyDescription;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'HOW IT WORKS'**
  String get howItWorks;

  /// No description provided for @zeroKnowledgeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Zero-Knowledge Security'**
  String get zeroKnowledgeSecurity;

  /// No description provided for @howItWorksDescription.
  ///
  /// In en, this message translates to:
  /// **'Kryptix mathematically derives your passwords using SHA-256 with 50,000 iterations of key stretching.'**
  String get howItWorksDescription;

  /// No description provided for @howItWorksBullet1.
  ///
  /// In en, this message translates to:
  /// **'Your Master Key never leaves this device.'**
  String get howItWorksBullet1;

  /// No description provided for @howItWorksBullet2.
  ///
  /// In en, this message translates to:
  /// **'Nothing is ever sent to a server.'**
  String get howItWorksBullet2;

  /// No description provided for @howItWorksBullet3.
  ///
  /// In en, this message translates to:
  /// **'Passwords are generated on-the-fly when you need them.'**
  String get howItWorksBullet3;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @githubRepository.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepository;

  /// No description provided for @viewSourceCode.
  ///
  /// In en, this message translates to:
  /// **'View source code and contribute'**
  String get viewSourceCode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get update;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @masterKeyStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength: {strength}'**
  String masterKeyStrength(String strength);

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @chars.
  ///
  /// In en, this message translates to:
  /// **'CHARS'**
  String get chars;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'WEAK'**
  String get weak;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get medium;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'STRONG'**
  String get strong;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Deterministic Security'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords calculated, not stored. Your passwords are mathematically derived on-the-fly using advanced SHA-256 cryptography.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Absolute Privacy'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your data never leaves your device. No cloud sync, no servers, no tracking. You are entirely in control.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'One Key for Everything'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Memorize just one strong Master Key. Secure it locally using your device\'s biometric authentication.'**
  String get onboarding3Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @returnToOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Return to Onboarding'**
  String get returnToOnboarding;

  /// No description provided for @returnToOnboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Go through the introductory slides again'**
  String get returnToOnboardingSubtitle;

  /// No description provided for @returnToOnboardingConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will reset your onboarding status. Continue?'**
  String get returnToOnboardingConfirm;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'PROCEED'**
  String get proceed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
