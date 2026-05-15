part of 'password_generator_cubit.dart';

/// The state of the password generator.
class PasswordGeneratorState extends Equatable {
  /// Creates a [PasswordGeneratorState].
  const PasswordGeneratorState({
    required this.masterKey,
    required this.website,
    required this.length,
    required this.version,
    required this.generatedPassword,
    required this.obscureMasterKey,
    required this.obscureResult,
    required this.recentServices,
    required this.saveMasterKeyPreference,
    required this.isAuthenticated,
    required this.locale,
  });

  /// The initial state with default values.
  factory PasswordGeneratorState.initial() {
    return const PasswordGeneratorState(
      masterKey: '',
      website: '',
      length: 16,
      version: 1,
      generatedPassword: '',
      obscureMasterKey: true,
      obscureResult: true,
      recentServices: [],
      saveMasterKeyPreference: false,
      isAuthenticated: false,
      locale: 'en',
    );
  }

  /// The master key input by the user.
  final String masterKey;

  /// The website or service name.
  final String website;

  /// The desired password length.
  final int length;

  /// The rotation version.
  final int version;

  /// The generated password.
  final String generatedPassword;

  /// Whether to obscure the master key input.
  final bool obscureMasterKey;

  /// Whether to obscure the generated password.
  final bool obscureResult;

  /// A list of recently used services.
  final List<SavedService> recentServices;

  /// Whether the user wants to save the master key locally.
  final bool saveMasterKeyPreference;

  /// Whether the user has successfully authenticated for the current session.
  final bool isAuthenticated;

  /// The current locale of the application.
  final String locale;

  /// Creates a copy of this state with the given fields replaced.
  PasswordGeneratorState copyWith({
    String? masterKey,
    String? website,
    int? length,
    int? version,
    String? generatedPassword,
    bool? obscureMasterKey,
    bool? obscureResult,
    List<SavedService>? recentServices,
    bool? saveMasterKeyPreference,
    bool? isAuthenticated,
    String? locale,
  }) {
    return PasswordGeneratorState(
      masterKey: masterKey ?? this.masterKey,
      website: website ?? this.website,
      length: length ?? this.length,
      version: version ?? this.version,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      obscureMasterKey: obscureMasterKey ?? this.obscureMasterKey,
      obscureResult: obscureResult ?? this.obscureResult,
      recentServices: recentServices ?? this.recentServices,
      saveMasterKeyPreference:
          saveMasterKeyPreference ?? this.saveMasterKeyPreference,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [
    masterKey,
    website,
    length,
    version,
    generatedPassword,
    obscureMasterKey,
    obscureResult,
    recentServices,
    saveMasterKeyPreference,
    isAuthenticated,
    locale,
  ];
}
