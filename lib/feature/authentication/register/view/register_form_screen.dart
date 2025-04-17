import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:get/get.dart';
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
  bool loading = false;

  String countryCode = '+233';

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final motorcycleTypeController = TextEditingController();
  final motorcycleColorController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final motorcycleNumberController = TextEditingController();
  final motorcycleYearController = TextEditingController();
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String countryValue = '';
  String stateValue = '';
  String cityValue = '';

  @override
  void initState() {
    super.initState();
    phoneController
      ..text = countryCode
      ..addListener(() {
        if (!phoneController.text.startsWith(countryCode)) {
          phoneController
            ..text = countryCode +
                phoneController.text.replaceAll(RegExp(r'^\+\d+'), '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: phoneController.text.length),
            );
        }
      });
  }

  String getFullPhoneNumber() {
    return phoneController.text;
  }

  @override
  void dispose() {
    for (final controller in [
      fullNameController,
      emailController,
      phoneController,
      motorcycleTypeController,
      motorcycleColorController,
      licenseNumberController,
      motorcycleNumberController,
      motorcycleYearController,
      streetController,
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
      final names = fullNameController.text.trim().split(' ');
      final data = {
        'firstName': names[0].capitalize,
        'surname': names[names.length - 1].capitalize,
        'otherName': names[1],
        'email': emailController.text.trim(),
        'phone': getFullPhoneNumber(),
        'motorcycleType': motorcycleTypeController.text.trim(),
        'motorcycleColor': motorcycleColorController.text.trim(),
        'licenseNumber': licenseNumberController.text.trim(),
        'motorcycleNumber': motorcycleNumberController.text.trim(),
        'motorcycleYear': motorcycleYearController.text.trim(),
        'address': {
          'street': streetController.text.trim(),
          'city': countryValue.capitalize,
          'state': stateValue.capitalize,
          'country': cityValue.capitalize,
          'postalCode': postalCodeController.text.trim(),
        },
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
      };

      setState(() {
        loading = true;
      });
      apiController.post(context, 'register', data, (success, result) {
        if (success) {
          context.read<RegistrationFormCubit>().setEmail(emailController.text);
          Navigator.pushNamed(context, VerifyOtpScreen.routeName);
        }
        setState(() {
          loading = false;
        });
      });
    }
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
                    horizontal: whiteSpace,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VSpace(smallWhiteSpace),
                      const Text(
                        "Driver Registration Let's Get to Know You.",
                        style: TextStyle(
                          fontSize: headingText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const VSpace(smallWhiteSpace),
                      Text(
                        'Please provide a few details so we can complete your profile.',
                        style: TextStyle(
                          fontSize: paragraphText,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                          // fontStyle: GoogleFonts.poppins.fontFamily,
                        ),
                      ),
                      const VSpace(whiteSpace),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            buildTextField(
                              controller: fullNameController,
                              label: 'Full Name',
                              placeholder: 'Your name',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                if (value.trim().split(' ').length < 2) {
                                  return 'At least 2 names are required';
                                }
                                return null;
                              },
                            ),
                            buildTextField(
                              controller: emailController,
                              label: 'Email',
                              placeholder: 'Enter Email Address',
                              inputType: TextInputType.emailAddress,
                              prefixIconUrl: 'assets/app_icons/envelope.svg',
                            ),
                            // buildTextField(
                            //   controller: phoneController,
                            //   label: 'Phone',
                            //   placeholder: 'Enter Phone Number',
                            //   inputType: TextInputType.phone,
                            // ),
                            TextFieldFactory.phone(
                              controller: phoneController,
                              fontStyle: const TextStyle(
                                fontSize: 19.58,
                                color: Colors.black,
                              ),
                              prefixText: Transform.translate(
                                offset: const Offset(0, -5),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 18,
                                    bottom: 7,
                                    right: 17,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: const Color(0x4FF59E0B),
                                      border: Border.all(),
                                    ),
                                    child: Stack(
                                      children: [
                                        CountryCodePicker(
                                          onChanged: (value) {
                                            setState(() {
                                              countryCode =
                                                  value.dialCode ?? '+233';
                                              phoneController.text =
                                                  countryCode;
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                          initialSelection: 'GH',
                                          hideMainText: true,
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.014,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.11,
                                          child: SvgPicture.asset(
                                            'assets/app_icons/drop_down.svg',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                final cleanedNumber =
                                    val.replaceAll(RegExp(r'\D'), '');

                                if (cleanedNumber.isEmpty) {
                                  return 'Please enter digits only';
                                }

                                if (cleanedNumber.length < 10) {
                                  return 'Phone number must be at least 10 digits long';
                                }

                                return null; // Valid input
                              },
                            ),

                            buildTextField(
                              controller: motorcycleTypeController,
                              label: 'Motorcycle Type',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: motorcycleColorController,
                              label: 'Motorcycle Color',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: licenseNumberController,
                              label: 'License Number',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: motorcycleNumberController,
                              label: 'Motorcycle Number',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: motorcycleYearController,
                              label: 'Motorcycle Year',
                              inputType: TextInputType.number,
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),

                            SelectState(
                              onCountryChanged: (value) {
                                setState(() {
                                  countryValue = value;
                                });
                              },
                              onStateChanged: (value) {
                                setState(() {
                                  stateValue = value;
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  cityValue = value;
                                });
                              },
                            ),
                            buildTextField(
                              controller: streetController,
                              label: 'Street Name',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: postalCodeController,
                              label: 'Postal Code',
                              prefixIconUrl: 'assets/app_icons/typing.svg',
                            ),
                            buildTextField(
                              controller: passwordController,
                              label: 'Password',
                              placeholder: 'Create a strong password',
                              obscure: true,
                              prefixIconUrl:
                                  'assets/app_icons/password-type.svg',
                            ),
                            buildTextField(
                              controller: confirmPasswordController,
                              label: 'Confirm Password',
                              placeholder: 'Confirm password again',
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
                            side: BorderSide(color: gradient1, width: 16),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: smallWhiteSpace,
                        ),
                        child: FreedomButton(
                          backGroundColor: Colors.black,
                          borderRadius: BorderRadius.circular(roundedMd),
                          width: double.infinity,
                          useLoader: loading,
                          disabled: !hasReadTermsAndCondition,
                          title: 'Complete Registration',
                          buttonTitle: const Text(
                            'Registering...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: normalText,
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

Widget buildTextField({
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
      hintText: placeholder ?? 'Enter $label',
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
