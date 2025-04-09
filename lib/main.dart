import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api/api_client.dart';
import 'screens/pet_list_screen.dart';

void main() {
  final apiClient = _setupApiClient();

  runApp(MyApp(apiClient: apiClient));
}

APIClient _setupApiClient() {
  final dio = Dio();
  return APIClient(dio: dio);
}

/// PetStore API'yi kullanarak basit bir OpenAPI Flutter uygulaması.
class MyApp extends StatelessWidget {
  final APIClient apiClient;

  const MyApp({Key? key, required this.apiClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenAPI Generator Demo',
      theme: _buildAppTheme(),
      home: PetListScreen(apiClient: apiClient),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }
}
