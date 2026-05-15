import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// A deterministic password generator that creates secure passwords
/// based on a master key and a service name (e.g., website).
class PasswordGenerator {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = r'!@#$%^&*()-_=+[]{}|;:,.<>?';

  static const String _allChars = '$_lowercase$_uppercase$_numbers$_symbols';

  /// Number of iterations for key stretching to harden against brute-force.
  static const int _iterations = 50000;

  /// Generates a deterministic password using a deterministic mapping.
  ///
  /// [masterKey] is the user's secret key.
  /// [website] is the service identifier (e.g., "google.com").
  /// [length] is the desired length of the password.
  /// [version] is the version of the password (starts at 1).
  static String generate({
    required String masterKey,
    required String website,
    int length = 16,
    int version = 1,
  }) {
    if (masterKey.isEmpty || website.isEmpty || length <= 0) return '';

    // Normalize website for consistency
    final normalizedWebsite = website.trim().toLowerCase();

    // Include version in the source string to ensure different passwords
    // per version
    final initialBytes = utf8.encode('$masterKey$normalizedWebsite$version');

    // Phase 1: Key Stretching
    // Run SHA-256 for multiple iterations to make brute-forcing slow.
    var currentBytes = Uint8List.fromList(initialBytes);
    for (var i = 0; i < _iterations; i++) {
      currentBytes = Uint8List.fromList(sha256.convert(currentBytes).bytes);
    }

    return _generateDeterministic(currentBytes, length);
  }

  /// Algorithm: Deterministic mapping to the full character alphabet.
  static String _generateDeterministic(List<int> bytes, int length) {
    var currentHash = bytes;
    final result = StringBuffer();

    while (result.length < length) {
      for (final byte in currentHash) {
        if (result.length >= length) break;
        result.write(_allChars[byte % _allChars.length]);
      }

      if (result.length < length) {
        currentHash = sha256.convert(currentHash).bytes;
      }
    }

    return result.toString();
  }
}
