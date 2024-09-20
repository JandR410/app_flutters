//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PurchaseOrdersApi {
  PurchaseOrdersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Approves purchase order.
  ///
  /// Approves a specific purchase order.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [ApprovePurchaseOrderCommand] approvePurchaseOrderCommand (required):
  ///   Data for Approver.
  Future<Response> approvePurchaseOrderWithHttpInfo(String purchaseId, ApprovePurchaseOrderCommand approvePurchaseOrderCommand,) async {
    // ignore: prefer_const_declarations
    final path = r'/purchase-orders/{purchaseId}/approve'
      .replaceAll('{purchaseId}', purchaseId);

    // ignore: prefer_final_locals
    Object? postBody = approvePurchaseOrderCommand;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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

  /// Approves purchase order.
  ///
  /// Approves a specific purchase order.
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [ApprovePurchaseOrderCommand] approvePurchaseOrderCommand (required):
  ///   Data for Approver.
  Future<GenericResponse?> approvePurchaseOrder(String purchaseId, ApprovePurchaseOrderCommand approvePurchaseOrderCommand,) async {
    final response = await approvePurchaseOrderWithHttpInfo(purchaseId, approvePurchaseOrderCommand,);
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

  /// Disapproves purchase order.
  ///
  /// Disapproves a specific purchase order.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [DisapprovePurchaseOrderCommand] disapprovePurchaseOrderCommand (required):
  ///   Data for disapproval.
  Future<Response> disapprovePurchaseOrderWithHttpInfo(String purchaseId, DisapprovePurchaseOrderCommand disapprovePurchaseOrderCommand,) async {
    // ignore: prefer_const_declarations
    final path = r'/purchase-orders/{purchaseId}/disapprove'
      .replaceAll('{purchaseId}', purchaseId);

    // ignore: prefer_final_locals
    Object? postBody = disapprovePurchaseOrderCommand;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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

  /// Disapproves purchase order.
  ///
  /// Disapproves a specific purchase order.
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [DisapprovePurchaseOrderCommand] disapprovePurchaseOrderCommand (required):
  ///   Data for disapproval.
  Future<GenericResponse?> disapprovePurchaseOrder(String purchaseId, DisapprovePurchaseOrderCommand disapprovePurchaseOrderCommand,) async {
    final response = await disapprovePurchaseOrderWithHttpInfo(purchaseId, disapprovePurchaseOrderCommand,);
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

  /// Notify review.
  ///
  /// Notify a purchase order review request to an approver.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [String] approverId (required):
  ///   Approver ID (employee BP).
  Future<Response> notifyPurchaseOrderReviewWithHttpInfo(String purchaseId, String approverId,) async {
    // ignore: prefer_const_declarations
    final path = r'/purchase-orders/{purchaseId}/notify-review'
      .replaceAll('{purchaseId}', purchaseId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'approverId', approverId));

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

  /// Notify review.
  ///
  /// Notify a purchase order review request to an approver.
  ///
  /// Parameters:
  ///
  /// * [String] purchaseId (required):
  ///   Purchase order ID.
  ///
  /// * [String] approverId (required):
  ///   Approver ID (employee BP).
  Future<GenericResponse?> notifyPurchaseOrderReview(String purchaseId, String approverId,) async {
    final response = await notifyPurchaseOrderReviewWithHttpInfo(purchaseId, approverId,);
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
