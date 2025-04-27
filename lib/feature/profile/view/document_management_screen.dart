import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/documents/driver_document.model.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_cubit.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/feature/profile/view/profile_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:intl/intl.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});
  static const routeName = '/docs_manager';

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  // final vehicleColor = TextEditingController();
  // final vehicleMakeAndModel = TextEditingController();
  // final vehicleLicensePlate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Upload Document'),
            const VSpace(smallWhiteSpace),
            const CustomDivider(height: 6),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isBigMobile(context)
                      ? whiteSpace
                      : smallWhiteSpace,
                ),
                child: Column(
                  children: [
                    const VSpace(smallWhiteSpace),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keep your details accurate',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: normalText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'If you change your Motorcycle or any relevant details, update the information here to maintain accuracy and transparency.',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.439),
                            fontSize: smallText,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const VSpace(whiteSpace),
                        // VehicleInformationContainer(
                        //   vehicleColor: vehicleColor,
                        //   vehicleLicensePlate: vehicleLicensePlate,
                        //   vehicleMakeAndModel: vehicleMakeAndModel,
                        // ),

                        const DriverLicenseForm(),

                        const VSpace(whiteSpace),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverLicenseForm extends StatefulWidget {
  const DriverLicenseForm({
    super.key,
  });

  @override
  State<DriverLicenseForm> createState() => _DriverLicenseFormState();
}

class _DriverLicenseFormState extends State<DriverLicenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController documentType = TextEditingController();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController classOfLicense = TextEditingController();

  String? dateOfBirth;
  String? issueDate;
  String? expiryDate;

  final driverLicense = DriverDocumentType.driverLicense.name;
  List<String> documentTypeDropDownItem = <String>[
    DriverDocumentType.driverLicense.name,
    DriverDocumentType.addressProof.name,
    DriverDocumentType.ghanaCard.name,
    DriverDocumentType.motorcycleImage.name,
    DriverDocumentType.profilePicture.name,
  ];

  String documentTypeDropDownValue = 'driverLicense';

  Widget buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          enabledBorderColor: Colors.black.withValues(alpha: 0.2),
          validator: (val) {
            return val == null || val.trim().isEmpty
                ? '$label is required'
                : null;
          },
        ),
        const VSpace(smallWhiteSpace),
      ],
    );
  }

  Future<void> _pickDate({
    bool? birth,
    bool? issue,
    bool? expiry,
  }) async {
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
    return Container(
      padding: const EdgeInsets.all(smallWhiteSpace),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(119, 119, 119, 0.08),
        borderRadius: BorderRadius.circular(roundedMd),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            CustomDropDown(
              initialValue: documentTypeDropDownValue,
              items: documentTypeDropDownItem,
              onChanged: (value) {
                documentType.text = value;
              },
              label: 'Document Type',
            ),
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
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<DriverLicenseCubit>().setDriverLicenseDetails(
            licenseNumber: licenseNumber.text.trim(),
            dob: dateOfBirth ?? '',
            licenseClass: classOfLicense.text.trim(),
            issueDate: issueDate ?? '',
            expiryDate: expiryDate ?? '',
          );

      Navigator.pushNamed(context, BackgroundVerificationScreen.routeName);
    }
  }
}

class VehicleInformationContainer extends StatefulWidget {
  const VehicleInformationContainer({
    required this.vehicleColor,
    required this.vehicleLicensePlate,
    required this.vehicleMakeAndModel,
    super.key,
  });
  final TextEditingController vehicleColor;
  final TextEditingController vehicleMakeAndModel;
  final TextEditingController vehicleLicensePlate;

  @override
  State<VehicleInformationContainer> createState() =>
      VehicleInformationContainerState();
}

class VehicleInformationContainerState
    extends State<VehicleInformationContainer> {
  List<String> dropDownItem = <String>['Economy', 'FirstClass'];
  String dropDownValue = 'Economy';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: smallWhiteSpace, vertical: 13),
      decoration: ShapeDecoration(
        color: const Color(0x14777777),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Motorcycle Type',
            style: TextStyle(
              color: Colors.black,
              fontSize: 9.44,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VSpace(4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.209),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: dropDownValue,
              alignment: Alignment.bottomLeft,
              dropdownColor: Colors.white,
              padding: const EdgeInsets.only(left: 10, right: 10),
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down_sharp),
              onChanged: (val) {
                setState(() {
                  dropDownValue = val!;
                });
              },
              items: dropDownItem.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const VSpace(9),
          const Text(
            'Motorcycle Color',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.51,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFieldFactory.itemField(
            controller: widget.vehicleColor,
            fillColor: Colors.white,
            enabledBorderColor:
                Colors.black.withValues(alpha: 0.20999999344348907),
          ),
          const VSpace(9),
          const Text(
            'Motorcycle  Make and Model',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.51,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFieldFactory.itemField(
            controller: widget.vehicleMakeAndModel,
            fillColor: Colors.white,
            enabledBorderColor:
                Colors.black.withValues(alpha: 0.20999999344348907),
          ),
          const VSpace(9),
          const Text(
            'License Plate Number',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.51,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFieldFactory.itemField(
            controller: widget.vehicleMakeAndModel,
            fillColor: Colors.white,
            enabledBorderColor:
                Colors.black.withValues(alpha: 0.20999999344348907),
          ),
          const VSpace(9),
          FreedomButton(
            onPressed: () {},
            useGradient: true,
            gradient: redLinearGradient,
            buttonTitle: const Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
