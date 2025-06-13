import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    return pickedFile != null && pickedFile.files.isNotEmpty
        ? File(pickedFile.files.first.path!)
        : null;
  }

  Future<File?> captureFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      return null;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
