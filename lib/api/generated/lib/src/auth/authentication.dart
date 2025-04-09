import 'dart:convert';
import 'package:dio/dio.dart';

abstract class Authentication {
  void applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  );
}

class QueryParam {
  final String name;
  final String? value;

  QueryParam(this.name, this.value);
}

class ApiKeyAuth implements Authentication {
  final String location;
  final String paramName;
  String? apiKey;
  String? apiKeyPrefix;

  ApiKeyAuth(this.location, this.paramName);

  @override
  void applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) {
    final value = apiKeyPrefix == null ? apiKey : '$apiKeyPrefix $apiKey';

    if (value != null) {
      if (location == 'query') {
        queryParams.add(QueryParam(paramName, value));
      } else if (location == 'header') {
        headerParams[paramName] = value;
      }
    }
  }
}

class HttpBasicAuth implements Authentication {
  String? username;
  String? password;

  @override
  void applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) {
    if (username != null && password != null) {
      final credentials = '$username:$password';
      final encoded = base64.encode(utf8.encode(credentials));
      headerParams['Authorization'] = 'Basic $encoded';
    }
  }
}

class OAuth implements Authentication {
  String? accessToken;

  @override
  void applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) {
    if (accessToken != null) {
      headerParams['Authorization'] = 'Bearer $accessToken';
    }
  }
}
