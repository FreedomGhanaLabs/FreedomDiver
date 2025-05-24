import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image_state.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/pick_file.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/routes_params.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../core/constants/documents.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);

    return BlocBuilder<DriverImageCubit, DriverImageState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomDottedBorder(),
            if (state is DriverImageLoading) ...[
              const VSpace(smallWhiteSpace),
              showProgressIndicator(),
            ],
            if (state is DriverImageSelected) ...[
              const VSpace(whiteSpace),
              buildSelectedImage(context, state.image),
              const VSpace(whiteSpace),
              SimpleButton(
                title: 'Submit Document',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CriminalBackgroundCheckScreen.routeName,
                    arguments: args,
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class CustomDottedBorder extends StatelessWidget {
  const CustomDottedBorder({super.key});

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    final isAddress = type == address;
    final isGhanaCard = type == ghanaCard;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 2,
        padding: EdgeInsets.all(smallWhiteSpace),
        radius: const Radius.circular(roundedMd),
        color: yellowGold,
      ),
      child: GestureDetector(
        onTap: () => pickFile(context),
        child: Container(
          width:
              Responsive.isBigMobile(context) ? Responsive.width(context) : 361,
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
                  border: Border.all(color: const Color(0xFFF59E0B)),
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
                      'Upload ${isAddress
                          ? 'Utility Bill'
                          : isGhanaCard
                          ? 'Card'
                          : 'ID'}',
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
                'Ensure your document is clear and legible.',
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
    );
  }
}

Widget buildSelectedImage(BuildContext context, File image) {
  return Container(
    height: 200,
    width:
        Responsive.isBigMobile(context)
            ? (mobileWidth - 20).sp
            : Responsive.width(context),
    decoration: ShapeDecoration(
      color: const Color(0x0AFFBA40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(roundedLg),
      ),
    ),
    child: Image.file(image),
  );
}
