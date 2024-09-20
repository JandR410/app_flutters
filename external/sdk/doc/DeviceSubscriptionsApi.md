# openapi.api.DeviceSubscriptionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**upsertSubscription**](DeviceSubscriptionsApi.md#upsertsubscription) | **POST** /device-subscriptions | Create or update device subscription.


# **upsertSubscription**
> GenericResponse upsertSubscription(fcmToken, macCode)

Create or update device subscription.

Create or update the device subscription to send notifications to the logged in user using their FCM access token associated with their mobile device.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DeviceSubscriptionsApi();
final fcmToken = fcmToken_example; // String | Device FCM access token.
final macCode = macCode_example; // String | Device MAC code.

try {
    final result = api_instance.upsertSubscription(fcmToken, macCode);
    print(result);
} catch (e) {
    print('Exception when calling DeviceSubscriptionsApi->upsertSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fcmToken** | **String**| Device FCM access token. | 
 **macCode** | **String**| Device MAC code. | 

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, applications/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

