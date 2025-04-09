import 'package:dio/dio.dart';
import 'package:openapi/api.dart' as openapi;

class APIClient {
  final openapi.ApiClient _client;
  late final openapi.PetApi _petApi;
  late final openapi.StoreApi _storeApi;
  late final openapi.UserApi _userApi;

  APIClient()
      : _client =
            openapi.ApiClient(basePath: 'https://petstore3.swagger.io/api/v3') {
    _petApi = openapi.PetApi(_client);
    _storeApi = openapi.StoreApi(_client);
    _userApi = openapi.UserApi(_client);
  }

  openapi.PetApi get petApi => _petApi;
  openapi.StoreApi get storeApi => _storeApi;
  openapi.UserApi get userApi => _userApi;

  // Eski metodları yeni API sınıflarını kullanacak şekilde güncelle
  Future<Map<String, dynamic>> getPetById(int id) async {
    final pet = await _petApi.getPetById(id);
    return pet?.toJson() ?? {};
  }

  Future<Response> request({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    final dio = Dio()..options.baseUrl = 'https://petstore3.swagger.io/api/v3';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    try {
      final response = await dio.request(
        path,
        options: Options(method: method),
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      print('API İsteği Hatası: ${e.message}');
      rethrow;
    }
  }
}
