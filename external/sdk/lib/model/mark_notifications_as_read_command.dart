//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MarkNotificationsAsReadCommand {
  /// Returns a new [MarkNotificationsAsReadCommand] instance.
  MarkNotificationsAsReadCommand({
    this.notificationIds = const [],
  });

  /// List of notification identifiers.
  List<String>? notificationIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MarkNotificationsAsReadCommand &&
    _deepEquality.equals(other.notificationIds, notificationIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (notificationIds == null ? 0 : notificationIds!.hashCode);

  @override
  String toString() => 'MarkNotificationsAsReadCommand[notificationIds=$notificationIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.notificationIds != null) {
      json[r'notificationIds'] = this.notificationIds;
    } else {
      json[r'notificationIds'] = null;
    }
    return json;
  }

  /// Returns a new [MarkNotificationsAsReadCommand] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MarkNotificationsAsReadCommand? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MarkNotificationsAsReadCommand[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MarkNotificationsAsReadCommand[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MarkNotificationsAsReadCommand(
        notificationIds: json[r'notificationIds'] is Iterable
            ? (json[r'notificationIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<MarkNotificationsAsReadCommand> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MarkNotificationsAsReadCommand>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MarkNotificationsAsReadCommand.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MarkNotificationsAsReadCommand> mapFromJson(dynamic json) {
    final map = <String, MarkNotificationsAsReadCommand>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MarkNotificationsAsReadCommand.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MarkNotificationsAsReadCommand-objects as value to a dart map
  static Map<String, List<MarkNotificationsAsReadCommand>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MarkNotificationsAsReadCommand>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MarkNotificationsAsReadCommand.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'notificationIds',
  };
}

