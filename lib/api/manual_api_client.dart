import 'package:dio/dio.dart';
import '../models/pet.dart';

/// ManualAPIClient sınıfı, PetStore API'sine OpenAPI generator olmadan erişmek için kullanılacak temel istemci.
/// Bu sınıf, Dio HTTP istemcisini kullanarak doğrudan API isteklerini yapar.
class ManualAPIClient {
  final Dio _dio;

  // API endpoint'leri için temel URL
  static const String baseUrl = 'https://petstore3.swagger.io/api/v3';

  /// ManualAPIClient yapıcı metodu.
  ManualAPIClient({Dio? dio}) : _dio = dio ?? Dio() {
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

  /// API çağrısı yapmak için kullanılacak temel metot
  Future<Response<dynamic>> request({
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

  // Pet API metodları

  /// Belirli bir durumdaki pet'leri getirir (örn. 'available').
  Future<List<Pet>> findPetsByStatus(String status) async {
    try {
      final response = await request(
        path: '/pet/findByStatus',
        queryParameters: {'status': status},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Pet.fromJson(json)).toList();
      } else {
        throw Exception('Pet listesini getirirken hata oluştu');
      }
    } catch (e) {
      print('Pet listesini getirirken hata: $e');
      rethrow;
    }
  }

  /// Belirtilen ID'ye sahip pet bilgisini getirir
  Future<Pet> getPetById(int id) async {
    try {
      final response = await request(path: '/pet/$id');

      if (response.statusCode == 200) {
        return Pet.fromJson(response.data);
      } else {
        throw Exception('Pet bilgisini getirirken hata oluştu');
      }
    } catch (e) {
      print('Pet bilgisini getirirken hata: $e');
      rethrow;
    }
  }

  /// Yeni bir pet ekler
  Future<Pet> addPet(Pet pet) async {
    try {
      final response = await request(
        path: '/pet',
        method: 'POST',
        data: pet.toJson(),
      );

      if (response.statusCode == 200) {
        return Pet.fromJson(response.data);
      } else {
        throw Exception('Pet eklerken hata oluştu');
      }
    } catch (e) {
      print('Pet eklerken hata: $e');
      rethrow;
    }
  }

  /// Pet bilgilerini günceller
  Future<Pet> updatePet(Pet pet) async {
    try {
      final response = await request(
        path: '/pet',
        method: 'PUT',
        data: pet.toJson(),
      );

      if (response.statusCode == 200) {
        return Pet.fromJson(response.data);
      } else {
        throw Exception('Pet güncellerken hata oluştu');
      }
    } catch (e) {
      print('Pet güncellerken hata: $e');
      rethrow;
    }
  }

  /// Pet siler
  Future<void> deletePet(int id) async {
    try {
      final response = await request(path: '/pet/$id', method: 'DELETE');

      if (response.statusCode != 200) {
        throw Exception('Pet silerken hata oluştu');
      }
    } catch (e) {
      print('Pet silerken hata: $e');
      rethrow;
    }
  }
}
