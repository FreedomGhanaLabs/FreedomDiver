import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedomdriver/feature/documents/driver_license/extension.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/api/api_handler.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/shared/widgets/verification_status_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  DocumentUploadCubit() : super(DocumentUploadInitial());

  final apiController = ApiController('document');

  

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

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

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
        filename: 'driverLicense-${driver?.fullName}-${driver?.id}$fileExt',
        contentType: mediaType,
      ),
    });

    emit(DocumentUploadLoading());
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentUploadSuccess());
            context.read<DriverLicenseImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          } else {
            emit(
              const DocumentUploadError('Failed to upload driver documents'),
            );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentUploadError('Something went wrong')),
    );
  }

  // ------ Upload Address Proof ------
  Future<void> uploadAddressProof(BuildContext context) async {
    final driver = context.driver;
    final documentFile = context.document;

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

    if (driver == null) {
      showToast(
        context,
        'Error',
        'Network Error. Please ensure you have a good internet connection',
        toastType: ToastType.info,
      );
      return;
    }

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    final formData = FormData.fromMap({
      'addressType': 'utility_bill',
      'street': driver.address.street,
      'city': driver.address.city,
      'state': driver.address.state,
      'country': driver.address.country,
      'postalCode': driver.address.postalCode,
      'documentType': 'addressProof',
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'addressProof-${driver.fullName}-${driver.id}$fileExt',
        contentType: mediaType,
      ),
    });

    emit(DocumentUploadLoading());

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'address', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentUploadSuccess());
            context.read<DriverLicenseImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          } else {
            emit(
              const DocumentUploadError('Failed to upload driver documents'),
            );
            // Navigator.pushReplacementNamed(
            //   context,
            //   VerificationStatusScreen.routeName,
            // );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentUploadError('Something went wrong')),
    );
  }
}
