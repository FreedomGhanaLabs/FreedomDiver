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
      final apiController = ApiController('auth');
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

      apiController.post(context, 'register', data, (success, result) {
        if (success) {
          Navigator.pushNamed(context, '/verify_otp');
        }
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
      child: TextFieldFactory(
        controller: controller,
        label: label,
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
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/app_icons/login_logo.svg',
                    ),
                    const VSpace(smallWhiteSpace),
                    const Text(
                      '  Driver Registration',
                      style: TextStyle(
                        fontSize: headingText,
                        fontWeight: FontWeight.w600,
                        // fontStyle: GoogleFonts.poppins.fontFamily,
                      ),
                    ),
                   
                    const VSpace(whiteSpace),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: firstNameController,
                                label: 'First Name',
                              ),
                              _buildTextField(
                                controller: surnameController,
                                label: 'Surname',
                              ),
                              _buildTextField(
                                controller: otherNameController,
                                label: 'Other Name',
                              ),
                              _buildTextField(
                                controller: emailController,
                                label: 'Email',
                                inputType: TextInputType.emailAddress,
                              ),
                              _buildTextField(
                                controller: phoneController,
                                label: 'Phone',
                                inputType: TextInputType.phone,
                              ),
                              _buildTextField(
                                controller: motorcycleTypeController,
                                label: 'Motorcycle Type',
                              ),
                              _buildTextField(
                                controller: motorcycleColorController,
                                label: 'Motorcycle Color',
                              ),
                              _buildTextField(
                                controller: licenseNumberController,
                                label: 'License Number',
                              ),
                              _buildTextField(
                                controller: motorcycleNumberController,
                                label: 'Motorcycle Number',
                              ),
                              _buildTextField(
                                controller: motorcycleYearController,
                                label: 'Motorcycle Year',
                                inputType: TextInputType.number,
                              ),
                              _buildTextField(
                                controller: addressController,
                                label: 'Address',
                              ),
                              _buildTextField(
                                controller: passwordController,
                                label: 'Password',
                                obscure: true,
                              ),
                              _buildTextField(
                                controller: confirmPasswordController,
                                label: 'Confirm Password',
                                obscure: true,
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
