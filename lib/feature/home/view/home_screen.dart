import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';
import 'package:freedom_driver/feature/earnings/widgets/earnings_background_widget.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/feature/home/view/inappcall_map.dart';
import 'package:freedom_driver/feature/home/view/widgets/build_diaglog.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_earnings.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_order.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_score.dart';
import 'package:freedom_driver/feature/home/view/widgets/estimated_reach_time.dart';
import 'package:freedom_driver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return _HomeScreen();
  }
}

class _HomeScreen extends StatefulWidget {
  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  void navigateToInAppCallAndMap() {
    Navigator.of(context).pushNamed(InAppCallMap.routeName);
  }

  String location = '';
  String status = '';

  void _setDriverFields(DriverState state) {
    if (state is DriverLoaded) {
      final driver = state.driver;
      location =
          '${driver.address.country}, ${driver.address.state.replaceAll('State', '')}';
      status = driver.status ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DriverCubit, DriverState>(
        builder: (context, driverState) {
          _setDriverFields(driverState);
          return Scaffold(
            backgroundColor: Colors.white,
            body: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Stack(
                  children: [
                    const EarningsBackgroundWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: smallWhiteSpace,
                        vertical: extraSmallWhiteSpace,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Location',
                                    style: TextStyle(
                                      fontSize: smallText.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.29,
                                      letterSpacing: -0.31.sp,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const AppIcon(iconName: 'location_icon'),
                                      const HSpace(1),
                                      Text(
                                        location,
                                        style: TextStyle(
                                          fontSize: smallText,
                                          fontWeight: FontWeight.w600,
                                          height: 1.29,
                                          letterSpacing: -0.31.sp,
                                        ),
                                      ),
                                      const HSpace(1),
                                      const AppIcon(iconName: 'down_arrow'),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Text(
                                'Logistic',
                                style: TextStyle(
                                  fontSize: smallText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const HSpace(1),
                              const AppIcon(iconName: 'down_arrow'),
                            ],
                          ),
                          const VSpace(smallWhiteSpace),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const DriverStatusToggler(),
                                  const VSpace(smallWhiteSpace),
                                  const Row(
                                    children: [
                                      Expanded(child: DriverTotalEarnings()),
                                      HSpace(smallWhiteSpace),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            DriverTotalScore(),
                                            VSpace(extraSmallWhiteSpace),
                                            DriverTotalOrder(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VSpace(smallWhiteSpace),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: smallWhiteSpace,
                                      top: 7.9,
                                      right: 14,
                                      bottom: 12.75,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 0.99,
                                          color: Colors.black
                                              .withValues(alpha: 0.0500),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.95),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Find ride',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: smallText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const VSpace(4),
                                        const Image(
                                          image: AssetImage(
                                            'assets/app_images/driver_image.png',
                                          ),
                                        ),
                                        const VSpace(16),
                                        if (state.rideStatus ==
                                            RideStatus.searching)
                                          Text(
                                            'Searching for ride requests near you…',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: smallText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        else if (state.rideStatus ==
                                            RideStatus.accepted)
                                          const EstimatedReachTime(),
                                        const VSpace(16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MultiBlocListener(
                                                listeners: [
                                                  BlocListener<HomeCubit,
                                                      HomeState>(
                                                    listener: (context, state) {
                                                      if (state.rideStatus ==
                                                          RideStatus.found) {
                                                        buildRideFoundDialog(
                                                          context,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                                child: BlocBuilder<HomeCubit,
                                                    HomeState>(
                                                  key: ValueKey(
                                                    state.rideStatus,
                                                  ),
                                                  builder: (context, state) {
                                                    log('Current state 2: ${state.rideStatus}');

                                                    final isRideActive =
                                                        state.rideStatus ==
                                                            RideStatus.accepted;
                                                    return SimpleButton(
                                                      title: isRideActive
                                                          ? 'End Ride'
                                                          : 'Find Nearby Rides',
                                                      onPressed: () {
                                                        if (isRideActive ==
                                                            true) {
                                                          context
                                                              .read<HomeCubit>()
                                                              .endRide();
                                                        } else {
                                                          context
                                                              .read<HomeCubit>()
                                                              .toggleNearByRides();
                                                        }
                                                      },
                                                      backgroundColor:
                                                          isRideActive
                                                              ? Colors.red
                                                              : const Color(
                                                                  0xff29CC6A,
                                                                ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 6.93,
                                                        bottom: 6.93,
                                                        left: 22,
                                                        right: 22,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        4.95,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const HSpace(28),
                                            BlocBuilder<HomeCubit, HomeState>(
                                              builder: (context, state) {
                                                return Expanded(
                                                  child: SimpleButton(
                                                    title: state.rideStatus ==
                                                            RideStatus.accepted
                                                        ? 'Navigate'
                                                        : 'Search Another Area',
                                                    onPressed: () {
                                                      if (state.rideStatus ==
                                                          RideStatus.accepted) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                          InAppCallMap
                                                              .routeName,
                                                        );
                                                      }
                                                    },
                                                    backgroundColor:
                                                        const Color(
                                                      0xEDABABB1,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 6.93,
                                                      bottom: 6.93,
                                                      left: 22,
                                                      right: 22,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      4.95,
                                                    ),
                                                    textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VSpace(10.69),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Your Activity',
                                          style: TextStyle(
                                            fontSize: 14.53,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'See All',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFFF59E0B),
                                            fontSize: 14.53,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        GestureDetector(
                                          child: const AppIcon(
                                            iconName: 'right-arrow',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Column(
                                    children: [
                                      VSpace(smallWhiteSpace),
                                      RiderTimeLine(
                                        activityType: ActivityType.delivery,
                                        destinationDetails: 'Ghana,Kumasi',
                                        pickUpDetails: 'Chale, Kumasi',
                                      ),
                                    ],
                                  ),
                                  const VSpace(whiteSpace),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DriverStatusToggler extends StatelessWidget {
  const DriverStatusToggler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        // Ensure you're working with the loaded state
        if (state is DriverLoaded) {
          final driver = state.driver;

          // final available = DriverStatus.available.name;
          final unavailable = DriverStatus.unavailable.name;

          final isUnavailable = driver.status == unavailable;
          // final isAvailable = driver.status == available;

          final Color activeColor = isUnavailable ? Colors.green : Colors.red;

          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: GestureDetector(
                onTap: () {
                  context.read<DriverCubit>().toggleStatus(context);
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.78),
                    color: activeColor.withValues(alpha: 0.05),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: activeColor,
                        width: 1.25,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isUnavailable ? 'Go Online' : 'Go Offline',
                        style: TextStyle(
                          color: activeColor,
                          fontSize: paragraphText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        isUnavailable
                            ? Icons.online_prediction
                            : Icons.offline_bolt,
                        color: activeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // if (state is DriverLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return const SizedBox();
      },
    );
  }
}
