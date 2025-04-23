import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailabilityDashboard extends StatefulWidget {
  const AvailabilityDashboard({super.key});
  static const routeName = '/availability_dashboard';

  @override
  State<AvailabilityDashboard> createState() => _AvailabilityDashboardState();
}

class _AvailabilityDashboardState extends State<AvailabilityDashboard> {
  final vehicleColor = TextEditingController();
  final vehicleMakeAndModel = TextEditingController();
  final vehicleLicensePlate = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                          'Availability Dashboard',
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
                      'Set Your Availability',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.39,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Control when you're ready to drive",
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
  List<String> dropDownItem = <String>['offline', 'online'];
  List<DateTime> dateDropDownItem = <DateTime>[];
  String? dropDownValue;
  DateTime timeDropDownValue = DateTime.now();
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
                  color: Colors.black.withValues(alpha: 0.3799999952316284),
                  fontSize: 10.51,
                  fontFamily: 'Poppins',
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
