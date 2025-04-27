import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class FileService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      return null;
    }

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      return File(pickedFile.files.first.path!);
    }
    return null;
  }

  Future<File?> captureFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      return null;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> pickDocument() async {
    // Show a bottom sheet or dialog for user to choose
    // This is handled separately in UI
    return null;
  }
}
