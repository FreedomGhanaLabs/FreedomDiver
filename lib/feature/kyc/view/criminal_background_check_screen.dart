import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedom_driver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:lottie/lottie.dart';

class CriminalBackgroundCheckScreen extends StatelessWidget {
  const CriminalBackgroundCheckScreen({super.key});
  static const routeName = '/criminal-background-check-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
          builder: (context, state) {
            const uploading = DocumentUploadState is DocumentUploadLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: whiteSpace),
                  child: Row(
                    children: [
                      const DecoratedBackButton(),
                      const HSpace(smallWhiteSpace),
                      Text(
                        'Criminal Background Check',
                        style: TextStyle(
                          fontSize: 17.3.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const VSpace(8.91),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: whiteSpace),
                  child: Text(
                    'We prioritize safety. Please upload your necessary documents for verification.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const VSpace(22.91),
                SizedBox(
                  height: 181.h,
                  width: 181.w,
                  child: Lottie.asset(
                    'assets/lottie/criminal_background_check.json',
                    repeat: true,
                    reverse: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: whiteSpace),
                  child: Text(
                    "We work with trusted authorities to ensure all riders meet our safety requirements. Background checks can take up to 48 hours. You'll be notified as soon as it's complete.",
                    style: TextStyle(
                      fontSize: 12.38.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const VSpace(34),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SimpleButton(
                    title: uploading
                        ? 'Submitting'
                        : 'Submit for Background Check',
                    onPressed: () {
                      // context.read<RegistrationFormCubit>().registerDrivers();
                      context
                          .read<DocumentUploadCubit>()
                          .uploadDriverLicense(context);
                    },
                    backgroundColor: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
