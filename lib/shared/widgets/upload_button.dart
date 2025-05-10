import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/documents/cubit/document_image.dart';
import 'package:freedom_driver/feature/documents/cubit/document_image_state.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/routes_params.dart';
import 'package:freedom_driver/utilities/ui.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    final isAddress = type == 'address';
    return BlocBuilder<DriverLicenseImageCubit, DriverLicenseImageState>(
      
      builder: (context, state) {
        return Column(
          children: [
            DottedBorder(
              radius: const Radius.circular(roundedMd),
              borderType: BorderType.RRect,
              dashPattern: const [14, 4],
              color: yellowGold,
              child: GestureDetector(
                onTap: () {
                  final driverLicenseImage =
                      context.read<DriverLicenseImageCubit>();
                  showCupertinoModalPopup(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          child: Text(
                            'Snap Document',
                            style: TextStyle(color: gradient1),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            driverLicenseImage.pickImage(context);
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            'Choose from Gallery',
                            style: TextStyle(color: gradient1),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            driverLicenseImage.pickImage(
                              context,
                              gallery: true,
                            );
                          },
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          child: const Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: Responsive.isBigMobile(context)
                      ? Responsive.width(context)
                      : 361,
                  height: 110,
                  decoration: ShapeDecoration(
                    color: const Color(0x0AFFBA40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: smallWhiteSpace),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppIcon(
                              iconName: 'upload_item_icon',
                              size: paragraphText,
                            ),
                            const SizedBox(width: 8.01),
                            Text(
                              'Upload ${isAddress ? 'Utility Bill' : 'ID'}',
                              style: const TextStyle(
                                color: Color(0xFFF59E0B),
                                fontSize: smallText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VSpace(8.8),
                      Text(
                        // 'Upload a photo of your face to verify your identity.',
                        'Make sure your document is clear and legible.',
                        style: TextStyle(
                          fontSize: smallText,
                          fontWeight: FontWeight.w400,
                          color: yellowGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is DriverLicenseImageLoading) showProgressIndicator(),
            if (state is DriverLicenseImageSelected) ...[
              const VSpace(smallWhiteSpace),
              buildSelectedImage(context, state.image),
            ],
          ],
        );
      },
    );
  }
}

Widget buildSelectedImage(BuildContext context, File image) {
  return Container(
    height: 200,
    width: Responsive.isBigMobile(context) ? 375.sp : Responsive.width(context),
    decoration: ShapeDecoration(
      color: const Color(0x0AFFBA40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    ),
    child: Image.file(image),
  );
}
