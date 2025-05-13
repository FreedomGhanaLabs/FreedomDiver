import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:freedom_driver/core/API/clients/base_api_clients.dart';
import 'package:freedom_driver/core/API/endpoints/end_points.dart';
import 'package:freedom_driver/core/di/locator.dart';
import 'package:freedom_driver/feature/authentication/register/auth_exceptions/auth_exceptions.dart';
import 'package:freedom_driver/feature/authentication/register/models/register_model.dart';

class RegisterRemoteDataSource {
  final client = getIt.get<BaseApiClients>();

  Future<RegisterResponse> registerDriver(RegisterModel registerData) async {
    log('RegisterRemoteDataSource: ${registerData.toJson()}');
    try {
      final response =
          await client.post(Endpoints.register, body: registerData.toJson());
      log('RegisterRemoteDataSource: $response');
      log('RegisterRemoteDataSource: ${response.statusCode}');
      log('RegisterRemoteDataSource: ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return RegisterResponse.fromJson(responseBody as Map<String, dynamic>);
      } else {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = json.decode(response.body) as Map<String, dynamic>;
        } catch (_) {
          // No valid JSON in response
        }

        final message = errorBody?['message'] ?? 'Failed to register';
        throw ServerAuthException(response.statusCode, message as String);
      }
    } on SocketException {
      throw NetworkAuthException('No internet connection');
    } on TimeoutException {
      throw NetworkAuthException('Request timed out');
    } on FormatException {
      throw AuthException('Invalid response format');
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }
}
