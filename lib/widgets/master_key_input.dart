import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'bento_card.dart';
import 'master_key_strength.dart';

/// An input field for the secret master key.
class MasterKeyInput extends StatelessWidget {
  /// Creates a [MasterKeyInput].
  const MasterKeyInput({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onToggleObscure,
    required this.onSubmitted,
    super.key,
    this.onChanged,
  });

  /// Controller for the text field.
  final TextEditingController controller;

  /// Focus node for keyboard management.
  final FocusNode focusNode;

  /// Whether the text is currently obscured.
  final bool obscureText;

  /// Callback to toggle text visibility.
  final VoidCallback onToggleObscure;

  /// Callback when the user submits the field.
  final VoidCallback onSubmitted;

  /// Optional callback when the text changes.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    Color generateColor(String text) {
      if (text.isEmpty) return isDark ? Colors.white24 : Colors.black12;

      // Simple hash to generate a stable hue
      var hash = 0;
      for (var i = 0; i < text.length; i++) {
        hash = text.codeUnitAt(i) + ((hash << 5) - hash);
      }

      final hue = (hash % 360).abs().toDouble();
      return HSLColor.fromAHSL(
        1,
        hue,
        0.6, // Saturation
        isDark ? 0.6 : 0.45, // Lightness
      ).toColor();
    }

    final keyColor = generateColor(controller.text);

    return BentoCard(
      title: l10n.masterKey,
      icon: Icons.security_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            onSubmitted: (_) => onSubmitted(),
            onChanged: onChanged,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              hintText: l10n.enterMasterKey,
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: keyColor,
                    boxShadow: [
                      if (controller.text.isNotEmpty)
                        BoxShadow(
                          color: keyColor.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
                onPressed: onToggleObscure,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          MasterKeyStrength(masterKey: controller.text),
        ],
      ),
    );
  }
}
