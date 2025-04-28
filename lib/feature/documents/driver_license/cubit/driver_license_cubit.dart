import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/extension.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/api/api_handler.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';



class DriverLicenseCubit extends Cubit<DriverLicenseState> {
  DriverLicenseCubit() : super(DriverLicenseInitial());

  final ApiController apiController = ApiController('documents');

  // ------ Upload Driver License ------
  Future<void> uploadDriverLicense(BuildContext context) async {
    final driver = context.driver;
    final documentFile = context.document;
    final driverLicense = context.driverLicense;

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
        documentFile.path,
        filename: 'driverLicense-${driver?.fullName}-${driver?.id}.jpg',
      ),
    });
    emit(DriverLicenseLoading());
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData,
            (success, data) {
          if (success) {
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
