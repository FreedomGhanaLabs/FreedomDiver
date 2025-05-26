import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_background_widget.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';
import 'package:freedomdriver/feature/home/view/widgets/build_diaglog.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_earnings.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_order.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_score.dart';
import 'package:freedomdriver/feature/home/view/widgets/estimated_reach_time.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';

import '../../../shared/api/load_dashboard.dart';
import '../../../shared/api/load_document_histories.dart';
import '../../../utilities/driver_location_service.dart';
import '../../main_activity/cubit/main_activity_cubit.dart';

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DriverLocationService().requestPermission();
      loadDocumentHistories(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: gradient1,
        onRefresh: () async {
          await Future.wait([
            loadDashboard(context),
            loadDocumentHistories(context),
          ]);
        },
        child: Stack(
          children: [
            const EarningsBackgroundWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
              child: Column(
                children: [
                  VSpace(
                    MediaQuery.of(context).padding.top + extraSmallWhiteSpace,
                  ),
                  const HomeHeader(),
                  const VSpace(smallWhiteSpace),
                  const DriverStatusToggler(),
                  const VSpace(smallWhiteSpace),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: const [
                        HomeEarnings(),
                        VSpace(smallWhiteSpace),
                        HomeRide(),
                        VSpace(smallWhiteSpace),
                        Column(
                          children: [
                            HomeActivity(),
                            VSpace(smallWhiteSpace),
                            RiderTimeLine(
                              activityType: ActivityType.delivery,
                              destinationDetails: 'Ghana,Kumasi',
                              pickUpDetails: 'Chale, Kumasi',
                            ),
                          ],
                        ),
                        VSpace(whiteSpace),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
      child: Row(
        children: [
          const Text(
            'Your Activity',
            style: TextStyle(
              fontSize: paragraphText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => context.read<MainActivityCubit>().changeIndex(2),
            child: const Text(
              'See All',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF59E0B),
                fontSize: smallText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const AppIcon(iconName: 'right-arrow', size: smallText),
        ],
      ),
    );
  }
}

class HomeRide extends StatelessWidget {
  const HomeRide({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
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
                color: Colors.black.withValues(alpha: 0.0500),
              ),
              borderRadius: BorderRadius.circular(4.95),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: smallText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const VSpace(extraSmallWhiteSpace),
              Image.asset('assets/app_images/driver_image.png'),
              const VSpace(smallWhiteSpace),
              if (state.rideStatus == RideStatus.searching)
                Text(
                  'Searching for ride requests near you…',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: smallText,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else if (state.rideStatus == RideStatus.accepted)
                const EstimatedReachTime(),
              const VSpace(smallWhiteSpace),
              Row(
                children: [
                  Expanded(
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener<HomeCubit, HomeState>(
                          listener: (context, state) {
                            if (state.rideStatus == RideStatus.found) {
                              buildRideFoundDialog(context);
                            }
                          },
                        ),
                      ],
                      child: BlocBuilder<HomeCubit, HomeState>(
                        key: ValueKey(state.rideStatus),
                        builder: (context, state) {
                          log('Current state 2: ${state.rideStatus}');

                          final isRideActive =
                              state.rideStatus == RideStatus.accepted;
                          return SimpleButton(
                            title:
                                isRideActive ? 'End Ride' : 'Find Nearby Rides',
                            onPressed: () {
                              if (isRideActive == true) {
                                context.read<HomeCubit>().endRide();
                              } else {
                                context.read<HomeCubit>().toggleNearByRides();
                              }
                            },
                            backgroundColor:
                                isRideActive ? redColor : greenColor,
                            padding: const EdgeInsets.only(
                              top: 6.93,
                              bottom: 6.93,
                              left: 22,
                              right: 22,
                            ),
                            borderRadius: BorderRadius.circular(4.95),
                            textStyle: TextStyle(
                              fontSize: paragraphText.sp,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const HSpace(whiteSpace),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return Expanded(
                        child: SimpleButton(
                          title:
                              state.rideStatus == RideStatus.accepted
                                  ? 'Navigate'
                                  : 'Search Another Area',
                          onPressed: () {
                            if (state.rideStatus == RideStatus.accepted) {
                              Navigator.of(
                                context,
                              ).pushNamed(InAppCallMap.routeName);
                            }
                          },
                          backgroundColor: greyColor,
                          padding: const EdgeInsets.only(
                            top: 6.93,
                            bottom: 6.93,
                            left: 22,
                            right: 22,
                          ),
                          borderRadius: BorderRadius.circular(4.95),
                          textStyle: TextStyle(
                            fontSize: paragraphText.sp,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeEarnings extends StatelessWidget {
  const HomeEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
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
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final driver = state is DriverLoaded ? state.driver : null;
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' Current Location',
                  style: TextStyle(
                    fontSize: extraSmallText.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.29,
                    letterSpacing: -0.31.sp,
                  ),
                ),
                Row(
                  children: [
                    const AppIcon(iconName: 'location_icon'),
                    const HSpace(1),
                    Text(
                      driver != null
                          ? '${driver.address.country}, ${driver.address.state} '
                          : 'Your address',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: smallText.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.29,
                        letterSpacing: -0.31.sp,
                      ),
                    ),
                    const HSpace(1),
                    // const AppIcon(iconName: 'down_arrow'),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Ride preference',
                  style: TextStyle(
                    fontSize: extraSmallText.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.29,
                    letterSpacing: -0.31.sp,
                  ),
                ),
                InkWell(
                  onTap:
                      driver == null
                          ? null
                          : () {
                            final driverCubit = context.read<DriverCubit>();
                            showCupertinoModalPopup(
                              useRootNavigator: false,
                              context: context,
                              builder:
                                  (context) => CupertinoActionSheet(
                                    title: Text(
                                      'Select Ride Preference - Ride, Deliver, or Both',
                                      style: normalTextStyle,
                                    ),
                                    message: Text(
                                      'Choose your service type: offer rides, make deliveries, or do both. Customize your experience to match your goals.',
                                      style: paragraphTextStyle,
                                    ),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          'Rides only',
                                          style: TextStyle(color: gradient1),
                                        ),
                                        onPressed: () async {
                                          await driverCubit
                                              .updateDriverRidePreference(
                                                context,
                                                newRidePreference: 'normal',
                                              );

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          'Deliveries only',
                                          style: TextStyle(color: gradient1),
                                        ),
                                        onPressed: () async {
                                          await driverCubit
                                              .updateDriverRidePreference(
                                                context,
                                                newRidePreference: 'delivery',
                                              );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          'Rides and Deliveries ',
                                          style: TextStyle(color: gradient1),
                                        ),
                                        onPressed: () async {
                                          await driverCubit
                                              .updateDriverRidePreference(
                                                context,
                                              );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        child: const Text('Close'),
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                            );
                          },
                  child: Row(
                    children: [
                      Text(
                        (driver?.ridePreference ?? 'select preference')
                                .capitalize ??
                            '',
                        style: const TextStyle(
                          fontSize: smallText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const HSpace(3),
                      const AppIcon(iconName: 'down_arrow'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
                    borderRadius: BorderRadius.circular(roundedMd),
                    color: activeColor.withValues(alpha: 0.05),
                    border: Border.fromBorderSide(
                      BorderSide(color: activeColor, width: 1.25),
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

        return const SizedBox();
      },
    );
  }
}
