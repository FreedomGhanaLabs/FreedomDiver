import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class BackgroundVerificationScreen extends StatelessWidget {
  const BackgroundVerificationScreen({super.key});
  static const routeName = '/background-verification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  DecoratedBackButton(),
                  SizedBox(width: 13.91),
                  Text(
                    'Background Verification',
                    style:
                        TextStyle(fontSize: 18.05, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const VSpace(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We prioritize safety. Please upload your necessary documents for verification.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const VSpace(27),
                  Text(
                    'Upload ID',
                    style: GoogleFonts.poppins(
                      fontSize: 15.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Upload a photo of a valid ID (Driver’s License, Passport, or Ghana Card) to verify your identity.',
                    style: GoogleFonts.poppins(
                        fontSize: 9.27, fontWeight: FontWeight.w400),
                  ),
                  const VSpace(10),
                  buildUploadDocsUI(),
                ],
              ),
            ),
            const VSpace(21),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SimpleButton(
                title: 'Upload Selfie',
                backgroundColor: darkGoldColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
                onPressed: () {},
              ),
            ),
            const VSpace(46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SimpleButton(
                title: 'Submit Document',
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CriminalBackgroundCheckScreen.routeName,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildUploadDocsUI() {
    return DottedBorder(
      radius: const Radius.circular(7),
      borderType: BorderType.RRect,
      strokeWidth: 2,
      dashPattern: const [8, 4],
      color: yellowGold,
      child: Container(
        width: 361,
        height: 102,
        decoration: ShapeDecoration(
          color: const Color(0x0AFFBA40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 17,
              ),
              padding: const EdgeInsets.all(8.1),
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
                  Container(
                    width: 11.22,
                    height: 11.22,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: SvgPicture.asset(
                      'assets/app_icons/upload_item_icon.svg',
                    ),
                  ),
                  const SizedBox(width: 8.01),
                  Text(
                    'Upload ID photo',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF59E0B),
                      fontSize: 11.61,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const VSpace(8.8),
            Text(
              'Upload a photo of your face to verify your identity.',
              style: GoogleFonts.poppins(
                fontSize: 9.27,
                fontWeight: FontWeight.w400,
                color: yellowGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton(
      {required this.title,
      super.key,
      this.borderRadius = BorderRadius.zero,
      this.backgroundColor,
      this.onPressed,
      this.padding,
      this.textStyle});
  final String title;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        padding: padding ??
            const EdgeInsets.only(
              top: 18,
              bottom: 17,
            ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle ??
            GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17.92,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
