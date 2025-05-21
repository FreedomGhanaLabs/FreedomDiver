import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image_state.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/utilities/file_service.dart';

class DriverLicenseImageCubit extends Cubit<DriverImageState> {
  DriverLicenseImageCubit() : super(DriverImageInitial());

  Future<void> pickImage(BuildContext context, {bool gallery = false}) async {
    try {
      emit(DriverImageLoading());
      final fileService = FileService();

      final pickedFile =
          gallery
              ? await fileService.pickFromGallery()
              : await fileService.captureFromCamera();

      if (pickedFile != null) {
        emit(DriverImageSelected(pickedFile));
      } else {
        emit(DriverImageInitial());
      }
    } catch (e) {
      log('Error picking image: $e');
      showToast(
        context,
        'Error',
        'An error occurred while choosing document',
        toastType: ToastType.error,
      );
      emit(DriverImageInitial());
      emit(const DriverImageError('Failed to pick image'));
    }
  }

  void resetImage() {
    emit(DriverImageInitial());
  }
}
