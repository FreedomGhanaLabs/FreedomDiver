import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/documents/ghana_card/cubit/ghana_card_cubit.dart';
import 'package:freedomdriver/feature/documents/ghana_card/ghana_card.model.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:intl/intl.dart';

import '../../driver_license/view/license_form.dart';

class GhanaCardForm extends StatefulWidget {
  const GhanaCardForm({super.key});
  static const routeName = '/ghana-card-form';

  @override
  State<GhanaCardForm> createState() => _GhanaCardFormState();
}

class _GhanaCardFormState extends State<GhanaCardForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController personalIdNumber = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController otherName = TextEditingController();
  final TextEditingController height = TextEditingController();

  String? dateOfBirth;
  String? expiryDate;
  String sex = 'male';

  @override
  @override
  void initState() {
    loadCardDetails();
    super.initState();
  }

  void loadCardDetails() {
    final driverCubit = context.read<DriverCubit>().state;
    if (driverCubit is DriverLoaded) {
      final driver = driverCubit.driver;
      surname.text = driver.surname;
      firstName.text = driver.firstName;
      otherName.text = driver.otherName;
    }
  }

  Future<void> _pickDate({required bool isDob}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        if (isDob) {
          dateOfBirth = formatted;
        } else {
          expiryDate = formatted;
        }
      });
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<GhanaCardCubit>().loadGhanaCard(
        GhanaCard(
          personalIdNumber: personalIdNumber.text.trim(),
          surname: surname.text.trim(),
          firstName: firstName.text.trim(),
          otherName: otherName.text.trim(),
          sex: sex,
          dateOfBirth: dateOfBirth ?? '',
          height: height.text.trim(),
          expiryDate: expiryDate ?? '',
          verificationStatus: 'pending',
          adminComments: '',
          uploadedAt: DateTime.now(),
        ),
      );

      Navigator.pushNamed(
        context,
        BackgroundVerificationScreen.routeName,
        arguments: {'type': ghanaCard},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Ghana Card',
      bodyHeader: 'Enter your Ghana Card details',
      bodyDescription:
          'Ensure all fields are filled correctly to verify your identity.',
      children: [
        DecoratedContainer(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                buildField('Ghana Card Number', personalIdNumber),
                buildField('Surname', surname),
                buildField('First Name', firstName),
                buildField('Other Name', otherName),
                CustomDropDown(
                  label: 'Gender',
                  value: sex,
                  items: ['male', 'female', 'other'],
                  onChanged: (value) {
                    setState(() {
                      sex = value;
                    });
                  },
                ),
                buildField('Height (cm)', height),
                CustomDropDown(
                  onTap: () => _pickDate(isDob: true),
                  label: 'Date of Birth',
                  value: dateOfBirth ?? 'Choose date',
                ),

                CustomDropDown(
                  onTap: () => _pickDate(isDob: false),
                  label: 'Expiry Date',
                  value: expiryDate ?? 'Choose date',
                ),
                const VSpace(smallWhiteSpace),
                FreedomButton(
                  onPressed: submitForm,
                  useGradient: true,
                  gradient: redLinearGradient,
                  title: 'Next',
                  buttonTitle: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: paragraphText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
