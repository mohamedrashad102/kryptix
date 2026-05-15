import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

import 'cubit/password_generator_cubit.dart';
import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';
import 'pages/onboarding_page.dart';
import 'service/storage_service.dart';
import 'widgets/kryptix_theme.dart';

// ─── Screenshot Configuration ───────────────────────────────────────────────
// Set [kScreenshotMode] to true to enable screenshot window sizing.
// Change [kScreenshotTarget] to pick the device size you want.

/// The target device size for screenshots.
enum ScreenshotTarget {
  /// Phone size.
  phone,

  /// 7-inch tablet size.
  tablet7,

  /// 10-inch tablet size.
  tablet10
}

/// Whether the app is in screenshot mode.
const bool kScreenshotMode = false;

/// The current screenshot target device.
const ScreenshotTarget kScreenshotTarget = ScreenshotTarget.tablet10;

const Map<ScreenshotTarget, Size> _screenshotSizes = {
  ScreenshotTarget.phone: Size(458, 814),
  ScreenshotTarget.tablet7: Size(509, 814),
  ScreenshotTarget.tablet10: Size(509, 814),
};
// ────────────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop initialization
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    try {
      await windowManager.ensureInitialized();

      final Size windowSize;
      final TitleBarStyle titleBarStyle;

      if (kScreenshotMode) {
        windowSize = _screenshotSizes[kScreenshotTarget]!;
        titleBarStyle = TitleBarStyle.hidden;
      } else {
        windowSize = const Size(900, 750);
        titleBarStyle = TitleBarStyle.normal;
      }

      final windowOptions = WindowOptions(
        center: true,
        skipTaskbar: false,
        titleBarStyle: titleBarStyle,
        title: 'Kryptix',
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setSize(windowSize);
        if (kScreenshotMode) {
          await windowManager.setPosition(Offset.zero);
        } else {
          await windowManager.center();
        }
        await windowManager.show();
        await windowManager.focus();
      });

      if (!kScreenshotMode) {
        final systemTray = SystemTray();
        await systemTray.initSystemTray(
          title: 'Kryptix',
          iconPath: 'assets/images/logo.png',
        );

        final menu = Menu();
        await menu.buildFrom([
          MenuItemLabel(
            label: 'Show',
            onClicked: (menuItem) async => windowManager.show(),
          ),
          MenuItemLabel(
            label: 'Hide',
            onClicked: (menuItem) async => windowManager.hide(),
          ),
          MenuSeparator(),
          MenuItemLabel(label: 'Exit', onClicked: (menuItem) => exit(0)),
        ]);

        await systemTray.setContextMenu(menu);

        systemTray.registerSystemTrayEventHandler((eventName) {
          if (eventName == kSystemTrayEventClick) {
            unawaited(
              windowManager.isVisible().then((isVisible) async {
                if (isVisible) {
                  await windowManager.hide();
                } else {
                  await windowManager.show();
                }
              }),
            );
          }
        });
      }
    } on Exception catch (e) {
      debugPrint('Desktop initialization failed: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final storageService = StorageService(prefs, secureStorage);

  runApp(KryptixApp(storageService: storageService));
}

/// The main entry point for the Kryptix application.
class KryptixApp extends StatelessWidget {
  /// Creates a [KryptixApp] with the required [StorageService].
  const KryptixApp({required this.storageService, super.key});

  /// The service used for persistent storage.
  final StorageService storageService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordGeneratorCubit(storageService),
      child: BlocBuilder<PasswordGeneratorCubit, PasswordGeneratorState>(
        buildWhen: (previous, current) => previous.locale != current.locale,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: KryptixTheme.light,
            darkTheme: KryptixTheme.dark,
            locale: Locale(state.locale),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: storageService.hasCompletedOnboarding()
                ? const HomePage()
                : const OnboardingPage(),
          );
        },
      ),
    );
  }
}
