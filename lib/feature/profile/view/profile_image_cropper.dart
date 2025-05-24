import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../documents/cubit/driver_document_state.dart';

class ProfileImageCropper extends StatefulWidget {
  const ProfileImageCropper({super.key});
  static const routeName = 'profile-image-cropper';

  @override
  State<ProfileImageCropper> createState() => _ProfileImageCropperState();
}

class _ProfileImageCropperState extends State<ProfileImageCropper> {
  Future<void> _cropImage(String sourcePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Profile Image'),
      ],
    );

    if (croppedFile != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        return PopScope(
           canPop: false,
          child: CustomScreen(
            children: [
              ElevatedButton.icon(
                onPressed:() => _cropImage(''),
                icon: const Icon(Icons.image),
                label: const Text('Upload Profile Image'),
              ),
            ],
          ),
        );
      },
    );
  }
}
