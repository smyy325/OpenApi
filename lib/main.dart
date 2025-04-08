import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api/api_client.dart';
import 'screens/pet_list_screen.dart';

void main() {
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
      home: PetListScreen(apiClient: apiClient),
    );
  }
}
