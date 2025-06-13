import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/authentication/register/register.dart';
import 'package:freedomdriver/feature/documents/driver_license/cubit/license_cubit.dart';
import 'package:freedomdriver/feature/documents/extension.dart';
import 'package:freedomdriver/feature/documents/widget/uploaded_document_image.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:intl/intl.dart';

class DriverLicenseForm extends StatefulWidget {
  const DriverLicenseForm({super.key});
  static const routeName = '/license-form';

  @override
  State<DriverLicenseForm> createState() => _DriverLicenseFormState();
}

class _DriverLicenseFormState extends State<DriverLicenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController classOfLicense = TextEditingController();

  String? dateOfBirth;
  String? issueDate;
  String? expiryDate;

  @override
  void initState() {
    loadLicenseData();
    super.initState();
  }

  void loadLicenseData() {
    final driverLicense = context.driverDocument?.driverLicense;
    licenseNumber.text = driverLicense?.licenseNumber ?? '';
    classOfLicense.text = 'A';
  }

  Future<void> _pickDate({bool? birth, bool? issue, bool? expiry}) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        if (birth != null) dateOfBirth = formattedDate;
        if (issue != null) issueDate = formattedDate;
        if (expiry != null) expiryDate = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Driver License',
      bodyHeader: 'Keep your Driver License details accurate',
      bodyDescription:
          'If you change your Driver License or any relevant details, update the information here to maintain accuracy and transparency.',
      children: [
        UploadedDocumentImage(
          heading: 'Uploaded Driver License',
          documentUrl: context.driverDocument?.driverLicense?.documentUrl,
        ),
        DecoratedContainer(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                buildField('License Number', licenseNumber),
                CustomDropDown(
                  onTap: () => _pickDate(birth: true),
                  label: 'Date of Birth',
                  value: dateOfBirth ?? 'Choose date',
                ),
                buildField('Class of License', classOfLicense),
                CustomDropDown(
                  onTap: () => _pickDate(issue: true),
                  label: 'Issue Date',
                  value: issueDate ?? 'Choose date',
                ),
                CustomDropDown(
                  onTap: () => _pickDate(expiry: true),
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
                      fontWeight: FontWeight.w400,
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

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<DriverLicenseDetailsCubit>().setDriverLicenseDetails(
        licenseNumber: licenseNumber.text.trim(),
        dob: dateOfBirth ?? '',
        licenseClass: classOfLicense.text.trim(),
        issueDate: issueDate ?? '',
        expiryDate: expiryDate ?? '',
      );

      Navigator.pushNamed(
        context,
        BackgroundVerificationScreen.routeName,
        arguments: {'type': driverLicense},
      );
    }
  }
}

Widget buildField(
  String label,
  TextEditingController controller, {
  TextInputType? keyboardType,
  String? placeholder,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool shouldValidate = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label.isNotEmpty)
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: paragraphText,
          ),
        ),
      const VSpace(extraSmallWhiteSpace),
      TextFieldFactory.itemField(
        controller: controller,
        fillColor: Colors.white,
        hintText: placeholder,
        hintTextStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: suffixIcon,
        prefixText: prefixIcon,
        keyboardType: keyboardType,
        enabledBorderColor: Colors.grey.shade300,
        validator:
            !shouldValidate
                ? null
                : (val) {
                  return val == null || val.trim().isEmpty
                      ? '$label is required'
                      : null;
                },
      ),
      const VSpace(smallWhiteSpace),
    ],
  );
}
