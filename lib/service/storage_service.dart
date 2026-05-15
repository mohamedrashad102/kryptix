import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_service.dart';

/// A service to handle persistent storage using SharedPreferences and
/// SecureStorage.
class StorageService {
  /// Creates a [StorageService] with the provided dependencies.
  StorageService(this._prefs, this._secureStorage);

  static const String _recentServicesKey = 'recent_services_v2';
  static const String _saveMasterKeyPrefKey = 'save_master_key_pref';
  static const String _languagePrefKey = 'language_pref';
  static const String _onboardingKey = 'has_completed_onboarding';
  static const String _masterKeySecureKey = 'master_key_secure';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  /// Sets whether the user has completed the onboarding flow.
  Future<void> setOnboardingCompleted({required bool value}) async {
    await _prefs.setBool(_onboardingKey, value);
  }

  /// Retrieves whether the user has completed the onboarding flow.
  bool hasCompletedOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  /// Sets the user's language preference.
  Future<void> setLanguagePreference(String languageCode) async {
    await _prefs.setString(_languagePrefKey, languageCode);
  }

  /// Retrieves the user's language preference.
  String? getLanguagePreference() {
    return _prefs.getString(_languagePrefKey);
  }

  /// Sets whether the master key should be saved locally.
  Future<void> setSaveMasterKeyPreference({required bool value}) async {
    await _prefs.setBool(_saveMasterKeyPrefKey, value);
    if (!value) {
      await deleteMasterKey();
    }
  }

  /// Retrieves whether the user wants to save the master key locally.
  bool getSaveMasterKeyPreference() {
    return _prefs.getBool(_saveMasterKeyPrefKey) ?? false;
  }

  /// Securely saves the master key.
  Future<void> saveMasterKey(String masterKey) async {
    if (getSaveMasterKeyPreference()) {
      await _secureStorage.write(key: _masterKeySecureKey, value: masterKey);
    }
  }

  /// Retrieves the securely saved master key.
  Future<String?> getMasterKey() async {
    if (getSaveMasterKeyPreference()) {
      return _secureStorage.read(key: _masterKeySecureKey);
    }
    return null;
  }

  /// Deletes the master key from secure storage.
  Future<void> deleteMasterKey() async {
    await _secureStorage.delete(key: _masterKeySecureKey);
  }

  /// Saves or updates a service in the history with its version.
  Future<void> saveService(SavedService service) async {
    if (service.name.isEmpty) return;

    final services = getRecentServices()
      ..removeWhere((s) => s.name == service.name)
      ..insert(0, service);

    // Keep only last 50 services (increased from 20)
    if (services.length > 50) {
      services.removeLast();
    }

    final jsonList = services.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_recentServicesKey, jsonList);
  }

  /// Retrieves the list of recently used services.
  List<SavedService> getRecentServices() {
    final jsonList = _prefs.getStringList(_recentServicesKey) ?? [];
    return jsonList
        .map((j) {
          try {
            return SavedService.fromJson(jsonDecode(j) as Map<String, dynamic>);
          } on FormatException catch (_) {
            return null;
          }
        })
        .whereType<SavedService>()
        .toList();
  }

  /// Removes a service from the history.
  Future<void> deleteService(String serviceName) async {
    final services = getRecentServices()
      ..removeWhere((s) => s.name == serviceName);
    final jsonList = services.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_recentServicesKey, jsonList);
  }

  /// Clears all service history.
  Future<void> clearAllHistory() async {
    await _prefs.remove(_recentServicesKey);
  }

  /// Resets the onboarding status so the user sees it again.
  Future<void> resetOnboarding() async {
    await _prefs.setBool(_onboardingKey, false);
  }
}
