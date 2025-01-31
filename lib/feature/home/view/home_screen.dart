import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:freedom_driver/shared/theme/app_colors.dart';
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
    Navigator.of(context).pushNamed('/inAppCallAndMap');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: [
                const EarningsBackgroundWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Location',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.96.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.29,
                                  letterSpacing: -0.31.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/app_icons/location_icon.svg',
                                  ),
                                  const HSpace(1),
                                  Text(
                                    'Ghana,Kumasi',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.96.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.29,
                                      letterSpacing: -0.31.sp,
                                    ),
                                  ),
                                  const HSpace(1),
                                  SvgPicture.asset(
                                    'assets/app_icons/down_arrow.svg',
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Logistic',
                            style: GoogleFonts.poppins(
                              fontSize: 12.96,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const HSpace(1),
                          SvgPicture.asset(
                            'assets/app_icons/down_arrow.svg',
                          ),
                        ],
                      ),
                      VSpace(19.h),
                      const DriverStatusToggler(),
                      VSpace(19.h),
                      const Row(
                        children: [
                          Expanded(child: DriverTotalEarnings()),
                          HSpace(15),
                          Expanded(
                            child: Column(
                              children: [
                                DriverTotalScore(),
                                VSpace(7),
                                DriverTotalOrder(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      VSpace(16.25.h),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 7.9, right: 14, bottom: 12.75),

                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.99,
                              color: Colors.black.withValues(alpha:  0.0500),
                            ),
                            borderRadius: BorderRadius.circular(4.95),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find ride',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12.8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const VSpace(4),
                            const Image(
                              image: AssetImage(
                                  'assets/app_images/driver_image.png'),
                            ),
                            const VSpace(16),
                            if (state.rideStatus == RideStatus.searching)
                              Text(
                                'Searching for ride requests near you…',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFA6A6A6),
                                  fontSize: 8.39,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else if (state.rideStatus == RideStatus.accepted)
                              const EstimatedReachTime(),
                            const VSpace(16),
                            Row(
                              children: [
                                Expanded(
                                  child: MultiBlocListener(
                                    listeners: [
                                      BlocListener<HomeCubit, HomeState>(
                                        listener: (context, state) {
                                          if (state.rideStatus ==
                                              RideStatus.found) {
                                            buildRideFoundDialog(context);
                                          }
                                        },
                                      ),
                                    ],
                                    child: BlocBuilder<HomeCubit, HomeState>(
                                      key: ValueKey(state.rideStatus),
                                      builder: (context, state) {
                                        log('Current state 2: ${state.rideStatus}');

                                        final isRideActive = state.rideStatus ==
                                            RideStatus.accepted;
                                        return SimpleButton(
                                          title: isRideActive
                                              ? 'End Ride'
                                              : 'Find Nearby Rides',
                                          onPressed: () {
                                            if (isRideActive == true) {
                                              context
                                                  .read<HomeCubit>()
                                                  .endRide();
                                            } else {
                                              context
                                                  .read<HomeCubit>()
                                                  .toggleNearByRides();
                                            }
                                          },
                                          backgroundColor: isRideActive
                                              ? Colors.red
                                              : const Color(0xff29CC6A),
                                          padding: const EdgeInsets.only(
                                            top: 6.93,
                                            bottom: 6.93,
                                            left: 22,
                                            right: 22,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.95),
                                          textStyle: GoogleFonts.poppins(
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
                                            Navigator.of(context).pushNamed(
                                                InAppCallMap.routeName);
                                          }
                                        },
                                        backgroundColor:
                                            const Color(0xEDABABB1),
                                        padding: const EdgeInsets.only(
                                          top: 6.93,
                                          bottom: 6.93,
                                          left: 22,
                                          right: 22,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.95),
                                        textStyle: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const VSpace(10.69),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          children: [
                            Text(
                              'Your Activity',
                              style: GoogleFonts.poppins(
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
                                child: SvgPicture.asset(
                                    'assets/app_icons/right-arrow.svg')),
                          ],
                        ),
                      ),
                      const Column(
                        children: [
                          VSpace(15),
                          RiderTimeLine(
                            activityType: ActivityType.delivery,
                            destinationDetails: 'Ghana,Kumasi',
                            pickUpDetails: 'Chale, Kumasi',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DriverStatusToggler extends StatelessWidget {
  const DriverStatusToggler({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.78),
              color: Colors.red.withOpacity(0.1),
              border: const Border.fromBorderSide(
                BorderSide(
                  color: Colors.red,
                  width: 1.56,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Go Offline',
                    style: GoogleFonts.poppins(
                      color: darkRed,
                      fontSize: 16.25,
                      fontWeight: FontWeight.w600,
                    )),
                const HSpace(10),
                SvgPicture.asset(
                  'assets/app_icons/offline_icon.svg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
