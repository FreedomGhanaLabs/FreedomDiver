import 'dart:developer';

import 'package:freedom_driver/feature/authentication/register/auth_exceptions/auth_exceptions.dart';
import 'package:freedom_driver/feature/authentication/register/models/register_model.dart';
import 'package:freedom_driver/feature/authentication/register/register_remote_data_source.dart';

class RegisterRepository {
  factory RegisterRepository(){
    _registerRepository._remoteDataSource = RegisterRemoteDataSource();
    return _registerRepository;
  }

  RegisterRepository._instance();
  late RegisterRemoteDataSource _remoteDataSource;
  static final RegisterRepository _registerRepository = RegisterRepository._instance();

  Future<RegisterResponse> registerNewDriver(RegisterModel registerData) async {
    try {
      final response = await _remoteDataSource.registerDriver(registerData);
      log('Response: $response');
      return response;
    } on ServerAuthException catch (e) {
      rethrow;
    } on NetworkAuthException catch (e) {
      rethrow;
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AuthException('Registration failed due to an unexpected error');
    }
  }
}