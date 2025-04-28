import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/extension.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/api/api_handler.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';



class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  DocumentUploadCubit() : super(DocumentUploadInitial());

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
      emit(const DocumentUploadError('Please select a document'));
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
    emit(DocumentUploadLoading());
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData,
            (success, data) {
          if (success) {
            emit(DocumentUploadSuccess());
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainActivityScreen.routeName,
              (route) => false,
            );
          } else {
            emit(const DocumentUploadError('Failed to upload driver documents'));
          }
        });
      },
      onError: (_) => emit(const DocumentUploadError('Something went wrong')),
    );
  }
}
