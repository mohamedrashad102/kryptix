import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// A visual indicator for the strength of a master key.
class MasterKeyStrength extends StatelessWidget {
  /// Creates a [MasterKeyStrength].
  const MasterKeyStrength({
    required this.masterKey,
    super.key,
  });

  /// The master key string to analyze.
  final String masterKey;

  double _calculateStrength() {
    if (masterKey.isEmpty) return 0;
    var strength = 0.0;

    // Length contribution
    strength += (masterKey.length / 20).clamp(0, 0.4);

    // Complexity contribution
    if (RegExp('[A-Z]').hasMatch(masterKey)) strength += 0.2;
    if (RegExp('[0-9]').hasMatch(masterKey)) strength += 0.2;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(masterKey)) strength += 0.2;

    return strength.clamp(0, 1);
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.3) return Colors.redAccent;
    if (strength < 0.7) return Colors.orangeAccent;
    return Colors.green;
  }

  String _getStrengthText(double strength, AppLocalizations l10n) {
    if (strength == 0) return '';
    if (strength < 0.3) return l10n.weak;
    if (strength < 0.7) return l10n.medium;
    return l10n.strong;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strength = _calculateStrength();
    final color = _getStrengthColor(strength);
    final strengthText = _getStrengthText(strength, l10n);

    if (strengthText.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: strength,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.masterKeyStrength(strengthText),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
