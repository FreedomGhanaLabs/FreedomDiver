import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedomdriver/feature/documents/extension.dart';
import 'package:freedomdriver/feature/documents/models/driver_documents.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/api/api_handler.dart';
import 'package:freedomdriver/shared/screens/verification_status_screen.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../driver/cubit/driver_cubit.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit() : super(DocumentInitial());

  final apiController = ApiController('document');

  DriverDocument? _cachedDriverDocument;
  bool get hasDocument => _cachedDriverDocument != null;

  void _updateDocument(DriverDocument updated) {
    _cachedDriverDocument = updated;
    emit(DocumentLoaded(_cachedDriverDocument!));
  }

  void resetDocument() {
    _cachedDriverDocument = null;
    emit(DocumentInitial());
  }

  Future<void> getDriverDocument(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    if (hasDocument && !forceRefresh) {
      log('[DocumentCubit] Using cached document data');
      _updateDocument(_cachedDriverDocument!);
      return;
    }
    emit(DocumentLoading());

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.getData(context, 'documents', (success, data) {
          if (success && data is Map<String, dynamic>) {
            final document = DriverDocument.fromJson(data['data']);
            _updateDocument(document);
          } else {
            emit(const DocumentError('Failed to fetch driver documents'));
          }
        });
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

  //  ------ Upload Motorcycle Image ------
  Future<void> uploadProfileImage(BuildContext context) async {
    final driver = context.driver;
    final documentFile = context.document;

    if (documentFile == null) {
      showToast(
        context,
        'Error',
        'Please select an image',
        toastType: ToastType.info,
      );
      emit(const DocumentError('Please select an image'));
      return;
    }

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    final formData = FormData.fromMap({
      'documentType': DriverDocumentType.profilePicture.name,
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'profileImage-${driver?.fullName}-${driver?.id}$fileExt',
        contentType: mediaType,
      ),
    });

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentSuccess());
            context.read<DriverCubit>().updateDriverProfileImage(
              data['data']['documentUrl'],
            );
            context.read<DriverImageCubit>().resetImage();
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

  //  ------ Upload Motorcycle Image ------
  Future<void> uploadMotorCycleImage(BuildContext context) async {
    final driver = context.driver;
    final documentFile = context.document;

    if (documentFile == null) {
      showToast(
        context,
        'Error',
        'Please select a document',
        toastType: ToastType.info,
      );
      emit(const DocumentError('Please select a document'));
      return;
    }

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    final formData = FormData.fromMap({
      'documentType': DriverDocumentType.motorcycleImage.name,
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'motorcycleImage-${driver?.fullName}-${driver?.id}$fileExt',
        contentType: mediaType,
      ),
    });

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentSuccess());
            context.read<DriverImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

  //  ------ Upload Ghana Card ------
  Future<void> uploadGhanaCard(BuildContext context) async {
    final driver = context.driver;
    final documentFile = context.document;
    final ghanaCard = context.ghanaCard;

    if (documentFile == null) {
      showToast(
        context,
        'Error',
        'Please select a document',
        toastType: ToastType.info,
      );
      emit(const DocumentError('Please select a document'));
      return;
    }

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    final formData = FormData.fromMap({
      'documentType': DriverDocumentType.ghanaCard.name,
      'personalIdNumber': ghanaCard?.personalIdNumber,
      'surname': ghanaCard?.surname,
      'firstName': ghanaCard?.firstName,
      'otherName': ghanaCard?.otherName,
      'sex': ghanaCard?.sex,
      'dateOfBirth': ghanaCard?.dateOfBirth,
      'height': ghanaCard?.height,
      'expiryDate': ghanaCard?.expiryDate,
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'ghanaCard-${driver?.fullName}-${driver?.id}$fileExt',
        contentType: mediaType,
      ),
    });

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentSuccess());
            context.read<DriverImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

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
      emit(const DocumentError('Please select a document'));
      return;
    }

    final fileExt = p.extension(documentFile.path);
    final mimeType = lookupMimeType(documentFile.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    final formData = FormData.fromMap({
      'documentType': DriverDocumentType.driverLicense.name,
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

    // emit(DocumentLoading());
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'upload', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentSuccess());
            context.read<DriverImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
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
      emit(const DocumentError('Please select a document'));
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
      'documentType': DriverDocumentType.addressProof.name,
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: 'addressProof-${driver.fullName}-${driver.id}$fileExt',
        contentType: mediaType,
      ),
    });

    emit(DocumentLoading());

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.uploadFile(context, 'address', formData, (
          success,
          data,
        ) {
          if (success) {
            emit(DocumentSuccess());
            context.read<DriverImageCubit>().resetImage();
            Navigator.pushReplacementNamed(
              context,
              VerificationStatusScreen.routeName,
            );
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }
}
