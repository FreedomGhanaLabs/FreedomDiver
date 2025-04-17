import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/forgot_password/view/forgot_password_form.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/helpers/routes_params.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  static const routeName = '/success';

  @override
  Widget build(BuildContext context) {
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    Map<String, dynamic> getSuccessMap() {
      switch ('/$type') {
        case ForgotPasswordFormScreen.routeName:
          return {
            'header': 'Check Your Inbox',
            'iconName': 'at_sign',
            'description':
                "We've sent a password reset link to your registered email address/phone number. Follow the instructions to securely reset your password and get back on the road.",
          };
        default:
          return {
            'header': 'Success',
            'iconName': 'at_sign',
            'description': 'Operation was successful',
          };
      }
    }

    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.all(whiteSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(iconName: getSuccessMap()['iconName'] as String),
              const VSpace(whiteSpace),
              Text(
                getSuccessMap()['header'] as String,
                style: const TextStyle(
                  fontSize: headingText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const VSpace(smallWhiteSpace),
              Text(
                getSuccessMap()['description'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: paragraphText,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                ),
              ),
              const VSpace(whiteSpace),
              FreedomButton(
                backGroundColor: Colors.black,
                borderRadius: BorderRadius.circular(roundedMd),
                width: double.infinity,
                title:( getSuccessMap()['buttonText'] as String?) ?? 'Back to login',
                onPressed: (getSuccessMap()['buttonText'] as void Function()?) ??
                    () => Navigator.pushReplacementNamed(
                  context,
                  LoginFormScreen.routeName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
