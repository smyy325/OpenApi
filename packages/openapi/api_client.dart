import 'package:dio/dio.dart';
import 'package:openapi/api.dart';

/// APIClient sınıfı, PetStore API'sine erişmek için kullanılacak temel istemci.
/// Bu sınıf, Dio HTTP istemcisini yapılandırır ve API isteklerini yönetir.
class APIClient {
  final ApiClient _client;
  late final PetApi _petApi;
  late final StoreApi _storeApi;
  late final UserApi _userApi;

  /// APIClient yapıcı metodu.
  APIClient()
      : _client = ApiClient(basePath: 'https://petstore3.swagger.io/api/v3') {
    _petApi = PetApi(_client);
    _storeApi = StoreApi(_client);
    _userApi = UserApi(_client);
  }

  PetApi get petApi => _petApi;
  StoreApi get storeApi => _storeApi;
  UserApi get userApi => _userApi;

  /// Manuel API çağrısı yapmak için kullanılabilir basit bir metot.
  /// OpenAPI oluşturucusu kullanılmadan önce veya ek işlevsellik için.
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
      // Hata işleme
      print('API İsteği Hatası: ${e.message}');
      rethrow;
    }
  }

  /// Pet bilgisini ID'ye göre almak için örnek bir metot
  Future<Map<String, dynamic>> getPetById(int id) async {
    final pet = await _petApi.getPetById(id);
    return pet?.toJson() ?? {};
  }
}
