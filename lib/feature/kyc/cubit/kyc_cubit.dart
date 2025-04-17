import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

part 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  KycCubit() : super(KycInitial());

  final String cloudName = 'freedom_driver';
  final String uploadPreset = 'freedom_drivers_pre';
  Future<void> pickImage({ImageSource source = ImageSource.camera}) async {
    try {
      emit(KycImageLoading());
      final imagePicker = ImagePicker();

      final pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        emit(KycImageSelected(file));
      } else {
        // User canceled image selection
        emit(KycInitial());
      }
    } catch (e) {
      emit(KycImagePickFailure('Error picking image: $e'));
    }
  }

  Future<void> uploadImageToCloudinary(File file) async {
    if (file.path.isEmpty) {
      emit(KycImagePickFailure('No image selected'));
      return;
    }

    try {
      emit(KycImageUploadLoading(file));
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/dzrtihz9v/image/upload');
      final imageFormat = _getImageFormat(file.path);
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'freedom_drivers'
        ..fields['timestamp'] =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString()
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', imageFormat),
        ));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseString);

        final secureUrl = jsonData['secure_url'] as String;

        emit(KycImageUploadSuccess(secureUrl, file));
      } else {
        emit(KycImageUploadFailure(
            'Upload failed: ${response.statusCode} - $responseString', file));
      }
    } catch (e) {
      emit(KycImageUploadFailure('Error uploading image: $e', file));
    }
  }

  String _getImageFormat(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg'; // Default to jpeg if unknown
    }
  }
}
