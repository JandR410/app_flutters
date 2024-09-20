//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class NotificationsApi {
  NotificationsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Activate or deactivate  notifications.
  ///
  /// Activate or deactivate push notification for all devices that the user has the application installed.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [bool] status (required):
  ///   status for employee notification.
  Future<Response> configureNotificationsWithHttpInfo(bool status,) async {
    // ignore: prefer_const_declarations
    final path = r'/configure-notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'status', status));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Activate or deactivate  notifications.
  ///
  /// Activate or deactivate push notification for all devices that the user has the application installed.
  ///
  /// Parameters:
  ///
  /// * [bool] status (required):
  ///   status for employee notification.
  Future<GenericResponse?> configureNotifications(bool status,) async {
    final response = await configureNotificationsWithHttpInfo(status,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GenericResponse',) as GenericResponse;
    
    }
    return null;
  }

  /// Marks specific notifications as read.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MarkNotificationsAsReadCommand] markNotificationsAsReadCommand (required):
  ///   Data for mark notifications as read.
  Future<Response> markAsReadWithHttpInfo(MarkNotificationsAsReadCommand markNotificationsAsReadCommand,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/mark-as-read';

    // ignore: prefer_final_locals
    Object? postBody = markNotificationsAsReadCommand;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Marks specific notifications as read.
  ///
  /// Parameters:
  ///
  /// * [MarkNotificationsAsReadCommand] markNotificationsAsReadCommand (required):
  ///   Data for mark notifications as read.
  Future<GenericResponse?> markAsRead(MarkNotificationsAsReadCommand markNotificationsAsReadCommand,) async {
    final response = await markAsReadWithHttpInfo(markNotificationsAsReadCommand,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GenericResponse',) as GenericResponse;
    
    }
    return null;
  }
}
