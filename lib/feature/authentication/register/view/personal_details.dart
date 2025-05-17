import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/register.dart';
import 'package:freedomdriver/feature/main_activity/main_activity_screen.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
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
  final firstNameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  bool termAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  hintText: 'Your name',
                  hintTextStyle: GoogleFonts.poppins(
                    fontSize: 15.06,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x42F59E0B),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 21.06,
                    left: 8.06,
                    bottom: 21.06,
                  ),
                  controller: firstNameController,
                  prefixText: Padding(
                    padding:
                        const EdgeInsets.only(top: 21, left: 8.06, bottom: 21),
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
                child: TextFieldFactory.email(
                  controller: emailController,
                  hintTextStyle: GoogleFonts.poppins(
                    fontSize: 15.06,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x42F59E0B),
                  ),
                  prefixText: Padding(
                    padding:
                        const EdgeInsets.only(top: 21, left: 8.06, bottom: 21),
                    child: SvgPicture.asset('assets/app_icons/email_icon.svg'),
                  ),
                  hintText: 'Your email',
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'Please enter your email';
                    }
                    final regX = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!regX.hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
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
                            emailKey.currentState!.validate()) {
                          Navigator.pushNamed(
                            context,
                            MainActivityScreen.routeName,
                          );
                        }
                        context
                            .read<VerifyOtpCubit>()
                            .isFirstTimer(isFirstTimer: false);
                      }
                    : null,
                backGroundColor: Colors.black,
                title: 'Complete Registration',
                buttonTitle: Text('Complete Registration',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17.92,
                      fontWeight: FontWeight.w500,
                  ),
                ),
                fontSize: 17.92,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
