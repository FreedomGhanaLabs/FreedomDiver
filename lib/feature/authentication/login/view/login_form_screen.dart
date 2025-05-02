import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/forgot_password/view/forgot_password_form.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/shared/widgets/gradient_text.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
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
                const AppIcon(iconName: 'login_logo'),
                const VSpace(whiteSpace),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: headingText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const VSpace(extraSmallWhiteSpace),
                Text(
                  'Log in to your Gofreedom account and get back to what matters - riding with freedom or earning on your own schedule.',
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
                        label: 'Email',
                        placeholder: 'Enter Email Address',
                        inputType: TextInputType.emailAddress,
                        prefixIconUrl: 'assets/app_icons/envelope.svg',
                      ),
                      buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        placeholder: 'Enter your password',
                        obscure: true,
                        prefixIconUrl: 'assets/app_icons/password-type.svg',
                      ),
                    ],
                  ),
                ),
                const VSpace(whiteSpace),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password? '),
                    GradientText(
                      text: 'Reset it',
                      routeNameToMoveTo: ForgotPasswordFormScreen.routeName,
                    ),
                  ],
                ),
                const VSpace(extraSmallText),
                FreedomButton(
                  backGroundColor: Colors.black,
                  disabled: isLoading,
                  title: isLoading ? 'Logging in...' : 'Login',
                  onPressed: () {
                    if (fromKey.currentState!.validate()) {
                      if (isLoading) {
                        return;
                      }
                      final apiController = ApiController('auth/login');
                      final email = getEmailAddress();
                      context.read<RegistrationFormCubit>().setEmail(email);
                      setState(() {
                        isLoading = true;
                      });
                      apiController.post(
                        context,
                        'email',
                        {
                          'email': email,
                          'password': getPassword(),
                        },
                        (success, res) {
                          setState(() {
                            isLoading = false;
                          });
                          if (success) {
                            Navigator.pushNamed(
                              context,
                              VerifyOtpScreen.routeName,
                              arguments: {'type': 'login'},
                            );
                          }
                        },
                        showOverlay: true,
                      );
                    }
                  },
                ),
                const VSpace(whiteSpace),
                Row(
                  children: [
                    Container(
                      height: 7,
                      width: 167,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: colorGrey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Or',
                      style: GoogleFonts.poppins(fontSize: 15.36),
                    ),
                    const Spacer(),
                    Container(
                      height: 7,
                      width: 167,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: colorGrey,
                      ),
                    ),
                  ],
                ),
                const VSpace(whiteSpace),
                FreedomButton(
                  backGroundColor: socialLoginColor,
                  leadingIcon: 'apple_icon',
                  borderRadius: BorderRadius.circular(7),
                  title: 'Login with Apple',
                  useLoader: true,
                  buttonTitle: Text(
                    'Login with Apple',
                    style: GoogleFonts.poppins(
                      fontSize: normalText,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  titleColor: Colors.black,
                  width: double.infinity,
                  fontSize: normalText,
                  onPressed: () {},
                ),
                const VSpace(whiteSpace),
                FreedomButton(
                  backGroundColor: socialLoginColor,
                  leadingIcon: 'google_icon',
                  useLoader: true,
                  borderRadius: BorderRadius.circular(7),
                  buttonTitle: Text(
                    'Login with Google',
                    style: GoogleFonts.poppins(
                      fontSize: normalText,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  titleColor: Colors.black,
                  fontSize: normalText,
                  width: double.infinity,
                  onPressed: () {},
                ),
                const VSpace(whiteSpace),
                SizedBox(
                  width: Responsive.width(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GradientText(
                        text: 'Sign up here',
                        routeNameToMoveTo: RegisterFormScreen.routeName,
                      ),
                    ],
                  ),
                ),
                const VSpace(whiteSpace),
              ],
            ),
          );
        },
      ),
    );
  }
}
