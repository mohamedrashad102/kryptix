import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'bento_card.dart';

/// A control for adjusting the length of the generated password.
class LengthControl extends StatelessWidget {
  /// Creates a [LengthControl].
  const LengthControl({
    required this.length,
    required this.onChanged,
    super.key,
  });

  /// The current length value.
  final double length;

  /// Callback when the length is changed.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BentoCard(
      title: l10n.passwordLength,
      icon: Icons.straighten_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${length.round()} ${l10n.chars}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Icon(Icons.bolt_rounded, size: 16, color: Colors.amber[600]),
            ],
          ),
          Slider(
            value: length,
            min: 8,
            max: 32,
            divisions: 24,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
