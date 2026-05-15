import 'package:equatable/equatable.dart';

/// Represents a service that has been saved in the history.
class SavedService extends Equatable {
  /// Creates a [SavedService].
  const SavedService({required this.name, required this.version});

  /// Factory constructor to create a [SavedService] from a JSON map.
  factory SavedService.fromJson(Map<String, dynamic> json) {
    return SavedService(
      name: json['name'] as String,
      version: json['version'] as int,
    );
  }

  /// The name of the service (e.g., website URL).
  final String name;

  /// The version of the password generation for this service.
  final int version;

  /// Converts this [SavedService] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }

  @override
  List<Object?> get props => [name, version];
}
