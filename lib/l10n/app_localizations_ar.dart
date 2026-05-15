// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كريبتيكس';

  @override
  String get deterministicSecurity => 'أمان حتمي';

  @override
  String get masterKey => 'المفتاح الرئيسي';

  @override
  String get enterMasterKey => 'أدخل مفتاحك الرئيسي';

  @override
  String get serviceName => 'اسم الخدمة';

  @override
  String get serviceExample => 'مثال: google.com';

  @override
  String get passwordLength => 'طول كلمة المرور';

  @override
  String get generatedPassword => 'كلمة المرور المنشأة';

  @override
  String get copyToClipboard => 'نسخ إلى الحافظة';

  @override
  String get passwordCopied => 'تم نسخ كلمة المرور المشفرة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get saveMasterKeyLocally => 'حفظ المفتاح الرئيسي محلياً';

  @override
  String get saveMasterKeySubtitle =>
      'قم بتخزين مفتاحك الرئيسي بأمان باستخدام المصادقة الحيوية أو قفل الجهاز.';

  @override
  String get savedServices => 'الخدمات المحفوظة';

  @override
  String servicesCount(int count) {
    return '$count خدمات';
  }

  @override
  String get addService => 'إضافة خدمة';

  @override
  String get editService => 'تعديل الخدمة';

  @override
  String get noSavedServices => 'لا توجد خدمات محفوظة بعد.';

  @override
  String get clearAllHistory => 'مسح كل السجل';

  @override
  String get historyCleared => 'تم مسح السجل';

  @override
  String get privacyAndSecurity => 'الخصوصية والأمان';

  @override
  String get localOnly => 'محلي فقط';

  @override
  String get privacyDescription =>
      'كريبتيكس لا يرسل بياناتك إلى أي مكان. مفتاحك الرئيسي وخدماتك وكلمات المرور المنشأة لا تغادر جهازك أبداً. يتم تخزين كل شيء محلياً باستخدام تخزين آمن بمعايير الصناعة.';

  @override
  String get howItWorks => 'كيف يعمل';

  @override
  String get zeroKnowledgeSecurity => 'أمان المعرفة الصفرية';

  @override
  String get howItWorksDescription =>
      'كريبتيكس يشتق كلمات المرور الخاصة بك رياضياً باستخدام SHA-256 مع 50,000 تكرار لتمطيط المفتاح.';

  @override
  String get howItWorksBullet1 => '• مفتاحك الرئيسي لا يغادر هذا الجهاز أبداً.';

  @override
  String get howItWorksBullet2 => '• لا يتم إرسال أي شيء إلى خادم أبداً.';

  @override
  String get howItWorksBullet3 =>
      '• يتم إنشاء كلمات المرور فورياً عندما تحتاج إليها.';

  @override
  String get about => 'حول التطبيق';

  @override
  String get githubRepository => 'مستودع GitHub';

  @override
  String get viewSourceCode => 'عرض التعليمات البرمجية والمساهمة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add => 'إضافة';

  @override
  String get update => 'تحديث';

  @override
  String get version => 'الإصدار';

  @override
  String masterKeyStrength(String strength) {
    return 'القوة: $strength';
  }

  @override
  String get waiting => 'في الانتظار...';

  @override
  String get showPassword => 'عرض كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get chars => 'حرف';

  @override
  String get weak => 'ضعيف';

  @override
  String get medium => 'متوسط';

  @override
  String get strong => 'قوي';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get onboarding1Title => 'أمان حتمي';

  @override
  String get onboarding1Subtitle =>
      'كلمات مرور محسوبة، غير مخزنة. يتم اشتقاق كلمات المرور الخاصة بك رياضياً فورياً باستخدام تشفير SHA-256 المتقدم.';

  @override
  String get onboarding2Title => 'خصوصية مطلقة';

  @override
  String get onboarding2Subtitle =>
      'بياناتك لا تغادر جهازك أبداً. لا توجد مزامنة سحابية، ولا خوادم، ولا تتبع. أنت المسيطر تماماً.';

  @override
  String get onboarding3Title => 'مفتاح واحد لكل شيء';

  @override
  String get onboarding3Subtitle =>
      'احفظ مفتاحاً رئيسياً قوياً واحداً فقط. قم بتأمينه محلياً باستخدام المصادقة الحيوية لجهازك.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get returnToOnboarding => 'العودة إلى البداية';

  @override
  String get returnToOnboardingSubtitle => 'استعرض الشرائح التعريفية مرة أخرى';

  @override
  String get returnToOnboardingConfirm =>
      'سيتم إعادة تعيين حالة البداية. هل تريد المتابعة؟';

  @override
  String get proceed => 'متابعة';
}
