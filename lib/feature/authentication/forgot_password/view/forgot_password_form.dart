import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/screens/success_screen.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/shared/widgets/gradient_text.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';


class ForgotPasswordFormScreen extends StatefulWidget {
  const ForgotPasswordFormScreen({super.key});
  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordFormScreen> createState() =>
      _ForgotPasswordFormScreenState();
}

class _ForgotPasswordFormScreenState extends State<ForgotPasswordFormScreen> {
  final fromKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  String getEmailAddress() {
    return emailController.text.trim();
  }

  String getPassword() {
    return passwordController.text.trim();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: whiteSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(normalWhiteSpace),
                const Row(
                  children: [
                    DecoratedBackButton(),
                    HSpace(extraSmallWhiteSpace),
                    AppIcon(iconName: 'login_logo'),
                  ],
                ),
                const VSpace(whiteSpace),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: headingText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const VSpace(extraSmallWhiteSpace),
                Text(
                  "We'll help you recover your account. Enter the email address or phone number linked to your Gofreedom account, and we'll send you instructions to reset your password.",
                  style: TextStyle(
                    fontSize: paragraphText,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
                const VSpace(whiteSpace),
                Form(
                  key: fromKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      buildTextField(
                        controller: emailController,
                        label: 'Reset Your Password',
                        placeholder: 'Enter Email Address',
                        inputType: TextInputType.emailAddress,
                        prefixIconUrl: 'assets/app_icons/envelope.svg',
                      ),
                    ],
                  ),
                ),
                const VSpace(whiteSpace),
                FreedomButton(
                  backGroundColor: Colors.black,
                  borderRadius: BorderRadius.circular(roundedMd),
                  width: double.infinity,
                  title: isLoading
                      ? 'Sending Instructions...'
                      : 'Send Reset Instructions',
                  onPressed: () {
                    if (fromKey.currentState!.validate()) {
                      if (isLoading) {
                        return;
                      }
                      final apiController = ApiController('auth');
                      final email = getEmailAddress();
                      context.read<RegistrationFormCubit>().setEmail(email);
                      setState(() {
                        isLoading = true;
                      });
                      apiController.post(
                        context,
                        'forgot-password',
                        {'email': email},
                        (success, data) {
                          setState(() {
                            isLoading = false;
                          });
                          if (success) {
                            Navigator.pushNamed(
                              context,
                              SuccessScreen.routeName,
                              arguments: {'type': 'forgot-password'},
                            );
                          }
                        },
                      );
                    }
                  },
                ),
                const VSpace(whiteSpace),
                SizedBox(
                  width: Responsive.width(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Remembered password? '),
                      GradientText(
                        text: 'Login now',
                        routeNameToMoveTo: LoginFormScreen.routeName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
