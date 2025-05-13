import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
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
    final status = args['status'] ?? 'pending';

    final isApproved = status == 'approved';
    final isRejected = status == 'rejected';
    final isPending = status == 'pending';

    return CustomScreen(
      hasBackButton: false,
      showDivider: false,
      title:
          'Verification ${isApproved ? 'Approved' : isRejected ? 'Rejected' : 'Pending'}',
      children: [
        const VSpace(extraSmallWhiteSpace),
        if (isApproved)
          const AppIcon(
            size: 200,
            iconName: 'approved_document',
          )
        else
          Lottie.asset('assets/lottie/pending.json'),
        const VSpace(extraSmallWhiteSpace),
        if (isRejected || isApproved)
          Text(
            isApproved ? 'Welcome Aboard!' : 'Verification Rejected',
            textAlign: TextAlign.center,
            style: normalTextStyle,
          ),
        const VSpace(smallWhiteSpace),
        Text(
          isApproved
              ? 'Your account has been approved'
              : isRejected
                  ? 'Oops! Something needs attention'
                  : "Hang tight, we're reviewing your documents",
          textAlign: TextAlign.center,
          style: normalTextStyle,
        ),
        const VSpace(extraSmallWhiteSpace),
        Text(
          isApproved
              ? 'Congratulations! You are now a verified driver-partner. Start accepting ride requests and earn on your terms.'
              : isRejected
                  ? 'Unfortunately, your document verification was not successful. Please review the feedback provided and resubmit your documents.'
                  : "Our team is reviewing the documents you submitted. This process may take a few business days. We'll notify you once your account is approved.",
          textAlign: TextAlign.center,
          style: descriptionTextStyle,
        ),
        const VSpace(normalWhiteSpace),
        FreedomButton(
          onPressed: () {
            if (isPending || isApproved) {
              Navigator.of(context)
                  .pushReplacementNamed(MainActivityScreen.routeName);
              return;
            }
          },
          useGradient: true,
          gradient: LinearGradient(colors: gradientColor),
          title: isPending || isApproved
              ? 'Continue Driving'
              : 'Resubmit Documents',
        ),
        if (isRejected) ...[
          const VSpace(smallWhiteSpace),
          FreedomButton(
            onPressed: () {},
            useGradient: true,
            useOnlBorderGradient: true,
            gradient: LinearGradient(colors: gradientColor),
            title: 'Review Feedback',
            titleColor: gradient1,
          ),
        ],
      ],
    );
  }
}
