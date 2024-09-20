//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GenericResponse {
  /// Returns a new [GenericResponse] instance.
  GenericResponse({
    this.transactionId,
    this.status = 0,
    this.message,
    this.data = const [],
  });

  /// Transaction ID.
  String? transactionId;

  /// Response status. It can take the following values: * `0` - Successful. * `1` - Functional failure. * `-1` - Technical failure.
  int status;

  /// Human readable message.
  String? message;

  /// List of associated errors.
  List<GenericResponseError>? data;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GenericResponse &&
    other.transactionId == transactionId &&
    other.status == status &&
    other.message == message &&
    _deepEquality.equals(other.data, data);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (transactionId == null ? 0 : transactionId!.hashCode) +
    (status.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (data == null ? 0 : data!.hashCode);

  @override
  String toString() => 'GenericResponse[transactionId=$transactionId, status=$status, message=$message, data=$data]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.transactionId != null) {
      json[r'transactionId'] = this.transactionId;
    } else {
      json[r'transactionId'] = null;
    }
      json[r'status'] = this.status;
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    return json;
  }

  /// Returns a new [GenericResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GenericResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GenericResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GenericResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GenericResponse(
        transactionId: mapValueOfType<String>(json, r'transactionId'),
        status: mapValueOfType<int>(json, r'status')!,
        message: mapValueOfType<String>(json, r'message'),
        data: GenericResponseError.listFromJson(json[r'data']),
      );
    }
    return null;
  }

  static List<GenericResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GenericResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GenericResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GenericResponse> mapFromJson(dynamic json) {
    final map = <String, GenericResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GenericResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GenericResponse-objects as value to a dart map
  static Map<String, List<GenericResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GenericResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GenericResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
  };
}

