# openapi.api.PurchaseOrdersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approvePurchaseOrder**](PurchaseOrdersApi.md#approvepurchaseorder) | **POST** /purchase-orders/{purchaseId}/approve | Approves purchase order.
[**disapprovePurchaseOrder**](PurchaseOrdersApi.md#disapprovepurchaseorder) | **POST** /purchase-orders/{purchaseId}/disapprove | Disapproves purchase order.
[**notifyPurchaseOrderReview**](PurchaseOrdersApi.md#notifypurchaseorderreview) | **POST** /purchase-orders/{purchaseId}/notify-review | Notify review.


# **approvePurchaseOrder**
> GenericResponse approvePurchaseOrder(purchaseId)

Approves purchase order.

Approves a specific purchase order.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PurchaseOrdersApi();
final purchaseId = 5435201; // String | Purchase order ID.

try {
    final result = api_instance.approvePurchaseOrder(purchaseId);
    print(result);
} catch (e) {
    print('Exception when calling PurchaseOrdersApi->approvePurchaseOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **purchaseId** | **String**| Purchase order ID. | 

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, applications/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **disapprovePurchaseOrder**
> GenericResponse disapprovePurchaseOrder(purchaseId, disapprovePurchaseOrderCommand)

Disapproves purchase order.

Disapproves a specific purchase order.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PurchaseOrdersApi();
final purchaseId = 5435201; // String | Purchase order ID.
final disapprovePurchaseOrderCommand = DisapprovePurchaseOrderCommand(); // DisapprovePurchaseOrderCommand | Data for disapproval.

try {
    final result = api_instance.disapprovePurchaseOrder(purchaseId, disapprovePurchaseOrderCommand);
    print(result);
} catch (e) {
    print('Exception when calling PurchaseOrdersApi->disapprovePurchaseOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **purchaseId** | **String**| Purchase order ID. | 
 **disapprovePurchaseOrderCommand** | [**DisapprovePurchaseOrderCommand**](DisapprovePurchaseOrderCommand.md)| Data for disapproval. | 

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, applications/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notifyPurchaseOrderReview**
> GenericResponse notifyPurchaseOrderReview(purchaseId, approverId)

Notify review.

NNotify a purchase order review request to an approver.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PurchaseOrdersApi();
final purchaseId = 5435201; // String | Purchase order ID.
final approverId = E-12323; // String | Approver ID (employee BP).

try {
    final result = api_instance.notifyPurchaseOrderReview(purchaseId, approverId);
    print(result);
} catch (e) {
    print('Exception when calling PurchaseOrdersApi->notifyPurchaseOrderReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **purchaseId** | **String**| Purchase order ID. | 
 **approverId** | **String**| Approver ID (employee BP). | 

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, applications/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

