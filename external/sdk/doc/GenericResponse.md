# openapi.model.GenericResponse

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**transactionId** | **String** | Transaction ID. | [optional] 
**status** | **int** | Response status. It can take the following values: * `0` - Successful. * `1` - Functional failure. * `-1` - Technical failure. | [default to 0]
**message** | **String** | Human readable message. | [optional] 
**data** | [**List<GenericResponseError>**](GenericResponseError.md) | List of associated errors. | [optional] [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


