# openapi.api.NotificationsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**markAsRead**](NotificationsApi.md#markasread) | **PUT** /notifications/mark-as-read | Marks specific notifications as read.


# **markAsRead**
> GenericResponse markAsRead(markNotificationsAsReadCommand)

Marks specific notifications as read.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = NotificationsApi();
final markNotificationsAsReadCommand = MarkNotificationsAsReadCommand(); // MarkNotificationsAsReadCommand | Data for mark notifications as read.

try {
    final result = api_instance.markAsRead(markNotificationsAsReadCommand);
    print(result);
} catch (e) {
    print('Exception when calling NotificationsApi->markAsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markNotificationsAsReadCommand** | [**MarkNotificationsAsReadCommand**](MarkNotificationsAsReadCommand.md)| Data for mark notifications as read. | 

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, applications/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

