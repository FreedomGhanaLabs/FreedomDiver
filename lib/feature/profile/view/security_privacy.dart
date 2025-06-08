import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityAndPrivacy extends StatefulWidget {
  const SecurityAndPrivacy({super.key});
  static const routeName = '/security_privacy';

  @override
  State<SecurityAndPrivacy> createState() => _AvailabilityDashboardState();
}

class _AvailabilityDashboardState extends State<SecurityAndPrivacy> {
  final vehicleColor = TextEditingController();
  final vehicleMakeAndModel = TextEditingController();
  final vehicleLicensePlate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Availability Dashboard',
      bodyHeader: 'Set Your Availability',
      bodyDescription: "Control when you're ready to drive",
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpace(whiteSpace),
            _VehicleInformationContainer(
              vehicleColor: vehicleColor,
              vehicleLicensePlate: vehicleLicensePlate,
              vehicleMakeAndModel: vehicleMakeAndModel,
            ),
          ],
        ),
      ],
    );
  }
}

class _VehicleInformationContainer extends StatefulWidget {
  const _VehicleInformationContainer({
    required this.vehicleColor,
    required this.vehicleLicensePlate,
    required this.vehicleMakeAndModel,
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
  List<String> dropDownItem = <String>['available', 'unavailable'];
  List<DateTime> dateDropDownItem = <DateTime>[];
  String? dropDownValue;
  DateTime timeDropDownValue = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Display',
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
              hint: Text(
                'Offline',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.38),
                  fontSize: 10.51,
                  fontWeight: FontWeight.w400,
                ),
              ),
              dropdownColor: Colors.white,
              padding: const EdgeInsets.only(left: 10, right: 10),
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down_sharp),
              onChanged: (val) {
                setState(() {
                  dropDownValue = val;
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
          const VSpace(15),
          Text(
            'Set Start Time',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 9.44,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.209),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TimeDropdown(
              onTimeSelected: (val) {},
              hintText: Text(
                '6:00 AM',
                style: GoogleFonts.poppins(
                  color: Colors.black.withValues(alpha: 0.379),
                  fontSize: 10.51,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const VSpace(15),
          Text(
            'Set End Time',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 9.44,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.209),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TimeDropdown(
              onTimeSelected: (val) {},
              hintText: Text(
                '6:00 PM',
                style: GoogleFonts.poppins(
                  color: Colors.black.withValues(alpha: 0.379),
                  fontSize: 10.51,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const VSpace(15),
          FreedomButton(
            onPressed: () {},
            useGradient: true,
            gradient: redLinearGradient,
            buttonTitle: Text(
              'Update Status',
              style: GoogleFonts.poppins(
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

class TimeDropdown extends StatefulWidget {
  const TimeDropdown({
    required this.onTimeSelected,
    required this.hintText,
    super.key,
  });
  final void Function(String) onTimeSelected;
  final Widget hintText;

  @override
  TimeDropdownState createState() => TimeDropdownState();
}

class TimeDropdownState extends State<TimeDropdown> {
  String? selectedTime;

  List<String> generateTimeSlots() {
    final timeSlots = <String>[];
    for (var hour = 0; hour < 24; hour++) {
      for (var minute = 0; minute < 60; minute += 30) {
        final formattedHour = hour.toString().padLeft(2, '0');
        final formattedMinute = minute.toString().padLeft(2, '0');
        timeSlots.add('$formattedHour:$formattedMinute');
      }
    }
    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = generateTimeSlots();
    return DropdownButton<String>(
      hint: widget.hintText,
      value: selectedTime,
      isExpanded: true,
      padding: const EdgeInsets.only(left: 10, right: 10),
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      onChanged: (String? newValue) {
        setState(() {
          selectedTime = newValue;
        });
        if (newValue != null) {
          widget.onTimeSelected(newValue);
        }
      },
      items: timeSlots.map((String time) {
        return DropdownMenuItem<String>(
          value: time,
          child: Text(time),
        );
      }).toList(),
    );
  }
}
