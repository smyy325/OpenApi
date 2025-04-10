# openapi.api.StoreApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteOrder**](StoreApi.md#deleteorder) | **DELETE** /store/order/{orderId} | Delete purchase order by identifier.
[**getInventory**](StoreApi.md#getinventory) | **GET** /store/inventory | Returns pet inventories by status.
[**getOrderById**](StoreApi.md#getorderbyid) | **GET** /store/order/{orderId} | Find purchase order by ID.
[**placeOrder**](StoreApi.md#placeorder) | **POST** /store/order | Place an order for a pet.


# **deleteOrder**
> deleteOrder(orderId)

Delete purchase order by identifier.

For valid response try integer IDs with value < 1000. Anything above 1000 or non-integers will generate API errors.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStoreApi();
final int orderId = 789; // int | ID of the order that needs to be deleted

try {
    api.deleteOrder(orderId);
} catch on DioException (e) {
    print('Exception when calling StoreApi->deleteOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**| ID of the order that needs to be deleted | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInventory**
> BuiltMap<String, int> getInventory()

Returns pet inventories by status.

Returns a map of status codes to quantities.

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: api_key
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('api_key').apiKeyPrefix = 'Bearer';

final api = Openapi().getStoreApi();

try {
    final response = api.getInventory();
    print(response);
} catch on DioException (e) {
    print('Exception when calling StoreApi->getInventory: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**BuiltMap&lt;String, int&gt;**

### Authorization

[api_key](../README.md#api_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrderById**
> Order getOrderById(orderId)

Find purchase order by ID.

For valid response try integer IDs with value <= 5 or > 10. Other values will generate exceptions.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStoreApi();
final int orderId = 789; // int | ID of order that needs to be fetched

try {
    final response = api.getOrderById(orderId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StoreApi->getOrderById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**| ID of order that needs to be fetched | 

### Return type

[**Order**](Order.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **placeOrder**
> Order placeOrder(order)

Place an order for a pet.

Place a new order in the store.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStoreApi();
final Order order = ; // Order | 

try {
    final response = api.placeOrder(order);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StoreApi->placeOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **order** | [**Order**](Order.md)|  | [optional] 

### Return type

[**Order**](Order.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, application/xml, application/x-www-form-urlencoded
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

