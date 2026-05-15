import 'package:flutter/material.dart';

/// A centralized theme configuration for the application.
abstract final class KryptixTheme {
  static const _primaryBlue = Color(0xFF0369A1); // Sky 700
  static const _emeraldGreen = Color(0xFF059669); // Emerald 600
  static const _slate50 = Color(0xFFF8FAFC);
  static const _slate950 = Color(0xFF020617);

  /// The light theme configuration.
  static ThemeData get light => _buildTheme(Brightness.light);

  /// The dark theme configuration.
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: isDark ? const Color(0xFF0EA5E9) : _primaryBlue,
      surface: isDark ? _slate950 : _slate50,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Plus Jakarta Sans',
    );
  }

  /// Displays a success message using a styled SnackBar.
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: _emeraldGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        width: 340,
      ),
    );
  }
}
