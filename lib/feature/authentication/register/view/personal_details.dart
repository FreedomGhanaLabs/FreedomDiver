import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({super.key});
  static const routeName = '/personal_details';

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final confirmPasswordKey = GlobalKey<FormState>();
  bool termAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const DecoratedBackButton(),
                    ),
                    const HSpace(13.9),
                    Text(
                      'Personal Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20.59,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const VSpace(20.45),
                Text(
                  'Almost Done! Let’s Get to Know You',
                  style: GoogleFonts.poppins(
                    fontSize: 17.86,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Please provide a few details so we can\n complete your profile.',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 10.41,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const VSpace(26.85),
                Text(
                  'Full name ',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.06,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const VSpace(6.82),
                Form(
                  key: firstNameKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFieldFactory.name(
                    hinText: 'Your name',
                    hintTextStyle: GoogleFonts.poppins(
                      fontSize: 15.06,
                      fontWeight: FontWeight.w400,
                      color: const Color(0x42F59E0B),
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 21.06, left: 8.06, bottom: 21.06),
                    controller: firstNameController,
                    prefixText: Padding(
                      padding: const EdgeInsets.only(
                          top: 21, left: 8.06, bottom: 21),
                      child: SvgPicture.asset(
                        'assets/app_icons/user_icon.svg',
                        colorFilter:
                            ColorFilter.mode(thickFillColor, BlendMode.srcIn),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your name';
                      }
                      final regX = RegExp(r'^[a-zA-Z\s]+$');
                      if (!regX.hasMatch(val)) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                ),
                const VSpace(9),
                Text(
                  'Email',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.06,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const VSpace(6.82),
                Form(
                  key: emailKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFieldFactory.email(
                    controller: emailController,
                    hintTextStyle: GoogleFonts.poppins(
                      fontSize: 15.06,
                      fontWeight: FontWeight.w400,
                      color: const Color(0x42F59E0B),
                    ),
                    prefixText: Padding(
                      padding: const EdgeInsets.only(
                          top: 21, left: 8.06, bottom: 21),
                      child:
                          SvgPicture.asset('assets/app_icons/email_icon.svg'),
                    ),
                    hinText: 'Your email',
                    validator: (email) {
                      if (email!.isEmpty) {
                        return 'Please enter your email';
                      }
                      final regX = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!regX.hasMatch(email)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const VSpace(9),
                Text(
                  'Password',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.06,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const VSpace(9),
                PasswordField(
                    passwordKey: passwordKey,
                    passwordController: passwordController),
                const VSpace(9),
                Text(
                  'Confirm Password',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.06,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const VSpace(9),
                ConfirmPasswordField(
                  originalPassword: passwordController,
                    confirmPassword: confirmPasswordController,
                    passwordKey: confirmPasswordKey),
                const VSpace(25.46),
                Row(
                  children: [
                    Checkbox.adaptive(
                      activeColor: thickFillColor,
                      side: BorderSide(color: thickFillColor),
                      value: termAccepted,
                      onChanged: (val) {
                        setState(() {
                          termAccepted = val ?? false;
                        });
                      },
                    ),
                    Text(
                      'Read Terms and Condition',
                      style: GoogleFonts.poppins(
                        fontSize: 11.49,
                        color: thickFillColor,
                      ),
                    ),
                  ],
                ),
                const VSpace(16.03),
                FreedomButton(
                  // ignore: use_if_null_to_convert_nulls_to_bools
                  onPressed: termAccepted == true
                      ? () {
                          if (firstNameKey.currentState!.validate() &&
                              emailKey.currentState!.validate() &&
                              passwordKey.currentState!.validate() &&
                              confirmPasswordKey.currentState!.validate()) {
                            Navigator.pushNamed(
                              context,
                              RegisterFormScreen.routeName,
                            );
                            context.read<RegistrationFormCubit>().setUserDetails(
                              driversEmail: emailController.text,
                              driversName: firstNameController.text,
                              password: passwordController.text
                            );
                          }

                        }
                      : null,
                  backGroundColor: Colors.black,
                  title: 'Complete Registration',
                  buttonTitle: Text('Complete Registration',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17.92,
                        fontWeight: FontWeight.w500,
                      )),
                  fontSize: 17.92,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField(
      {required this.passwordController, required this.passwordKey, super.key});
  final Key passwordKey;
  final TextEditingController passwordController;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.passwordKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFieldFactory.password(
        controller: widget.passwordController,
        hintTextStyle: GoogleFonts.poppins(
          fontSize: 15.06,
          fontWeight: FontWeight.w400,
          color: const Color(0x42F59E0B),
        ),
        prefixText: Padding(
          padding: const EdgeInsets.only(top: 21, left: 8.06, bottom: 21),
          child: SvgPicture.asset(
              'assets/app_icons/password_icon.svg'), // Changed to lock icon
        ),
        hintText: 'Your password',
        obscureText: _obscureText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        validator: (password) {
          if (password == null || password.isEmpty) {
            return 'Please enter your password';
          }

          if (password.length < 8) {
            return 'Password must be at least 8 characters';
          }

          // Simpler checks that don't rely as much on RegExp
          bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
          bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
          bool hasDigits = password.contains(new RegExp(r'[0-9]'));
          bool hasSpecialChars =
              password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

          List<String> missing = [];
          if (!hasUppercase) missing.add("uppercase letter");
          if (!hasLowercase) missing.add("lowercase letter");
          if (!hasDigits) missing.add("number");
          if (!hasSpecialChars) missing.add("special character");

          if (missing.isNotEmpty) {
            return 'Password must include: ${missing.join(", ")}';
          }

          // Check against common passwords
          final commonPasswords = ['password', '123456', 'qwerty', 'admin'];
          if (commonPasswords.contains(password.toLowerCase())) {
            return 'This password is too common';
          }

          return null;
        },
      ),
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({
    required this.confirmPassword,
    required this.passwordKey,
    required this.originalPassword, // Add this parameter
    super.key
  });

  final Key passwordKey;
  final TextEditingController confirmPassword;
  final TextEditingController originalPassword; // Reference to original password controller

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.passwordKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFieldFactory.password(
        controller: widget.confirmPassword,
        hintTextStyle: GoogleFonts.poppins(
          fontSize: 15.06,
          fontWeight: FontWeight.w400,
          color: const Color(0x42F59E0B),
        ),
        prefixText: Padding(
          padding: const EdgeInsets.only(top: 21, left: 8.06, bottom: 21),
          child: SvgPicture.asset('assets/app_icons/password_icon.svg'),
        ),
        hintText: 'Confirm password',
        obscureText: _obscureText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        validator: (confirmPassword) {
          if (confirmPassword == null || confirmPassword.isEmpty) {
            return 'Please confirm your password';
          }

          // Check if the confirmation matches the original password
          if (confirmPassword != widget.originalPassword.text) {
            return 'Passwords do not match';
          }

          return null;
        },
      ),
    );
  }
}