import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'bento_card.dart';

/// A card that displays the resulting generated password.
class ResultDisplay extends StatelessWidget {
  /// Creates a [ResultDisplay].
  const ResultDisplay({
    required this.password,
    required this.obscureText,
    required this.onToggleObscure,
    required this.onCopy,
    super.key,
  });

  /// The generated password to display.
  final String password;

  /// Whether the password should be hidden.
  final bool obscureText;

  /// Callback to toggle password visibility.
  final VoidCallback onToggleObscure;

  /// Callback to copy the password.
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final hasPassword = password.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: hasPassword ? onCopy : null,
        child: BentoCard(
          title: l10n.generatedPassword,
          icon: Icons.output_rounded,
          highlight: hasPassword,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  !hasPassword
                      ? l10n.waiting
                      : (obscureText ? '••••••••••••••••' : password),
                  style: TextStyle(
                    fontFamily: 'Fira Code',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: obscureText ? 4 : 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasPassword) ...[
                IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                  onPressed: onToggleObscure,
                  tooltip: obscureText ? l10n.showPassword : l10n.hidePassword,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                  ),
                  onPressed: onCopy,
                  tooltip: l10n.copyToClipboard,
                  color: colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
