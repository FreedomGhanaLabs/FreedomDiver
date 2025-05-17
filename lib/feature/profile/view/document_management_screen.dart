import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/authentication/register/register.dart';
import 'package:freedomdriver/feature/documents/address_proof/view/address_proof_form.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/earnings/widgets/utility.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';


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
    return CustomScreen(
      title: 'Manage Documents',
      bodyHeader: 'Keep your details accurate',
      bodyDescription:
          'If you change your Motorcycle or any relevant details, update the information here to maintain accuracy and transparency.',
      children: [
        ManageDocuments(
          padding: EdgeInsets.zero,
          onLicenseTap: () => Navigator.pushNamed(
            context,
            DriverLicenseForm.routeName,
          ),
          onAddressTap: () => Navigator.pushNamed(
            context,
            AddressProofForm.routeName,
          ),
        ),
        // VehicleInformationContainer(
        //   vehicleColor: vehicleColor,
        //   vehicleLicensePlate: vehicleLicensePlate,
        //   vehicleMakeAndModel: vehicleMakeAndModel,
        // ),

        const VSpace(whiteSpace),
      ],
    );
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
