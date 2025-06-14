import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/documents/extension.dart';
import 'package:freedomdriver/feature/documents/ghana_card/cubit/ghana_card_cubit.dart';
import 'package:freedomdriver/feature/documents/ghana_card/ghana_card.model.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:intl/intl.dart';

import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/documents/widget/uploaded_document_image.dart';

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
  String sex = 'Male';

  @override
  void initState() {
    loadCardDetails();
    super.initState();
  }

  void loadCardDetails() {
    final driver = context.driver;
    surname.text = driver!.surname;
    firstName.text = driver.firstName;
    otherName.text = driver.otherName;
  }

  @override
  void dispose() {
    personalIdNumber.dispose();
    surname.dispose();
    firstName.dispose();
    otherName.dispose();
    height.dispose();

    super.dispose();
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
          sex: sex == 'Male' ? 'M' : 'F',
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
    final documentUrl =
        context.driverDocument?.ghanaCardHistory?.current.documentUrl;
    return CustomScreen(
      title: 'Ghana Card',
      bodyHeader: 'Enter your Ghana Card details',
      bodyDescription:
          'Ensure all fields are filled correctly to verify your identity.',
      children: [
        UploadedDocumentImage(
          heading: 'Uploaded Card',
          documentUrl: documentUrl,
        ),
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
                  items: const ['Male', 'Female'],
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
                  title: documentUrl != null ? 'Update Card' : 'Next',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
