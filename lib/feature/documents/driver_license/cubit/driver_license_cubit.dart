import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/api/api_handler.dart';

class DriverLicenseCubit extends Cubit<DriverLicenseState> {
  DriverLicenseCubit() : super(DriverLicenseInitial());

  final ApiController apiController = ApiController('documents');

  void setDriverLicenseDetails({
    required String licenseNumber,
    required String dob,
    required String licenseClass,
    required String issueDate,
    required String expiryDate,
  }) {
    log('[License Cubit] Adding Driver license information');
    final document = DriverLicense(
      licenseNumber: licenseNumber,
      dob: dob,
      licenseClass: licenseClass,
      issueDate: issueDate,
      expiryDate: expiryDate,
      documentUrl: '',
      verificationStatus: '',
      adminComments: '',
      uploadedAt: DateTime.now(),
    );

    emit(DriverLicenseLoaded(document));
  }

  Future<void> uploadDriverLicense(
    BuildContext context,
    File documentFile,
  ) async {
    emit(DriverLicenseLoading());

    final driver = context.driver;

    final formData = FormData.fromMap({
      'documentType': 'driverLicense',
      'licenseNumber': 'DL12345678',
      'firstName': driver?.firstName,
      'surname': driver?.surname,
      'otherName': driver?.otherName,
      'dateOfBirth': '1990-01-01',
      'classOfLicense': 'A',
      'nationality': driver?.address.country,
      'issueDate': '2020-01-01',
      'expiryDate': '2025-01-01',
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'driverLicense.jpg',
      ),
    });

    debugPrint('FormData: ${formData.fields}');

    emit(DriverLicenseLoading());

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData,
            (success, data) {
          if (success && data is Map<String, dynamic>) {
            log('DriverLicense data: $data', name: 'DriverLicenseCubit');
          } else {
            emit(const DriverLicenseError('Failed to upload driver documents'));
          }
        });
      },
      onError: (_) => emit(const DriverLicenseError('Something went wrong')),
    );
  }
}
