# Flutter OpenAPI Generator Örneği

Bu proje, Flutter'da OpenAPI Generator kullanarak REST API entegrasyonu yapmak için örnek bir uygulamadır. Swagger PetStore API'sini kullanarak, OpenAPI tanımlamasından Dart kodlarının nasıl oluşturulacağını ve kullanılacağını göstermektedir.

## Özellikler

- OpenAPI tanımlamasından Dart modelleri ve API istemcileri oluşturma
- Dio HTTP istemcisi ile API isteklerini yönetme
- Oluşturulan modellerle veri işleme
- Material Design UI ile veri görüntüleme

## Kurulum

1. Bu repo'yu klonlayın:
```bash
git clone https://github.com/yourusername/flutter-openapi-example.git
cd flutter-openapi-example
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. OpenAPI Generator CLI'ı yükleyin:
```bash
npm install @openapitools/openapi-generator-cli -g
```

4. API istemcilerini ve modellerini oluşturun:
```bash
openapi-generator-cli generate -g dart -i api/openapi.yaml -o lib/api/generated --additional-properties=pubName=petstore_api,pubAuthor="OpenAPI Generator Team",pubVersion=1.0.0
```

5. Uygulamayı çalıştırın:
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
  dio: ^5.8.0+1
  json_annotation: ^4.9.0
  built_value: ^8.8.1
  built_collection: ^5.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.10
  json_serializable: ^6.9.4
  openapi_generator: ^4.13.1
  built_value_generator: ^8.8.1
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
          "pubHomepage": "https://github.com/yourusername/flutter-openapi-example",
          "browserClient": false,
          "pubLibrary": "petstore_api"
        }
      }
    }
  }
}
```

### 3. API İstemci Wrapper Sınıfını Oluşturun

API çağrılarını yönetecek bir wrapper sınıfı oluşturun. Bu sınıf, OpenAPI tarafından oluşturulan API sınıflarını kullanır.

### 4. OpenAPI Modellerini Kullanın

API'dan alınan verileri temsil etmek için OpenAPI tarafından oluşturulan modelleri kullanın.

### 5. UI Ekranlarını Oluşturun

API verilerini görüntülemek için UI ekranlarını oluşturun.

## Proje Yapısı

```
lib/
  ├── api/               # API ile ilgili dosyalar
  │   ├── api_client.dart    # API istemci wrapper sınıfı
  │   └── generated/         # OpenAPI tarafından oluşturulan dosyalar
  ├── models/            # Model sınıfları
  │   └── pet.dart           # Pet modeli
  ├── screens/           # UI ekranları
  │   └── home_screen.dart   # Ana ekran
  └── main.dart          # Uygulama giriş noktası
api/
  └── openapi.yaml       # OpenAPI tanımlaması
```

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır - ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.

## Katkıda Bulunma

Katkıda bulunmak için lütfen bir pull request gönderin veya bir issue açın.
