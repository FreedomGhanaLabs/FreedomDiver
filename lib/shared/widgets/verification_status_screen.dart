import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/custom_screen.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/routes_params.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:lottie/lottie.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});
  static const routeName = '/verification-status';

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final status = args['status'].toString();

    final isVerified = status == 'verified';
    final isRejected = status == 'rejected';
    return CustomScreen(
      hasBackButton: false,
      showDivider: false,
      title: 'Verification Rejected',
      children: [
        Lottie.asset('assets/lottie/pending.json'),
        const Text(
          "Hang tight, we're reviewing your documents",
          textAlign: TextAlign.center,
        ),
        const VSpace(extraSmallWhiteSpace),
        const Text(
          "Our team is reviewing the documents you submitted. This process may take a few business days. We'll notify you once your account is approved.",
          textAlign: TextAlign.center,
        ),
        const VSpace(normalWhiteSpace),
        FreedomButton(
          onPressed: () {},
          useGradient: true,
          gradient: LinearGradient(colors: gradientColor),
          title: 'Continue driving',
        ),
      ],
    );
  }
}
