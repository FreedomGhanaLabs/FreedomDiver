import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/api/api_handler.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/utilities/file_service.dart';

class DriverLicenseCubit extends Cubit<DriverLicenseState> {
  DriverLicenseCubit() : super(DriverLicenseInitial());

  final ApiController apiController = ApiController('documents');

  DriverLicenseImageState imageState = DriverLicenseImageInitial();
  DriverLicenseDetailsState detailsState = DriverLicenseDetailsInitial();

  File? documentFile;
  DriverLicense? driverLicense;

  // ------ Pick Image ------
  Future<void> pickImage(BuildContext context, {bool gallery = false}) async {
    try {
      emit(DriverLicenseLoading());
      final fileService = FileService();

      final pickedFile = gallery
          ? await fileService.pickFromGallery()
          : await fileService.captureFromCamera();

      if (pickedFile != null) {
        documentFile = File(pickedFile.path);
        imageState = DriverLicenseImageSelected(documentFile!);
      } else {
        imageState = DriverLicenseImageInitial();
      }

      emit(DriverLicenseInitial());
    } catch (e) {
      log('Error picking image: $e');
      showToast(
        context,
        'Error',
        'An error occurred while choosing document',
        toastType: ToastType.error,
      );
      imageState = DriverLicenseImageInitial();
      emit(const DriverLicenseError('Failed to pick image'));
    }
  }

  // ------ Set Driver License Details ------
  void setDriverLicenseDetails({
    required String licenseNumber,
    required String dob,
    required String licenseClass,
    required String issueDate,
    required String expiryDate,
  }) {
    driverLicense = DriverLicense(
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

    detailsState = DriverLicenseDetailsLoaded(driverLicense!);
    emit(DriverLicenseInitial());
  }

  // ------ Upload Driver License ------
  Future<void> uploadDriverLicense(BuildContext context) async {
    final driver = context.driver;

    if (documentFile == null) {
      showToast(
        context,
        'Error',
        'Please select a document',
        toastType: ToastType.info,
      );
      emit(const DriverLicenseError('Please select a document'));
      return;
    }

    final formData = FormData.fromMap({
      'documentType': 'driverLicense',
      'licenseNumber': driverLicense?.licenseNumber,
      'firstName': driver?.firstName,
      'surname': driver?.surname,
      'otherName': driver?.otherName,
      'dateOfBirth': driverLicense?.dob,
      'classOfLicense': driverLicense?.licenseClass,
      'nationality': driver?.address.country,
      'issueDate': driverLicense?.issueDate,
      'expiryDate': driverLicense?.expiryDate,
      'document': await MultipartFile.fromFile(
        documentFile!.path,
        filename: 'driverLicense-${driver?.fullName}-${driver?.id}.jpg',
      ),
    });

    await handleApiCall(
      context: context,
      apiRequest: () async {
        emit(DriverLicenseLoading());
        await apiController.uploadFile(context, 'upload', formData,
            (success, data) {
          if (success && data is Map<String, dynamic>) {
            emit(DriverLicenseSuccess());
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainActivityScreen.routeName,
              (route) => false,
            );
          } else {
            emit(const DriverLicenseError('Failed to upload driver documents'));
          }
        });
      },
      onError: (_) => emit(const DriverLicenseError('Something went wrong')),
    );
  }
}
