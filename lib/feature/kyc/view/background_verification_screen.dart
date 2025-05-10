import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedom_driver/feature/documents/cubit/document_image.dart';
import 'package:freedom_driver/feature/documents/cubit/document_image_state.dart';
import 'package:freedom_driver/feature/kyc/cubit/kyc_cubit.dart';
import 'package:freedom_driver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_screen.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/shared/widgets/upload_button.dart';
import 'package:freedom_driver/utilities/routes_params.dart';
import 'package:freedom_driver/utilities/ui.dart';

class BackgroundVerificationScreen extends StatefulWidget {
  const BackgroundVerificationScreen({super.key});
  static const routeName = '/background-verification-screen';

  @override
  State<BackgroundVerificationScreen> createState() =>
      _BackgroundVerificationScreenState();
}

class _BackgroundVerificationScreenState
    extends State<BackgroundVerificationScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    final isAddress = type == 'address';
    return CustomScreen(
      title: 'Upload Document',
      children: [
        ...[
          const Text(
            'We prioritize safety. Please upload your necessary documents for verification.',
            style: TextStyle(
              fontSize: smallText,
              fontWeight: FontWeight.w400,
            ),
          ),
          const VSpace(whiteSpace),
          Text(
            'Upload ${isAddress ? 'Utility Bill' : 'ID'}',
            style: const TextStyle(
              fontSize: normalText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            "Upload a photo of a valid ID (Driver's License, Passport, or Ghana Card) to verify your identity.",
            style: TextStyle(
              fontSize: extraSmallText,
              fontWeight: FontWeight.w400,
            ),
          ),
          const VSpace(smallWhiteSpace),
          const UploadButton(),
        ],
        ...[
          const VSpace(whiteSpace),
          BlocBuilder<DriverLicenseImageCubit, DriverLicenseImageState>(
            builder: (context, state) {
              if (state is DriverLicenseImageLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DriverLicenseImageSelected) {
                log('A file has been selected');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.file(state.image),
                    ),
                    const VSpace(whiteSpace),
                    SimpleButton(
                      title: 'Submit Document',
                      // backgroundColor: darkGoldColor,
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CriminalBackgroundCheckScreen.routeName,
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: BlocConsumer<KycCubit, KycState>(
              listener: (context, state) {
                if (state is KycImageUploadSuccess) {
                  context
                      .read<RegistrationFormCubit>()
                      .setUserDetails(securedImageUrl: state.imageUrl);
                  Navigator.pushNamed(
                    context,
                    CriminalBackgroundCheckScreen.routeName,
                  );
                }
                if (state is KycImageUploadFailure) {
                  context.showToast(
                    message: 'Failed to upload image',
                    type: ToastType.error,
                    position: ToastPosition.top,
                  );
                }
              },
              builder: (context, state) {
                if (state is KycImageUploadLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is KycImageSelected) {
                  log('A value has been selected');
                  return SimpleButton(
                    title: 'Upload Selfie',
                    backgroundColor: darkGoldColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                    onPressed: () async {
                      await context
                          .read<KycCubit>()
                          .uploadImageToCloudinary(state.image);
                    },
                  );
                } else {
                  return SimpleButton(
                    title: 'Upload Selfie',
                    backgroundColor: const Color(0x0AFFBA40),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                    onPressed: () {},
                  );
                }
              },
            ),
          ),
          const VSpace(whiteSpace),
        ],
      ],
    );
  }
}

Widget showProgressIndicator() {
  return Center(
    child: CircularProgressIndicator(
      color: darkGoldColor,
    ),
  );
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    required this.title,
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.onPressed,
    this.padding,
    this.textStyle,
    this.child,
    this.materialTapTargetSize,
  });
  final String title;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? child;
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        tapTargetSize: materialTapTargetSize,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(roundedLg),
        ),
        padding: padding ??
            const EdgeInsets.only(
              top: smallWhiteSpace,
              bottom: smallWhiteSpace,
            ),
      ),
      child: child ??
          Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: normalText.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
    );
  }
}
