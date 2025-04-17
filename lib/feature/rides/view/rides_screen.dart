import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedom_driver/feature/rides/enum.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  RideTabEnum rideTabEnum = RideTabEnum.scheduled;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.15;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.white,
      ),
      child: SafeArea(
          child: Material(
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: [
                    const DecoratedBackButton(),
                     HSpace(size),
                    Center(
                      child: Text(
                        'Completed Rides',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(21.91),
              const CustomDivider(),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 396,
                      margin:
                          const EdgeInsets.only(top: 17, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 4),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFCFCFC),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.08,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Color(0xFFF5F5F5),
                          ),
                          borderRadius: BorderRadius.circular(15.50),
                        ),
                      ),
                      child: const RiderTimeLine(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

enum RideTabEnum { scheduled, completed }

class RideTab extends StatelessWidget {
  const RideTab({
    required this.rideTabEnum,
    required this.onPressScheduled,
    required this.onPressCompleted,
    super.key,
  });

  final RideTabEnum rideTabEnum;
  final void Function() onPressScheduled;
  final void Function() onPressCompleted;

  @override
  Widget build(BuildContext context) {
    log('rideTabEnum: $rideTabEnum');
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 4.96, left: 7, right: 7, bottom: 4.96),
          decoration: ShapeDecoration(
            color: const Color(0xFFF3F3F3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onPressScheduled,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                    color: rideTabEnum == RideTabEnum.scheduled
                        ? Colors.black
                        : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        'Scheduled Ride',
                        style: TextStyle(
                          color: rideTabEnum == RideTabEnum.scheduled
                              ? const Color(0xFFF3F3F3)
                              : const Color(0xFFBFBFBF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onPressCompleted,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                    color: rideTabEnum == RideTabEnum.completed
                        ? Colors.black
                        : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        'Completed Ride',
                        style: GoogleFonts.poppins(
                          color: rideTabEnum == RideTabEnum.completed
                              ? const Color(0xFFF3F3F3)
                              : const Color(0xFFBFBFBF),
                          fontSize: 16.33,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 5,
          color: const Color(0x1ED9D9D9),
        ),
        const VSpace(17),
        if (rideTabEnum == RideTabEnum.scheduled) const ScheduledRides(),
        // if (rideTabEnum == RideTabEnum.completed) const CompletedRides(),
      ],
    );
  }
}

class ScheduledRides extends StatefulWidget {
  const ScheduledRides({super.key});

  @override
  State<ScheduledRides> createState() => _ScheduledRidesState();
}

class _ScheduledRidesState extends State<ScheduledRides> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 87,
      color: Colors.red,
    );
  }
}

class CompletedRides extends StatefulWidget {
  const CompletedRides({super.key});

  @override
  State<CompletedRides> createState() => _CompletedRidesState();
}

class _CompletedRidesState extends State<CompletedRides> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CompletedRidesModel {
  CompletedRidesModel(
      {required this.pickUpLocation,
      required this.destination,
      required this.rideType});
  final String pickUpLocation;
  final String destination;
  final RideType rideType;
}
