import 'package:flutter/material.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/upload_button.dart';
import 'package:freedomdriver/utilities/routes_params.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../utilities/responsive.dart';

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

  String _getDocumentTitle(String? type) {
    if (type == address) return 'Utility Bill';
    if (type == ghanaCard) return 'Ghana Card';
    if (type == motorCycle) return 'Motorcycle Image';
    return 'ID';
  }

  String _getDocumentDescription(String? type) {
    if (type == motorCycle) {
      return 'Upload a photo of your vehicle.';
    }
    return "Upload a photo of valid ID (Driver's License, Passport, or Ghana Card) to verify your identity.";
  }

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    return CustomScreen(
      title: 'Upload Document',
      children: [
        const Text(
          'We prioritize safety. Please upload your necessary documents for verification.',
          style: TextStyle(fontSize: smallText, fontWeight: FontWeight.w400),
        ),
        const VSpace(whiteSpace),
        Text(
          'Upload ${_getDocumentTitle(type)}',
          style: const TextStyle(
            fontSize: normalText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _getDocumentDescription(type),
          style: TextStyle(
            fontSize: extraSmallText,
            fontWeight: FontWeight.w400,
          ),
        ),
        const VSpace(smallWhiteSpace),
        const UploadButton(),
        const VSpace(normalWhiteSpace),
      ],
    );
  }
}

Widget showProgressIndicator({double size = 25}) {
  return SizedBox(
    height: size,
    width: size,
    child: Center(
      child: CircularProgressIndicator(strokeWidth: 3, color: darkGoldColor),
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
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: whiteSpace,
              vertical: extraSmallWhiteSpace + 2,
            ),
      ),
      child:
          child ??
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize:
                      Responsive.isTablet(context)
                          ? normalText
                          : paragraphText,
                  fontWeight: FontWeight.w500,
                ),
          ),
    );
  }
}
