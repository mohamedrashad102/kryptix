import 'package:flutter/material.dart';

/// A stylized container with a "Bento" look, common in modern UI.
class BentoCard extends StatelessWidget {
  /// Creates a [BentoCard].
  const BentoCard({
    required this.title,
    required this.icon,
    required this.child,
    super.key,
    this.highlight = false,
  });

  /// The title of the card.
  final String title;

  /// The icon representing the card's purpose.
  final IconData icon;

  /// The content of the card.
  final Widget child;

  /// Whether to apply a highlight effect to the card.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: highlight
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: highlight ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: highlight
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: highlight ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
