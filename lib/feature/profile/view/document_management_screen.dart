import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});
  static const routeName = '/docs_manager';

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  final vehicleColor = TextEditingController();
  final vehicleMakeAndModel = TextEditingController();
  final vehicleLicensePlate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.35;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const DecoratedBackButton(),
                    // HSpace(size),
                    Expanded(
                      child: Center(
                        child: Text(
                          ' Update Vehicle Information',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16.39,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(14),
              const CustomDivider(
                height: 8,
              ),
              const VSpace(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keep your Motorcycle details accurate',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.39,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'If you change your Motorcycle or any relevant details, update the information here to maintain accuracy and transparency.',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withValues(alpha: 0.439),
                        fontSize: 10.19,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const VSpace(26),
                    _VehicleInformationContainer(
                      vehicleColor: vehicleColor,
                      vehicleLicensePlate: vehicleLicensePlate,
                      vehicleMakeAndModel: vehicleMakeAndModel,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleInformationContainer extends StatefulWidget {
  const _VehicleInformationContainer({
    required this.vehicleColor,
    required this.vehicleLicensePlate,
    required this.vehicleMakeAndModel,
    super.key,
  });
  final TextEditingController vehicleColor;
  final TextEditingController vehicleMakeAndModel;
  final TextEditingController vehicleLicensePlate;

  @override
  State<_VehicleInformationContainer> createState() =>
      _VehicleInformationContainerState();
}

class _VehicleInformationContainerState
    extends State<_VehicleInformationContainer> {
  List<String> dropDownItem = <String>['Economy', 'FirstClass'];
  String dropDownValue = 'Economy';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: ShapeDecoration(
        color: const Color(0x14777777),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Motorcycle Type',
            style: GoogleFonts.poppins(
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
                items:
                    dropDownItem.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
              }).toList(),
            ),
          ),
          const VSpace(9),
          Text(
            'Motorcycle Color',
            style: GoogleFonts.poppins(
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
          Text(
            'Motorcycle  Make and Model',
            style: GoogleFonts.poppins(
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
          Text(
            'License Plate Number',
            style: GoogleFonts.poppins(
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
            buttonTitle: Text('Update', style: GoogleFonts.poppins(
               color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),),
          ),
        ],
      ),
    );
  }
}
