import 'package:dio/dio.dart';

/// APIClient sınıfı, PetStore API'sine erişmek için kullanılacak temel istemci.
/// Bu sınıf, Dio HTTP istemcisini yapılandırır ve API isteklerini yönetir.
class APIClient {
  final Dio _dio;

  // API endpoint'leri için temel URL
  static const String baseUrl = 'https://petstore3.swagger.io/api/v3';

  /// APIClient yapıcı metodu.
  /// İsteğe bağlı bir Dio örneği alabilir veya varsayılan olarak yeni bir tane oluşturabilir.
  APIClient({Dio? dio}) : _dio = dio ?? Dio() {
    // Dio istemcisini yapılandır
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // İstek/yanıt yakalamak için interceptor ekle
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Manuel API çağrısı yapmak için kullanılabilir basit bir metot.
  /// OpenAPI oluşturucusu kullanılmadan önce veya ek işlevsellik için.
  Future<Response> request({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        options: Options(method: method, headers: headers),
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
    try {
      final response = await request(path: '/pet/$id');
      return response.data;
    } catch (e) {
      print('Pet Getirme Hatası: $e');
      rethrow;
    }
  }
}
