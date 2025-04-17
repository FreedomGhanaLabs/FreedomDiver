import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
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

  String getFullEmail() {
    return emailController.text.trim();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(67),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: SvgPicture.asset(
                    'assets/app_icons/login_logo.svg',
                  ),
                ),
                const VSpace(whiteSpace),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Form(
                    key: fromKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFieldFactory(
                      controller: emailController,
                      label: 'Email Address',
                      hintText: 'Enter your valid email address',
                      keyboardType: TextInputType.emailAddress,
                      fontStyle: const TextStyle(
                        fontSize: 19.58,
                        color: Colors.black,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email is required';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                const VSpace(29),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: FreedomButton(
                    backGroundColor: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                    width: double.infinity,
                    useLoader: true,
                    title: 'Continue',
                    buttonTitle: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 17.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      if (fromKey.currentState!.validate()) {
                        // final apiController = ApiController('login');
                        final email = getFullEmail();
                        context.read<RegistrationFormCubit>().setEmail(email);

                        // apiController.post(
                        //   context,
                        //   'email/request',
                        //   {'email': email},
                        //   (success, res) {
                        //     debugPrint(email);
                        //   },
                        // );
                        Navigator.pushNamed(context, '/verify_otp');
                      }
                    },
                  ),
                ),
                const VSpace(26),
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
                const VSpace(28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: FreedomButton(
                    backGroundColor: socialLoginColor,
                    leadingIcon: 'apple_icon',
                    borderRadius: BorderRadius.circular(7),
                    title: 'Login with Apple',
                    useLoader: true,
                    buttonTitle: Text(
                      'Login with Apple',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    titleColor: Colors.black,
                    width: double.infinity,
                    fontSize: 16,
                    onPressed: () {},
                  ),
                ),
                const VSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: FreedomButton(
                    backGroundColor: socialLoginColor,
                    leadingIcon: 'google_icon',
                    useLoader: true,
                    borderRadius: BorderRadius.circular(7),
                    buttonTitle: Text(
                      'Login with Google',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    titleColor: Colors.black,
                    fontSize: 16,
                    width: double.infinity,
                    onPressed: () {},
                  ),
                ),
                const VSpace(whiteSpace),
                Center(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(
                          fontSize: paragraphText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
