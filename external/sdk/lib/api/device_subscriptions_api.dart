//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DeviceSubscriptionsApi {
  DeviceSubscriptionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create or update device subscription.
  ///
  /// Create or update the device subscription to send notifications to the logged in user using their FCM access token associated with their mobile device.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] fcmToken (required):
  ///   Device FCM access token.
  ///
  /// * [String] macCode (required):
  ///   Device MAC code.
  Future<Response> upsertSubscriptionWithHttpInfo(String fcmToken, String macCode,) async {
    // ignore: prefer_const_declarations
    final path = r'/device-subscriptions';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'fcmToken', fcmToken));
      queryParams.addAll(_queryParams('', 'macCode', macCode));

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

  /// Create or update device subscription.
  ///
  /// Create or update the device subscription to send notifications to the logged in user using their FCM access token associated with their mobile device.
  ///
  /// Parameters:
  ///
  /// * [String] fcmToken (required):
  ///   Device FCM access token.
  ///
  /// * [String] macCode (required):
  ///   Device MAC code.
  Future<GenericResponse?> upsertSubscription(String fcmToken, String macCode,) async {
    final response = await upsertSubscriptionWithHttpInfo(fcmToken, macCode,);
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
