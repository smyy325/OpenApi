# Flutter OpenAPI Generator Örneği

Bu proje, Flutter'da OpenAPI Generator kullanarak REST API entegrasyonu yapmak için örnek bir uygulamadır. Swagger PetStore API'sini kullanarak, OpenAPI tanımlamasından Dart kodlarının nasıl oluşturulacağını ve kullanılacağını göstermektedir.

## Özellikler

- OpenAPI tanımlamasından Dart modelleri ve API istemcileri oluşturma
- Dio HTTP istemcisi ile API isteklerini yönetme
- Oluşturulan modellerle veri işleme
- Material Design UI ile veri görüntüleme
- Modüler mimari yapı
- Tekrar kullanılabilir widget'lar

## Kurulum

1. Bu repo'yu klonlayın:
```bash
git clone https://github.com/smyy325/OpenApi.git
cd OpenApi
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## Adım Adım OpenAPI Entegrasyonu

### 1. Gerekli Bağımlılıkları Ekleyin

`pubspec.yaml` dosyasına şu bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.7.0
  json_annotation: ^4.8.1
  built_value: ^8.6.3
  built_collection: ^5.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.8
  json_serializable: ^6.7.1
  openapi_generator: ^4.10.0
  built_value_generator: ^8.6.3
```

### 2. OpenAPI Konfigürasyonu Oluşturun

Proje kök dizininde `openapitools.json` dosyası oluşturun:

```json
{
  "$schema": "node_modules/@openapitools/openapi-generator-cli/config.schema.json",
  "spaces": 2,
  "generator-cli": {
    "version": "7.12.0",
    "generators": {
      "dart-petstore-client": {
        "generatorName": "dart",
        "inputSpec": "./api/openapi.yaml",
        "outputDir": "./lib/api/generated",
        "additionalProperties": {
          "pubName": "petstore_api",
          "pubAuthor": "OpenAPI Generator Team",
          "pubDescription": "Flutter OpenAPI Generator Example",
          "pubVersion": "1.0.0",
          "pubHomepage": "https://github.com/smyy325/flutter-openapi-example",
          "browserClient": false,
          "pubLibrary": "petstore_api"
        }
      }
    }
  }
}
```

### 3. API İstemci Wrapper Sınıfını Oluşturun

API çağrılarını yönetecek bir wrapper sınıfı oluşturun:

```dart
class APIClient {
  final Dio _dio;
  
  static const String baseUrl = 'https://petstore3.swagger.io/api/v3';
  
  APIClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
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
      print('API İsteği Hatası: ${e.message}');
      rethrow;
    }
  }
}
```

### 4. Servis Katmanı Oluşturun

API istemci ile UI arasında bir servis katmanı ekleyin:

```dart
class PetService {
  final APIClient _apiClient;
  
  PetService(this._apiClient);
  
  Future<Pet> getPetById(int id) async {
    final petData = await _apiClient.getPetById(id);
    return Pet.fromJson(petData);
  }
  
  Future<List<Pet>> getPetsByStatus(String status) async {
    final response = await _apiClient.request(
      path: '/pet/findByStatus',
      queryParameters: {'status': status},
    );
    
    final List<dynamic> petsData = response.data;
    return petsData.map((petData) => Pet.fromJson(petData)).toList();
  }
}
```

### 5. Yeniden Kullanılabilir Widget'lar Oluşturun

Tekrar kullanılabilir widget'lar oluşturarak kod tekrarını önleyin:

- LoadingIndicator
- ErrorDisplay
- EmptyState
- PetListItem
- PetDetailsCard

### 6. MVVM Pattern Kullanın

UI, servis ve API katmanlarını ayırarak daha iyi bir kod organizasyonu sağlayın.

## Proje Yapısı

```
lib/
  ├── api/               # API ile ilgili dosyalar
  │   └── api_client.dart    # API istemci wrapper sınıfı
  ├── models/            # Model sınıfları
  │   └── pet.dart           # Pet modeli 
  ├── screens/           # UI ekranları
  │   ├── home_screen.dart     # Pet detay ekranı
  │   ├── pet_list_screen.dart # Pet listesi ekranı
  │   └── add_pet_screen.dart  # Pet ekleme ekranı
  ├── services/          # Servis sınıfları
  │   └── pet_service.dart     # Pet API servis sınıfı
  ├── widgets/           # Yeniden kullanılabilir widget'lar
  │   ├── loading_indicator.dart
  │   ├── error_display.dart
  │   ├── empty_state.dart
  │   ├── pet_list_item.dart
  │   └── pet_details_card.dart
  └── main.dart          # Uygulama giriş noktası
api/
  └── openapi.yaml       # OpenAPI tanımlaması
```

## Ekran Görüntüleri

Uygulama şu ekranları içerir:

1. **Pet Listesi Ekranı**: Tüm petleri listeler ve duruma göre filtreleme yapılabilir.
2. **Pet Detay Ekranı**: Seçilen pet'in ayrıntılı bilgilerini gösterir.
3. **Pet Ekleme Ekranı**: Yeni bir pet eklemek için form sunar.

## Mimari İyileştirmeler

Bu projede şu mimari iyileştirmeler yapılmıştır:

- **Tek Sorumluluk İlkesi**: Her bir sınıf ve metod sadece tek bir işi yapmaktadır.
- **Bağımlılık Enjeksiyonu**: APIClient nesnesi, ekranlara ve servislere enjekte edilir.
- **Kod Tekrarını Önleme**: Ortak widget'lar ayrı dosyalarda tanımlanmıştır.
- **Katmanlı Mimari**: UI, Servis ve API katmanları ayrılmıştır.
- **Hata Yönetimi**: Tüm hata durumları ele alınmıştır.

## Gelecek İyileştirmeler

- GetIt veya Provider ile dependency injection
- Unit ve widget testleri
- Tema yönetimi
- Çoklu dil desteği
- Offline modu ve yerel cache

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## İletişim

GitHub: [smyy325](https://github.com/smyy325)
