import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/cubit/document_image_state.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/utilities/file_service.dart';

class DriverLicenseImageCubit extends Cubit<DriverLicenseImageState> {
  DriverLicenseImageCubit() : super(DriverLicenseImageInitial());

  Future<void> pickImage(BuildContext context, {bool gallery = false}) async {
    try {
      emit(DriverLicenseImageLoading());
      final fileService = FileService();

      final pickedFile = gallery
          ? await fileService.pickFromGallery()
          : await fileService.captureFromCamera();

      if (pickedFile != null) {
        emit(DriverLicenseImageSelected(pickedFile));
      } else {
        emit(DriverLicenseImageInitial());
      }
    } catch (e) {
      log('Error picking image: $e');
      showToast(
        context,
        'Error',
        'An error occurred while choosing document',
        toastType: ToastType.error,
      );
      emit(DriverLicenseImageInitial());
      emit(const DriverLicenseImageError('Failed to pick image'));
    }
  }
}
