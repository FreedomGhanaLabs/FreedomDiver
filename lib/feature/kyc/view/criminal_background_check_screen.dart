import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/routes_params.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:lottie/lottie.dart';

class CriminalBackgroundCheckScreen extends StatelessWidget {
  const CriminalBackgroundCheckScreen({super.key});
  static const routeName = '/criminal-background-check-screen';

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'].toString();

    final isAddress = type == 'address';
    return BlocBuilder<DocumentCubit, DocumentUploadState>(
      builder: (context, state) {
        const uploading = DocumentUploadState is DocumentLoading;
        return CustomScreen(
          title: 'Document Verification',
          children: [
            Text(
              'We prioritize safety. Please upload your necessary documents for verification.',
              style: TextStyle(
                fontSize: smallText.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const VSpace(whiteSpace),
            SizedBox(
              height: 181.h,
              width: 181.w,
              child: Lottie.asset(
                'assets/lottie/criminal_background_check.json',
                repeat: true,
                reverse: true,
              ),
            ),
            Text(
              "We work with trusted authorities to ensure all riders meet our safety requirements. Background checks can take up to 48 hours. You'll be notified as soon as it's complete.",
              style: TextStyle(
                fontSize: smallText.sp,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            VSpace(normalWhiteSpace.sp),
            SimpleButton(
              title: uploading ? 'Submitting' : 'Submit for Verification',
              onPressed: () async {
                // context.read<RegistrationFormCubit>().registerDrivers();
                final documentUploadCubit = context.read<DocumentCubit>();
                if (isAddress) {
                  await documentUploadCubit.uploadAddressProof(context);
                  return;
                }

                await documentUploadCubit.uploadDriverLicense(context);
              },
              backgroundColor: Colors.black,
            ),
          ],
        );
      },
    );
  }
}
