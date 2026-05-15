import 'package:flutter_test/flutter_test.dart';
import 'package:kryptix/service/password_generator.dart';

void main() {
  test('Password generation is deterministic', () {
    final password = PasswordGenerator.generate(
      masterKey: 'secret',
      website: 'google.com',
      length: 14,
    );

    expect(password.length, 14);

    final p2 = PasswordGenerator.generate(
      masterKey: 'secret',
      website: 'google.com',
      length: 14,
    );
    expect(password, p2);
  });

  test('Version change alters the password', () {
    final v1 = PasswordGenerator.generate(
      masterKey: 'secret',
      website: 'google.com',
    );
    final v2 = PasswordGenerator.generate(
      masterKey: 'secret',
      website: 'google.com',
      version: 2,
    );

    expect(v1, isNot(equals(v2)));
  });

  test('Password always contains symbols, numbers and uppercase', () {
    final password = PasswordGenerator.generate(
      masterKey: 'a',
      website: 'b',
      length: 32,
    );

    expect(
      password.contains(RegExp(r'[!@#\$%^&*()\-_=+\[\]{}|;:,.<>?]')),
      isTrue,
    );
    expect(password.contains(RegExp('[0-9]')), isTrue);
    expect(password.contains(RegExp('[A-Z]')), isTrue);
    expect(password.contains(RegExp('[a-z]')), isTrue);
  });

  test('Empty inputs return empty string', () {
    expect(
      PasswordGenerator.generate(masterKey: '', website: 'google.com'),
      '',
    );
    expect(PasswordGenerator.generate(masterKey: 'secret', website: ''), '');
  });

  test('Website name is case-insensitive', () {
    final p1 = PasswordGenerator.generate(
      masterKey: 'key',
      website: 'Google.com',
    );
    final p2 = PasswordGenerator.generate(
      masterKey: 'key',
      website: 'google.com',
    );
    expect(p1, p2);
  });
}
