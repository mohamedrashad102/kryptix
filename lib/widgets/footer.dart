import 'package:flutter/material.dart';

/// A technical footer displaying the algorithms and philosophy of the app.
class Footer extends StatelessWidget {
  /// Creates a [Footer].
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'SHA-256 • BASE64-URL • ZERO-KNOWLEDGE',
      style: TextStyle(
        fontFamily: 'Fira Code',
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        letterSpacing: 2,
      ),
    );
  }
}
