# openapi.api.GeneralApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthcheck**](GeneralApi.md#healthcheck) | **GET** /healthcheck | Health Check Status.
[**heartbeat**](GeneralApi.md#heartbeat) | **GET** /heartbeat | Heartbeat Request.


# **healthcheck**
> GenericResponse healthcheck()

Health Check Status.

Performs a health check, checking integrity and dependencies.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = GeneralApi();

try {
    final result = api_instance.healthcheck();
    print(result);
} catch (e) {
    print('Exception when calling GeneralApi->healthcheck: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **heartbeat**
> GenericResponse heartbeat()

Heartbeat Request.

Checks if an HTTP Connection can be established with this API.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = GeneralApi();

try {
    final result = api_instance.heartbeat();
    print(result);
} catch (e) {
    print('Exception when calling GeneralApi->heartbeat: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GenericResponse**](GenericResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

