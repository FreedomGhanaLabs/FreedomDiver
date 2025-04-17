import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});
  static const routeName = '/register';

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final apiController = ApiController('auth');

  bool hasReadTermsAndCondition = false;

  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final otherNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final motorcycleTypeController = TextEditingController();
  final motorcycleColorController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final motorcycleNumberController = TextEditingController();
  final motorcycleYearController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    for (final controller in [
      firstNameController,
      surnameController,
      otherNameController,
      emailController,
      phoneController,
      motorcycleTypeController,
      motorcycleColorController,
      licenseNumberController,
      motorcycleNumberController,
      motorcycleYearController,
      addressController,
      passwordController,
      confirmPasswordController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void submitRegistration() {
    if (_formKey.currentState!.validate()) {
      if (!hasReadTermsAndCondition) {
        return;
      }
      final data = {
        'firstName': firstNameController.text.trim(),
        'surname': surnameController.text.trim(),
        'otherName': otherNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'motorcycleType': motorcycleTypeController.text.trim(),
        'motorcycleColor': motorcycleColorController.text.trim(),
        'licenseNumber': licenseNumberController.text.trim(),
        'motorcycleNumber': motorcycleNumberController.text.trim(),
        'motorcycleYear': motorcycleYearController.text.trim(),
        'address': addressController.text.trim(),
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
      };

      debugPrint('$data');

      // apiController.post(context, 'register', data, (success, result) {
      //   if (success) {
      //     Navigator.pushNamed(context, '/verify_otp');
      //   }
      // });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    bool? obscure,
    String? Function(String?)? validator,
    String? placeholder,
    String? prefixIconUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: smallWhiteSpace),
      child: TextFieldFactory(
        controller: controller,
        prefixSvgUrl: prefixIconUrl,
        label: label,
        obscure: obscure,
        hintText: placeholder ?? label,
        keyboardType: inputType,
        fontStyle: const TextStyle(
          fontSize: normalText,
          color: Colors.black,
        ),
        validator: validator ??
            (val) =>
                val == null || val.trim().isEmpty ? '$label is required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(largeWhiteSpace),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: smallWhiteSpace,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/app_icons/login_logo.svg',
                    ),
                    const VSpace(extraSmallWhiteSpace),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: smallWhiteSpace,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VSpace(smallWhiteSpace),
                      const Text(
                        "Driver Registration Let's Get to Know You.",
                        style: TextStyle(
                          fontSize: headingText,
                          fontWeight: FontWeight.w500,
                          // fontStyle: GoogleFonts.poppins.fontFamily,
                        ),
                      ),
                      // const VSpace(smallWhiteSpace),
                      Text(
                        'Please provide a few details so we can complete your profile.',
                        style: TextStyle(
                          fontSize: paragraphText,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                          // fontStyle: GoogleFonts.poppins.fontFamily,
                        ),
                      ),
                      const VSpace(whiteSpace),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: firstNameController,
                              label: 'Full Name',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: emailController,
                              label: 'Email',
                              inputType: TextInputType.emailAddress,
                              prefixIconUrl: 'assets/app_icons/envelope.svg',
                            ),
                            _buildTextField(
                              controller: phoneController,
                              label: 'Phone',
                              inputType: TextInputType.phone,
                            ),
                            _buildTextField(
                              controller: motorcycleTypeController,
                              label: 'Motorcycle Type',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: motorcycleColorController,
                              label: 'Motorcycle Color',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: licenseNumberController,
                              label: 'License Number',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: motorcycleNumberController,
                              label: 'Motorcycle Number',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: motorcycleYearController,
                              label: 'Motorcycle Year',
                              inputType: TextInputType.number,
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: addressController,
                              label: 'Permanent Address',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            _buildTextField(
                              controller: passwordController,
                              label: 'Password',
                              obscure: true,
                              prefixIconUrl:
                                  'assets/app_icons/password-type.svg',
                            ),
                            _buildTextField(
                              controller: confirmPasswordController,
                              label: 'Confirm Password',
                              obscure: true,
                              prefixIconUrl:
                                  'assets/app_icons/password-type.svg',
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Confirm your password';
                                }
                                if (val != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const VSpace(whiteSpace),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: hasReadTermsAndCondition,
                            onChanged: (x) {
                              setState(() {
                                hasReadTermsAndCondition =
                                    !hasReadTermsAndCondition;
                              });
                            },
                            side: BorderSide(color: gradient1),
                            fillColor: WidgetStatePropertyAll(
                              hasReadTermsAndCondition
                                  ? thickFillColor
                                  : fillColor,
                            ),
                          ),
                          Text(
                            'Read Terms and Conditions',
                            style: TextStyle(
                              fontSize: paragraphText,
                              fontWeight: FontWeight.w600,
                              color: gradient1,
                            ),
                          ),
                        ],
                      ),
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
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: submitRegistration,
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
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Already have an account?',
                              style: GoogleFonts.poppins(
                                fontSize: paragraphText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VSpace(whiteSpace),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
