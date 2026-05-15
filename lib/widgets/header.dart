import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../pages/settings_page.dart';

/// The application header containing the title and help info.
class Header extends StatelessWidget {
  /// Creates a [Header].
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appTitle,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              l10n.deterministicSecurity,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(width: 40),
        IconButton(
          icon: Icon(
            Icons.settings_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
          ),
          tooltip: l10n.settings,
        ),
      ],
    );
  }
}
