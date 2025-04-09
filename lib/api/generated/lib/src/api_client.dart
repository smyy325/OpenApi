import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ApiClient {
  final String basePath;
  final Dio dio;

  ApiClient(
      {required this.dio,
      this.basePath = 'https://petstore3.swagger.io/api/v3'});

  Future<Response<dynamic>> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
  ) async {
    final queryString = _buildQuery(queryParams);
    final url =
        '$basePath$path${queryString.isNotEmpty ? '?$queryString' : ''}';

    final options = Options(
      method: method,
      headers: headerParams,
      contentType: contentType,
    );

    try {
      if (method == 'POST' ||
          method == 'PUT' ||
          method == 'PATCH' ||
          method == 'DELETE') {
        final response = await dio.request(
          url,
          data: body ?? formParams,
          options: options,
        );
        return response;
      } else {
        final response = await dio.request(
          url,
          options: options,
        );
        return response;
      }
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        code: e is DioException ? e.response?.statusCode ?? 0 : 0,
      );
    }
  }

  String _buildQuery(List<QueryParam> queryParams) {
    final queryString = StringBuffer();
    if (queryParams.isNotEmpty) {
      for (final param in queryParams) {
        if (param.value != null) {
          if (queryString.isNotEmpty) {
            queryString.write('&');
          }
          queryString.write('${param.name}=${param.value}');
        }
      }
    }
    return queryString.toString();
  }
}

class QueryParam {
  final String name;
  final String? value;

  QueryParam(this.name, this.value);
}

class ApiException implements Exception {
  final String message;
  final int code;

  ApiException({required this.message, this.code = 0});

  @override
  String toString() {
    return 'ApiException: $message (Code: $code)';
  }
}
