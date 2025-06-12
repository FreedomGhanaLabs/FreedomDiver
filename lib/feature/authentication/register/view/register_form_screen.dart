import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/authentication/login/cubit/login_cubit.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/register.dart';
import 'package:freedomdriver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/gradient_text.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';

import '../../../kyc/view/background_verification_screen.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});
  static const routeName = '/register';

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final apiController = ApiController('auth');

  int _currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

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
            ..text =
                countryCode +
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
      postalCodeController,
      confirmPasswordController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void submitRegistration() {
    // if (_formKey.currentState!.validate()) {
    //   if (!hasReadTermsAndCondition) {
    //     return;
    //   }
    final names = fullNameController.text.trim().split(' ');
    final data = {
      'firstName': names[0].trim().capitalize,
      'surname': names[names.length - 1].trim().capitalize,
      'otherName': names[1].trim(),
      'email': emailController.text.trim(),
      'phone': getFullPhoneNumber(),
      'motorcycleType': motorcycleTypeController.text.trim(),
      'motorcycleColor': motorcycleColorController.text.trim(),
      'licenseNumber': licenseNumberController.text.trim(),
      'motorcycleNumber': motorcycleNumberController.text.trim(),
      'motorcycleYear': motorcycleYearController.text.trim(),
      'address': {
        'street': streetController.text.trim(),
        'city': cityValue.trim().capitalize,
        'state': stateValue.trim().capitalize,
        'country': countryValue.trim().capitalize,
        'postalCode': postalCodeController.text.trim(),
      },
      'password': passwordController.text,
      'confirmPassword': confirmPasswordController.text,
    };

    apiController.post(context, 'register', data, (success, result) {
      if (success) {
        context.read<LoginFormCubit>().setEmail(emailController.text);
        Navigator.pushNamed(context, VerifyOtpScreen.routeName);
      }
    }, showOverlay: true);
  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(Responsive.top(context) + medWhiteSpace),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: whiteSpace),
                child: AppIcon(iconName: 'login_logo'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: whiteSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(smallWhiteSpace + 5),
                    AppHeading(),
                    const VSpace(extraSmallWhiteSpace),
                    AppDescription(),
                    const VSpace(extraSmallWhiteSpace),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Stepper(
                    physics: const ClampingScrollPhysics(),
                    connectorColor: WidgetStatePropertyAll(gradient1),
                    currentStep: _currentStep,
                    onStepContinue: onStepContinue,
                    onStepCancel:
                        _currentStep > 0
                            ? () {
                              setState(() => _currentStep--);
                            }
                            : null,
                    steps: [
                      personalInfoStep(context),
                      motorcycleInfoStep(),
                      addressInfoStep(),
                      securityStep(),
                    ],
                    controlsBuilder: (context, details) {
                      final isLastStep = _currentStep == _formKeys.length - 1;
                      return Padding(
                        padding: const EdgeInsets.only(top: smallWhiteSpace),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 100,
                              child: SimpleButton(
                                title: isLastStep ? "Register" : "Next",
                                onPressed: details.onStepContinue,
                              ),
                            ),
                            if (details.onStepCancel != null) ...[
                              HSpace(extraSmallWhiteSpace),
                              OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(color: Colors.grey.shade300),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        roundedMd,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: paragraphTextStyle.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const VSpace(whiteSpace),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: whiteSpace,
          right: whiteSpace,
          bottom: Responsive.bottom(context) + extraSmallWhiteSpace,
        ),
        width: Responsive.width(context),
        color: Colors.white,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? '),
            GradientText(
              text: 'Login',
              routeNameToMoveTo: LoginFormScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }

  void onStepContinue() {
    final isLastStep = _currentStep == _formKeys.length - 1;
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (isLastStep) {
        if (!hasReadTermsAndCondition) {
          showToast(
            context,
            "Terms and Condition",
            'You must accept the Terms & Conditions',
            toastType: ToastType.warning,
          );
          return;
        }
        submitRegistration();
      } else {
        setState(() => _currentStep++);
      }
    }
  }

  Step securityStep() {
    return Step(
      title: const Text("Security"),
      isActive: _currentStep >= 3,
      content: Form(
        key: _formKeys[3],
        child: Column(
          children: [
            buildTextField(
              controller: passwordController,
              label: 'Password',
              placeholder: 'Create a strong password',
              obscure: true,
              prefixIconUrl: 'assets/app_icons/password-type.svg',
            ),
            buildTextField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              placeholder: 'Confirm password again',
              obscure: true,
              prefixIconUrl: 'assets/app_icons/password-type.svg',
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
            const VSpace(whiteSpace),
            Row(
              children: [
                Checkbox.adaptive(
                  value: hasReadTermsAndCondition,
                  onChanged: (x) {
                    setState(() {
                      hasReadTermsAndCondition = !hasReadTermsAndCondition;
                    });
                  },
                  side: BorderSide(color: gradient1, width: 16),
                  fillColor: WidgetStatePropertyAll(
                    hasReadTermsAndCondition ? thickFillColor : fillColor,
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
          ],
        ),
      ),
    );
  }

  Step addressInfoStep() {
    return Step(
      title: const Text("Address Info"),
      isActive: _currentStep >= 2,
      content: Form(
        key: _formKeys[2],
        child: Column(
          children: [
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
              prefixIconUrl: getIconUrl('typing'),
            ),
            buildTextField(
              controller: postalCodeController,
              label: 'Landmark',
              prefixIconUrl: getIconUrl('typing'),
            ),
          ],
        ),
      ),
    );
  }

  Step motorcycleInfoStep() {
    int index = 1;
    return Step(
      title: const Text("Motorcycle Info"),
      isActive: _currentStep >= index,
      content: Form(
        key: _formKeys[index],
        child: Column(
          children: [
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
              prefixIconUrl: 'assets/app_icons/numbers.svg',
            ),
            buildTextField(
              controller: motorcycleNumberController,
              label: 'Motorcycle Number',
              prefixIconUrl: 'assets/app_icons/numbers.svg',
            ),
            buildTextField(
              controller: motorcycleYearController,
              label: 'Motorcycle Year',
              inputType: TextInputType.number,
              prefixIconUrl: 'assets/app_icons/numbers.svg',
            ),
          ],
        ),
      ),
    );
  }

  Step personalInfoStep(BuildContext context) {
    return Step(
      title: const Text("Personal Info"),
      isActive: _currentStep >= 0,
      content: Form(
        key: _formKeys[0],
        child: Column(
          children: [
            buildTextField(
              controller: fullNameController,
              label: 'Full Name',
              placeholder: 'Enter your fullname',
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
                fontSize: paragraphText,
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
                              countryCode = value.dialCode ?? '+233';
                              phoneController.text = countryCode;
                            });
                          },
                          padding: EdgeInsets.zero,
                          initialSelection: 'GH',
                          hideMainText: true,
                        ),
                        Positioned(
                          top: Responsive.height(context) * 0.014,
                          left: Responsive.width(context) * 0.11,
                          child: const AppIcon(iconName: 'drop_down'),
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
                final cleanedNumber = val.replaceAll(RegExp(r'\D'), '');

                if (cleanedNumber.isEmpty) {
                  return 'Please enter digits only';
                }

                if (cleanedNumber.length < 10) {
                  return 'Phone number must be at least 10 digits long';
                }

                return null; // Valid input
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppDescription extends StatelessWidget {
  const AppDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Please provide a few details so we can complete your profile.',
      style: TextStyle(
        fontSize: paragraphText,
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade700,
      ),
    );
  }
}

class AppHeading extends StatelessWidget {
  const AppHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Let's Get to Know You.",
      style: TextStyle(fontSize: headingText, fontWeight: FontWeight.w600),
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
  bool hasBadge = false,
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
      fontStyle: const TextStyle(fontSize: normalText, color: Colors.black),
      validator:
          validator ??
          (val) =>
              val == null || val.trim().isEmpty ? '$label is required' : null,
    ),
  );
}
