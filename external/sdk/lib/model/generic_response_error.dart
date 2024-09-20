//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GenericResponseError {
  /// Returns a new [GenericResponseError] instance.
  GenericResponseError({
    required this.code,
    this.message,
    this.params = const [],
  });

  /// Error code.
  String code;

  /// Friendly message for an end user.
  String? message;

  /// Parameters associated with the error code that can be used to prepare the appropriate message to be displayed in the application.
  List<String>? params;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GenericResponseError &&
    other.code == code &&
    other.message == message &&
    _deepEquality.equals(other.params, params);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (params == null ? 0 : params!.hashCode);

  @override
  String toString() => 'GenericResponseError[code=$code, message=$message, params=$params]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = this.code;
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.params != null) {
      json[r'params'] = this.params;
    } else {
      json[r'params'] = null;
    }
    return json;
  }

  /// Returns a new [GenericResponseError] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GenericResponseError? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GenericResponseError[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GenericResponseError[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GenericResponseError(
        code: mapValueOfType<String>(json, r'code')!,
        message: mapValueOfType<String>(json, r'message'),
        params: json[r'params'] is Iterable
            ? (json[r'params'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<GenericResponseError> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GenericResponseError>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GenericResponseError.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GenericResponseError> mapFromJson(dynamic json) {
    final map = <String, GenericResponseError>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GenericResponseError.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GenericResponseError-objects as value to a dart map
  static Map<String, List<GenericResponseError>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GenericResponseError>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GenericResponseError.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
  };
}

