import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api/api_client.dart';
import 'screens/home_screen.dart';

// Basit bir Pet modeli tanımlayalım
class Pet {
  final int? id;
  final String? name;
  final String? status;

  Pet({this.id, this.name, this.status});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(id: json['id'], name: json['name'], status: json['status']);
  }
}

// Basit bir API sınıfı
class PetApi {
  final Dio dio;

  PetApi(this.dio);

  Future<Pet> getPetById(int id) async {
    final response = await dio.get(
      'https://petstore3.swagger.io/api/v3/pet/$id',
    );
    return Pet.fromJson(response.data);
  }
}

void main() {
  // API Client sınıfını oluştur
  final apiClient = APIClient(dio: Dio());

  runApp(MyApp(apiClient: apiClient));
}

/// PetStore API'yi kullanarak basit bir OpenAPI Flutter uygulaması.
class MyApp extends StatelessWidget {
  final APIClient apiClient;

  const MyApp({Key? key, required this.apiClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OpenAPI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Ana ekranımızı ayarla
      home: HomeScreen(apiClient: apiClient),
    );
  }
}
