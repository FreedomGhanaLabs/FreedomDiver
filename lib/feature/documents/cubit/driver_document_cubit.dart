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

import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';

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

  DriverDocument _copyWithDynamic(DriverDocumentType type, dynamic data) {
    log('[DocumentCubit] Updating document history for $type');

    final history = DocumentHistory(
      documentType: data['documentType'],
      current: HDocument.fromJson(data['current']),
      history:
          (data['history'] as List).map((e) => HDocument.fromJson(e)).toList(),
    );
    switch (type) {
      case DriverDocumentType.driverLicense:
        return _cachedDriverDocument!.copyWith(driverLicenseHistory: history);
      case DriverDocumentType.ghanaCard:
        return _cachedDriverDocument!.copyWith(ghanaCardHistory: history);
      case DriverDocumentType.motorcycleImage:
        return _cachedDriverDocument!.copyWith(motorcycleImageHistory: history);
      case DriverDocumentType.profilePicture:
        return _cachedDriverDocument!.copyWith(profilePictureHistory: history);
      case DriverDocumentType.addressProof:
        return _cachedDriverDocument!.copyWith(addressProofHistory: history);
    }
  }


  Future<void> getDriverDocumentHistory(
    BuildContext context, {
    required String documentType,
    bool forceRefresh = false,
  }) async {

    emit(DocumentLoading());

    final type = DriverDocumentType.values.firstWhere(
      (e) => e.name == documentType,
      orElse: () => DriverDocumentType.motorcycleImage,
    );
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.getData(context, 'history/$documentType', (
          success,
          data,
        ) {
          if (success && data is Map<String, dynamic>) {
            final updated = _copyWithDynamic(type, data['data']);
            _updateDocument(updated);
          } else {
            emit(const DocumentError('Failed to fetch driver documents'));
          }
        });
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

  Future<void> uploadDocument({
    required BuildContext context,
    required DriverDocumentType type,
    required String fileName,
    required Map<String, dynamic> extraData,
    bool goToVerification = false,
  }) async {
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
      'documentType': type.name,
      'document': await MultipartFile.fromFile(
        documentFile.path,
        filename: '$fileName-${driver?.fullName}-${driver?.id}$fileExt',
        contentType: mediaType,
      ),
      ...extraData,
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
            if (type == DriverDocumentType.profilePicture) {
              context.read<DriverCubit>().updateDriverProfileImage(
                data['data']['documentUrl'],
              );
            }
            if (goToVerification) {
              Navigator.pushReplacementNamed(
                context,
                VerificationStatusScreen.routeName,
              );
            }
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DocumentError('Something went wrong')),
    );
  }

  Future<void> uploadProfileImage(BuildContext context) async {
    await uploadDocument(
      context: context,
      type: DriverDocumentType.profilePicture,
      fileName: 'profileImage',
      extraData: {},
    );
  }

  Future<void> uploadMotorCycleImage(BuildContext context) async {
    await uploadDocument(
      context: context,
      type: DriverDocumentType.motorcycleImage,
      fileName: 'motorcycleImage',
      extraData: {},
      goToVerification: true,
    );
  }

  Future<void> uploadGhanaCard(BuildContext context) async {
    final ghanaCard = context.ghanaCard;
    await uploadDocument(
      context: context,
      type: DriverDocumentType.ghanaCard,
      fileName: 'ghanaCard',
      extraData: {
        'personalIdNumber': ghanaCard?.personalIdNumber,
        'surname': ghanaCard?.surname,
        'firstName': ghanaCard?.firstName,
        'otherName': ghanaCard?.otherName,
        'sex': ghanaCard?.sex,
        'dateOfBirth': ghanaCard?.dateOfBirth,
        'height': ghanaCard?.height,
        'expiryDate': ghanaCard?.expiryDate,
      },
      goToVerification: true,
    );
  }

  Future<void> uploadDriverLicense(BuildContext context) async {
    final driver = context.driver;
    final license = context.driverLicense;
    await uploadDocument(
      context: context,
      type: DriverDocumentType.driverLicense,
      fileName: 'driverLicense',
      extraData: {
        'licenseNumber': license?.licenseNumber,
        'firstName': driver?.firstName,
        'surname': driver?.surname,
        'otherName': driver?.otherName,
        'dateOfBirth': license?.dob,
        'classOfLicense': license?.licenseClass,
        'nationality': driver?.address.country,
        'issueDate': license?.issueDate,
        'expiryDate': license?.expiryDate,
      },
      goToVerification: true,
    );
  }

  Future<void> uploadAddressProof(BuildContext context) async {
    final driver = context.driver;
    if (driver == null) {
      showToast(
        context,
        'Error',
        'Network Error. Please ensure you have a good internet connection',
        toastType: ToastType.info,
      );
      return;
    }
    await uploadDocument(
      context: context,
      type: DriverDocumentType.addressProof,
      fileName: 'addressProof',
      extraData: {
        'addressType': 'utility_bill',
        'street': driver.address.street,
        'city': driver.address.city,
        'state': driver.address.state,
        'country': driver.address.country,
        'postalCode': driver.address.postalCode,
      },
      goToVerification: true,
    );
  }
}
