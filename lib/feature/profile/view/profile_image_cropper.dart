import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/upload_button.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../documents/cubit/document_image.dart';
import '../../documents/cubit/document_image_state.dart';
import '../../documents/cubit/driver_document_cubit.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

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
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Crop Profile Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      final imageCubit = context.read<DriverImageCubit>();
      imageCubit.addImage(File(croppedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverImageCubit, DriverImageState>(
      builder: (context, state) {
        final image = state is DriverImageSelected ? state.image : null;
        if (image == null) {
          Navigator.of(context).pop();
          return const CustomScreen();
        }
        if (state is DriverImageLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScreen(
          title: 'Update Profile Image',
          children: [
            const VSpace(normalWhiteSpace),
            ...[
              buildSelectedImage(
                context,
                image,
                height: Responsive.height(context) * 0.5,
                radius: roundedFull,
              ),
              const VSpace(whiteSpace),
              SimpleButton(
                backgroundColor: gradient2,
                onPressed: () => _cropImage(image.path),
                title: '',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.crop, color: Colors.white),
                    HSpace(medWhiteSpace),
                    Text(
                      'Crop Image',
                      style: TextStyle(
                        fontSize: normalText,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(extraSmallWhiteSpace),
              SimpleButton(
                onPressed:
                    () => context.read<DocumentCubit>().uploadProfileImage(
                      context,
                    ),
                title: '',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, color: Colors.white),
                    HSpace(medWhiteSpace),
                    Text(
                      'Update Profile Image',
                      style: TextStyle(
                        fontSize: normalText,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
