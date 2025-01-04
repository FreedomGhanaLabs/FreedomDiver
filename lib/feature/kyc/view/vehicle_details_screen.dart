import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});
  static const routeName = '/vehicle-details-screen';

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final TextEditingController plateNumberController = TextEditingController();
  String? selectedValue = 'Scooter';
  String? selectedInsurance = 'Inactive';
  final bikeTypeFormKey = GlobalKey<FormState>();
  final insuranceFormKey = GlobalKey<FormState>();
  final registrationFormKey = GlobalKey<FormState>();

  List<String> vehicleType = ['Scooter', 'Bike', 'Car'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const DecoratedBackButton(),
                  const SizedBox(width: 13.91),
                  Text(
                    'Vehicle and Identification Details',
                    style: GoogleFonts.poppins(
                      fontSize: 17.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const VSpace(8.91),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Text(
                'We need a few more details about your vehicle and verification documents.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                ),
              ),
            ),
            const VSpace(27),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bike Type',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VSpace(5),
                  Form(
                    key: bikeTypeFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ReUseAbleDropDown(
                      items: const ['Scooter', 'Bike', 'Car'],
                      selectedValue: selectedValue,
                      hintWidget: Text(
                        'Select Bike Type',
                        style: GoogleFonts.poppins(
                          fontSize: 14.49,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Bike Type is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const VSpace(11),
                  Text(
                    'Registration Number',
                    style: GoogleFonts.poppins(
                      fontSize: 15.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VSpace(12),
                  Form(
                    key: registrationFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFieldFactory.itemField(
                      controller: plateNumberController,
                      fillColor: lightGreyColor,
                      hinText: 'GH-09-4333-90',
                      contentPadding:
                          const EdgeInsets.only(top: 25, bottom: 19, left: 13),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      fieldActiveBorderColor: lightGreyColor,
                      enabledBorderColor: Colors.transparent,
                      focusedBorderColor: Colors.transparent,
                      errorBorderColor: Colors.red,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Registration Number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const VSpace(16),
                  Text(
                    'Insurance Status',
                    style: GoogleFonts.poppins(),
                  ),
                  const VSpace(14),
                  Form(
                    key: insuranceFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ReUseAbleDropDown(
                      items: const ['Active', 'Inactive'],
                      selectedValue: selectedInsurance,
                      hintWidget: Text(
                        'Select Insurance Status',
                        style: GoogleFonts.poppins(
                          fontSize: 14.49,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Insurance Status is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VSpace(40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 21,
              ),
              child: TextButton(
                onPressed: () {
                  if (bikeTypeFormKey.currentState!.validate() &&
                      registrationFormKey.currentState!.validate() &&
                      insuranceFormKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      BackgroundVerificationScreen.routeName,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.92,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReUseAbleDropDown extends StatefulWidget {
  ReUseAbleDropDown({
    required this.items,
    required this.selectedValue,
    this.autovalidateMode,
    this.validator,
    this.hintWidget,
    super.key,
  });

  List<String>? items;
  String? selectedValue;
  AutovalidateMode? autovalidateMode;
  String? Function(String?)? validator;
  final Widget? hintWidget;

  @override
  State<ReUseAbleDropDown> createState() => _ReUseAbleDropDownState();
}

class _ReUseAbleDropDownState extends State<ReUseAbleDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 66,
      decoration: ShapeDecoration(
        color: lightGreyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: DropdownButtonFormField<String>(
        key: widget.key,
        autovalidateMode: widget.autovalidateMode,
        elevation: 0,
        isExpanded: true,
        hint: widget.hintWidget,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black,
        ),
        value: widget.selectedValue,
        items: widget.items?.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.selectedValue = value;
          });
        },
        validator: widget.validator,
      ),
    );
  }
}
