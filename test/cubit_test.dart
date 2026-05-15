import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kryptix/cubit/password_generator_cubit.dart';
import 'package:kryptix/models/saved_service.dart';
import 'package:kryptix/service/storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  group('PasswordGeneratorCubit', () {
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
      when(() => mockStorage.getRecentServices()).thenReturn([]);
      when(() => mockStorage.getSaveMasterKeyPreference()).thenReturn(false);
      when(() => mockStorage.getLanguagePreference()).thenReturn('en');
      when(() => mockStorage.getMasterKey()).thenAnswer((_) async => null);
    });

    test('initial state is correct', () async {
      final cubit = PasswordGeneratorCubit(mockStorage);
      // Wait for _init to complete
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, PasswordGeneratorState.initial());
      unawaited(cubit.close());
    });

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'emits correct state when master key and website are updated',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit
        ..updateMasterKey('secret')
        ..updateWebsite('google.com'),
      wait: const Duration(milliseconds: 600),
      verify: (cubit) {
        expect(cubit.state.masterKey, 'secret');
        expect(cubit.state.website, 'google.com');
        expect(cubit.state.generatedPassword, isNotEmpty);
      },
    );

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'emits correct state when length is updated with valid inputs',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit
        ..updateMasterKey('secret')
        ..updateWebsite('google.com')
        ..updateLength(20),
      wait: const Duration(milliseconds: 600),
      verify: (cubit) {
        expect(cubit.state.length, 20);
        expect(cubit.state.generatedPassword.length, 20);
      },
    );

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'toggles master key visibility',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit.toggleMasterKeyVisibility(),
      expect: () => [
        PasswordGeneratorState.initial().copyWith(obscureMasterKey: false),
      ],
    );

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'toggles result visibility',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit.toggleResultVisibility(),
      expect: () => [
        PasswordGeneratorState.initial().copyWith(obscureResult: false),
      ],
    );

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'selects a service from history',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit.selectService(
        const SavedService(name: 'github.com', version: 2),
      ),
      verify: (cubit) {
        expect(cubit.state.website, 'github.com');
        expect(cubit.state.version, 2);
      },
    );

    blocTest<PasswordGeneratorCubit, PasswordGeneratorState>(
      'does not save master key if not authenticated',
      build: () => PasswordGeneratorCubit(mockStorage),
      act: (cubit) => cubit.updateMasterKey('new-secret'),
      verify: (_) {
        verifyNever(() => mockStorage.saveMasterKey(any()));
      },
    );
  });
}
