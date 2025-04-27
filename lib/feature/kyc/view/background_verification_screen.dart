import 'dart:developer';

import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_cubit.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_state.dart';
import 'package:freedom_driver/feature/kyc/cubit/kyc_cubit.dart';
import 'package:freedom_driver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedom_driver/feature/profile/view/profile_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/utilities/responsive.dart';
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
  late final CloudinaryObject cloudinaryObject;

  @override
  void initState() {
    super.initState();
    cloudinaryObject = CloudinaryObject.fromCloudName(cloudName: 'freedom');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomAppBar(title: 'Upload Document'),
            const VSpace(smallWhiteSpace),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'We prioritize safety. Please upload your necessary documents for verification.',
                    style: TextStyle(
                      fontSize: smallText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const VSpace(whiteSpace),
                  const Text(
                    'Upload ID',
                    style: TextStyle(
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
                  buildUploadDocsUI(),
                ],
              ),
            ),
            const VSpace(whiteSpace),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: BlocBuilder<DriverLicenseCubit, DriverLicenseState>(
                builder: (context, state) {
                  if (state is DriverLicenseImageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DriverLicenseImageSelected) {
                    log('A file has been selected');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.file(state.image, height: 200),
                        const VSpace(whiteSpace),
                        SimpleButton(
                          title: 'Submit Document',
                          // backgroundColor: darkGoldColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
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
            // const VSpace(46),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 21),
            //   child: SimpleButton(
            //     title: 'Submit Document',
            //     borderRadius: const BorderRadius.all(
            //       Radius.circular(7),
            //     ),
            //     onPressed: () {
            //       Navigator.pushNamed(
            //         context,
            //         CriminalBackgroundCheckScreen.routeName,
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget buildSelectedImage(KycImageSelected state) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: ShapeDecoration(
          color: const Color(0x0AFFBA40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Image.file(state.image),
      ),
    );
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(color: darkGoldColor),
    );
  }

  Widget buildUploadDocsUI() {
    return DottedBorder(
      radius: const Radius.circular(7),
      borderType: BorderType.RRect,
      dashPattern: const [14, 4],
      color: yellowGold,
      child: BlocBuilder<KycCubit, KycState>(
        builder: (context, state) {
          if (state is KycImageSelected) {
            return buildSelectedImage(state);
          } else {
            return GestureDetector(
              onTap: () {
                final driverLicense = context.read<DriverLicenseCubit>();
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
                          driverLicense.pickImage(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text(
                          'Choose from Gallery',
                          style: TextStyle(color: gradient1),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          driverLicense.pickImage(
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcon(
                            iconName: 'upload_item_icon',
                            size: paragraphText,
                          ),
                          SizedBox(width: 8.01),
                          Text(
                            'Upload ID photo',
                            style: TextStyle(
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
                      'Make sure your ID is clear and legible.',
                      style: TextStyle(
                        fontSize: smallText,
                        fontWeight: FontWeight.w400,
                        color: yellowGold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    required this.title,
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.backgroundColor,
    this.onPressed,
    this.padding,
    this.textStyle,
    this.child,
    this.materialTapTargetSize,
  });
  final String title;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
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
          borderRadius: borderRadius,
        ),
        padding: padding ??
            const EdgeInsets.only(
              top: 18,
              bottom: 17,
            ),
      ),
      child: child ??
          Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 17.92,
                  fontWeight: FontWeight.w600,
                ),
          ),
    );
  }
}
