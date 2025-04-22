import 'dart:convert';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/utilities/hive/token.dart';

class ApiController {
  ApiController(this.startUrl) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getTokenFromHive();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // log('Dio Error', error: e.message);
          return handler.next(e);
        },
      ),
    );
  }

  final String startUrl;
  String get baseUrl => 'https://api-freedom.com/api/v2/driver/$startUrl/';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> post(
    BuildContext context,
    String endpoint,
    Map<String, dynamic> data,
    Function(bool success, dynamic result) callback, {
    bool shouldShowToast = true,
  }) async {
    // debugPrint(jsonEncode(data));
    // debugPrint('$baseUrl$endpoint');
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(data));
      debugPrint('${response.requestOptions}');
      final successMessage = response.data['message'].toString();
      if (shouldShowToast && successMessage.isNotEmpty) {
        showToast(
          context,
          'Success',
          successMessage,
          toastType: ToastType.success,
        );
      }
      callback(true, response.data);
    } catch (e) {
      final msg = _handleError(e).toString();
      if (shouldShowToast && msg.isNotEmpty) {
        showToast(
          context,
          'Error',
          msg,
          toastType: ToastType.error,
        );
      }
      callback(false, msg);
    }
  }

  Future<void> getData(
    BuildContext context,
    String endpoint,
    Function(bool success, dynamic result) callback, {
    bool shouldShowToast = false,
  }) async {
    try {
      final response = await _dio.get(endpoint);
      final successMessage = response.data['message'].toString();
      if (shouldShowToast && successMessage.isNotEmpty) {
        showToast(
          context,
          'Success',
          successMessage,
          toastType: ToastType.success,
        );
      } else {
        log('/$startUrl/$endpoint - ${successMessage != "null" ? successMessage : 'Fetched data successfully'}');
      }
      callback(true, response.data);
    } catch (e) {
      final msg = _handleError(e).toString();
      if (shouldShowToast && msg.isNotEmpty) {
        showToast(context, 'Error', msg, toastType: ToastType.error);
      }
      callback(false, msg);
    }
  }

  Future<void> put(
    BuildContext context,
    String endpoint,
    Map<String, dynamic> data,
    Function(bool success, dynamic result) callback, {
    bool shouldShowToast = true,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      final successMessage = response.data['message'].toString();
      if (shouldShowToast && successMessage.isNotEmpty) {
        showToast(
          context,
          'Success',
          successMessage,
          toastType: ToastType.success,
        );
      }
      callback(true, response.data);
    } catch (e) {
      final msg = _handleError(e).toString();
      if (shouldShowToast && msg.isNotEmpty) {
        showToast(context, 'Error', msg, toastType: ToastType.error);
      }
      callback(false, msg);
    }
  }

  Future<void> destroy(
    BuildContext context,
    String endpoint,
    Map<String, dynamic> data,
    Function(bool success, dynamic result) callback, {
    bool shouldShowToast = true,
  }) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      final successMessage = response.data['message'].toString();
      if (shouldShowToast && successMessage.isNotEmpty) {
        showToast(
          context,
          'Success',
          successMessage,
          toastType: ToastType.success,
        );
      }
      callback(true, response.data);
    } catch (e) {
      final msg = _handleError(e).toString();
      if (shouldShowToast && msg.isNotEmpty) {
        showToast(context, 'Error', msg, toastType: ToastType.error);
      }
      callback(false, msg);
    }
  }

  // Multipart upload handler
  Future<void> uploadFile(
    BuildContext context,
    String endpoint,
    FormData formData,
    Function(bool success, dynamic result) callback, {
    bool shouldShowToast = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final successMessage = response.data['message'].toString();
      if (shouldShowToast && successMessage.isNotEmpty) {
        showToast(
          context,
          'Success',
          successMessage,
          toastType: ToastType.success,
        );
      }

      callback(true, response.data);
    } catch (e) {
      final msg = _handleError(e).toString();
      if (shouldShowToast && msg.isNotEmpty) {
        showToast(context, 'Error', msg, toastType: ToastType.error);
      }
      callback(false, msg);
    }
  }

  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      debugPrint('error message: ${error.message}');
      final errorData = error.response?.data;
      if (errorData != null) {
        debugPrint('Error Data: $errorData');
        return errorData['message'] ?? errorData['msg'];
      }
      return 'Network Error';
    }
    return 'An unexpected error occurred';
  }
}

void showToast(
  BuildContext context,
  String title,
  String message, {
  ContentType? contentType,
  ToastType? toastType,
  bool isSnackBar = false,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType ?? ContentType.warning,
      inMaterialBanner: true,
    ),
  );

  if (isSnackBar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  } else {
    CustomToast.show(
      context: context,
      message: message,
      duration: const Duration(seconds: 5),
      position: ToastPosition.top,
      type: toastType ?? ToastType.info,
    );
  }
}
