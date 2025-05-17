import 'dart:async';
import 'dart:convert';
import 'package:freedomdriver/core/API/clients/exceptions.dart';
import 'package:http/http.dart' as http;

class BaseApiClients {
  BaseApiClients({required this.baseUrl, Map<String, String>? headers})
      : _headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        };
  final String baseUrl;
  final Map<String, String> _headers;

  Future<http.Response> get(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final response = await http
          .get(
            uri,
            headers: headers ?? _headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on NetworkException {
      throw NetworkException('No internet connection');
    }
  }

  Future<http.Response> post(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final encodedBody = json.encode(body);

      final response = await http
          .post(
            uri,
            headers: headers ?? _headers,
            body: encodedBody,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on NetworkException {
      throw NetworkException('No internet connection');
    }
  }

  Future<http.Response> put(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final encodedBody = json.encode(body);

      final response = await http
          .put(
            uri,
            headers: headers ?? _headers,
            body: encodedBody,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on NetworkException {
      throw NetworkException('No internet connection');
    }
  }

  Future<http.Response> patch(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final encodedBody = json.encode(body);
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final response = await http
          .patch(
            uri,
            headers: headers ?? _headers,
            body: encodedBody,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on NetworkException {
      throw NetworkException('No internet connection');
    }
  }

  Future<http.Response> delete(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final response = await http
          .delete(
            uri,
            headers: headers ?? _headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on NetworkException {
      throw NetworkException('No internet connection');
    }
  }

  Uri _buildUri(String endPoint, {Map<String, dynamic>? queryParameters}) {
    final parsedValue = Uri.parse('$baseUrl$endPoint').replace(
      queryParameters: queryParameters,
    );
    return parsedValue;
  }

  http.Response _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorizedException(response.body);
      case 403:
        throw ForbiddenException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
        throw InternalServerErrorException(response.body);
      default:
        throw NetworkException(
          'Error occurred with status code: ${response.statusCode}',
        );
    }
  }
}
