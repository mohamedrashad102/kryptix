import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../l10n/app_localizations.dart';
import '../models/saved_service.dart';
import '../service/password_generator.dart';
import '../service/storage_service.dart';

part 'password_generator_state.dart';

/// Helper for compute function.
String _generatePasswordIsolate(Map<String, dynamic> params) {
  return PasswordGenerator.generate(
    masterKey: params['masterKey'] as String,
    website: params['website'] as String,
    length: params['length'] as int,
    version: params['version'] as int,
  );
}

/// Manages the state and business logic for the password generator.
class PasswordGeneratorCubit extends Cubit<PasswordGeneratorState> {
  /// Creates a [PasswordGeneratorCubit] with the required [StorageService].
  PasswordGeneratorCubit(this._storageService)
    : super(PasswordGeneratorState.initial()) {
    unawaited(_init());
  }

  final StorageService _storageService;
  final _localAuth = LocalAuthentication();
  Timer? _debounce;

  Future<void> _init() async {
    final saveMasterKey = _storageService.getSaveMasterKeyPreference();
    final savedLocale = _storageService.getLanguagePreference();

    // Default to English if no preference is saved
    final locale = savedLocale ?? 'en';

    String? masterKey;
    var authenticated = false;

    if (saveMasterKey) {
      try {
        final l10n = await AppLocalizations.delegate.load(Locale(locale));
        authenticated = await _localAuth.authenticate(
          localizedReason: l10n.saveMasterKeySubtitle,
          persistAcrossBackgrounding: true,
        );
      } on Exception catch (e) {
        debugPrint('Biometric auth failed: $e');
        authenticated = false;
      }

      if (authenticated) {
        masterKey = await _storageService.getMasterKey();
      }
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          saveMasterKeyPreference: saveMasterKey,
          isAuthenticated: authenticated,
          locale: locale,
          masterKey: masterKey ?? '',
          recentServices: _storageService.getRecentServices()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            ),
        ),
      );
      _generate();
    }
  }

  /// Updates the application locale.
  Future<void> updateLocale(String languageCode) async {
    await _storageService.setLanguagePreference(languageCode);
    emit(state.copyWith(locale: languageCode));
  }

  /// Marks the onboarding as completed.
  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingCompleted(value: true);
  }

  /// Resets the onboarding status.
  Future<void> resetOnboarding() async {
    await _storageService.resetOnboarding();
  }

  /// Updates the master key and regenerates the password.
  void updateMasterKey(String value) {
    emit(state.copyWith(masterKey: value));
    // Only save if the user is authenticated for this session
    if (state.saveMasterKeyPreference && state.isAuthenticated) {
      unawaited(_storageService.saveMasterKey(value));
    }
    _generate();
  }

  /// Updates the service name and regenerates the password.
  void updateWebsite(String value) {
    emit(state.copyWith(website: value));
    _generate();
  }

  /// Selects a service from history, updating both name and version.
  void selectService(SavedService service) {
    emit(state.copyWith(website: service.name, version: service.version));
    _generate();
  }

  /// Adds a new service to history.
  Future<void> addService(SavedService service) async {
    await _storageService.saveService(service);
    final services = _storageService.getRecentServices()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(state.copyWith(recentServices: services));
  }

  /// Updates an existing service's details.
  Future<void> updateService(String oldName, SavedService newService) async {
    if (oldName != newService.name) {
      await _storageService.deleteService(oldName);
    }
    await _storageService.saveService(newService);
    final services = _storageService.getRecentServices()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(state.copyWith(recentServices: services));
  }

  /// Updates the desired length and regenerates the password.
  void updateLength(int value) {
    emit(state.copyWith(length: value));
    _generate();
  }

  /// Updates the rotation version and regenerates the password.
  void updateVersion(int value) {
    if (value < 1) return;
    emit(state.copyWith(version: value));

    // If the service is already saved in history, auto-save the new version.
    final existingIndex = state.recentServices.indexWhere(
      (s) => s.name.toLowerCase() == state.website.toLowerCase(),
    );
    if (existingIndex != -1) {
      unawaited(saveCurrentService());
    }

    _generate();
  }

  /// Increments the rotation version.
  void incrementVersion() => updateVersion(state.version + 1);

  /// Decrements the rotation version.
  void decrementVersion() => updateVersion(state.version - 1);

  /// Toggles the visibility of the master key input.
  void toggleMasterKeyVisibility() {
    emit(state.copyWith(obscureMasterKey: !state.obscureMasterKey));
  }

  /// Toggles the visibility of the generated password.
  void toggleResultVisibility() {
    emit(state.copyWith(obscureResult: !state.obscureResult));
  }

  /// Toggles whether the master key should be saved locally.
  Future<void> toggleSaveMasterKeyPreference() async {
    final newValue = !state.saveMasterKeyPreference;
    await _storageService.setSaveMasterKeyPreference(value: newValue);
    if (newValue) {
      await _storageService.saveMasterKey(state.masterKey);
    }
    emit(state.copyWith(saveMasterKeyPreference: newValue));
  }

  /// Saves the current service name and version to persistent history.
  Future<void> saveCurrentService() async {
    if (state.website.isNotEmpty) {
      final service = SavedService(name: state.website, version: state.version);
      await _storageService.saveService(service);
      final services = _storageService.getRecentServices()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      emit(state.copyWith(recentServices: services));
    }
  }

  /// Deletes a specific service from history.
  Future<void> deleteService(String serviceName) async {
    await _storageService.deleteService(serviceName);
    final services = _storageService.getRecentServices()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(state.copyWith(recentServices: services));
  }

  /// Clears all service history.
  Future<void> clearAllHistory() async {
    await _storageService.clearAllHistory();
    emit(state.copyWith(recentServices: []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void _generate() {
    _debounce?.cancel();

    if (state.masterKey.isEmpty || state.website.isEmpty) {
      emit(state.copyWith(generatedPassword: ''));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final password = await compute(_generatePasswordIsolate, {
        'masterKey': state.masterKey,
        'website': state.website,
        'length': state.length,
        'version': state.version,
      });
      if (!isClosed) emit(state.copyWith(generatedPassword: password));
    });
  }
}
