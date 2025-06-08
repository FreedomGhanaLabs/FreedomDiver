import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_type.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_state.dart';
import 'package:freedomdriver/feature/rides/models/ride_history.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  RideTabEnum rideTabEnum = RideTabEnum.scheduled;

  @override
  void initState() {
    setState(() {
      context.read<RideHistoryCubit>().getAllRideHistories(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        return CustomScreen(
          title: 'Ride History',
          onRefresh:
              () =>
                  context.read<RideHistoryCubit>().refreshRideHistory(context),
          hasBackButton: false,
          differentUi: Expanded(
            child:
                state is RideHistoryError
                    ? SizedBox(
                      height: Responsive.height(context) * 0.75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ride History',
                            style: normalTextStyle.copyWith(color: redColor),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            state.message,
                            style: descriptionTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : state is RideHistoryLoaded
                    ? (state.ride.count <= 0
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppIcon(iconName: 'no_ride_history'),
                            const VSpace(extraSmallWhiteSpace),
                            Text(
                              'You have no scheduled Ride ',
                              textAlign: TextAlign.center,
                              style: headingTextStyle,
                            ),
                          ],
                        )
                        : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                Responsive.isTablet(context)
                                    ? whiteSpace
                                    : smallWhiteSpace,
                            vertical: smallWhiteSpace,
                          ),
                          itemCount: state.ride.count,
                          itemBuilder: (context, index) {
                            return RidesTile(ride: state.ride.data[index]);
                          },
                        ))
                    : SizedBox(),
          ),
        );
      },
    );
  }
}

class RidesTile extends StatelessWidget {
  const RidesTile({super.key, required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: smallWhiteSpace),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFFF5F5F5),
          ),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: RiderTimeLine(
        destinationDetails: ride.dropoffLocation.address,
        pickUpDetails: ride.pickupLocation.address,
        riderId: ride.id,
        currency: ride.currency,
        fare: ride.totalFare,
        status: ride.status,
      ),
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
          padding: const EdgeInsets.only(
            top: 4.96,
            left: 7,
            right: 7,
            bottom: 4.96,
          ),
          decoration: ShapeDecoration(
            color: const Color(0xFFF3F3F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onPressScheduled,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        rideTabEnum == RideTabEnum.scheduled
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
                          color:
                              rideTabEnum == RideTabEnum.scheduled
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        rideTabEnum == RideTabEnum.completed
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
                          color:
                              rideTabEnum == RideTabEnum.completed
                                  ? const Color(0xFFF3F3F3)
                                  : const Color(0xFFBFBFBF),
                          fontSize: 16.33,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
    return Container(height: 20, width: 87, color: Colors.red);
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
  CompletedRidesModel({
    required this.pickUpLocation,
    required this.destination,
    required this.rideType,
  });
  final String pickUpLocation;
  final String destination;
  final RideType rideType;
}
