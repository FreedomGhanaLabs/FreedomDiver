import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/di/locator.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_background_widget.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_earnings.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_order.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_score.dart';
import 'package:freedomdriver/feature/home/view/widgets/estimated_reach_time.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/show_custom_modal.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/ride.dart';
import '../../../shared/api/load_dashboard.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../documents/driver_license/view/license_form.dart';
import '../../main_activity/cubit/main_activity_cubit.dart';
import '../../rides/cubit/ride/ride_state.dart';

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
    getIt<DriverLocationService>().sendCurrentLocationOnce(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: thickFillColor,
        onRefresh: () async {
          await loadDashboard(context);
        },
        child: Stack(
          children: [
            const EarningsBackgroundWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
              child: Column(
                children: [
                  VSpace(Responsive.top(context) + extraSmallWhiteSpace),
                  const HomeHeader(),
                  const VSpace(smallWhiteSpace),
                  const DriverStatusToggler(),
                  const VSpace(smallWhiteSpace),
                  const HomeContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        final rideHistory = state is RideHistoryLoaded ? state.ride : null;
        final firstRide = rideHistory?.data[0];

        if (firstRide == null) {
          return SizedBox();
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              HomeEarnings(),
              VSpace(smallWhiteSpace),
              HomeRide(),
              VSpace(smallWhiteSpace),
              Column(
                children: [
                  HomeActivity(),
                  VSpace(smallWhiteSpace),
                  RiderTimeLine(
                    // activityType: ActivityType.delivery,
                    currency: firstRide.currency,
                    fare: firstRide.totalFare,
                    status: firstRide.status,
                    riderId: firstRide.id,
                    destinationDetails: firstRide.dropoffLocation.address,
                    pickUpDetails: firstRide.pickupLocation.address,
                  ),
                ],
              ),
              VSpace(whiteSpace),
            ],
          ),
        );
      },
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

class HomeRide extends StatefulWidget {
  const HomeRide({super.key});

  @override
  State<HomeRide> createState() => _HomeRideState();
}

class _HomeRideState extends State<HomeRide> {
  int userRating = 0;
  bool showCommentField = false;

  final TextEditingController reasonController = TextEditingController(
    text: "Too far from my current location",
  );
  final TextEditingController commentController = TextEditingController(
    text: "He's a very nice and punctual person",
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isRideActive = state.rideStatus == TransitStatus.accepted;
        final isRideCompleted = state.rideStatus == TransitStatus.completed;
        return BlocBuilder<RideCubit, RideState>(
          builder: (context, rideState) {
            final rideDetails = rideState is RideLoaded ? rideState.ride : null;
            final isRideAcceptedStatus = rideDetails?.status == acceptedRide;
            final isRideArrivedStatus = rideDetails?.status == arrivedRide;
            final isRideStartedStatus = rideDetails?.status == inProgressRide;
            final isRideCompletedStatus = rideDetails?.status == completedRide;
            final checkIfCashRide =
                rideDetails?.paymentMethod == "cash" &&
                rideDetails?.paymentStatus == "pending";
            return Container(
              padding: const EdgeInsets.all(medWhiteSpace),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.99,
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  borderRadius: BorderRadius.circular(roundedLg),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find ride',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: smallText,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const VSpace(extraSmallWhiteSpace),
                  GoogleMapView(),
                  const VSpace(smallWhiteSpace),
                  if (state.rideStatus == TransitStatus.searching)
                    Text(
                      'Searching for ride requests near you…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: smallText,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (state.rideStatus == TransitStatus.accepted &&
                      !isRideCompletedStatus &&
                      !isRideArrivedStatus)
                    const EstimatedReachTime(),
                  const VSpace(smallWhiteSpace),
                  if (isRideCompletedStatus && !checkIfCashRide)
                    Column(
                      children: [
                        const Text(
                          "How will you rate this ride? Tap to rate User",
                          style: TextStyle(fontSize: normalText),
                        ),
                        const VSpace(extraSmallWhiteSpace),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StarRating(
                              rating: userRating,
                              onRatingChanged: (rating) {
                                setState(() {
                                  userRating = rating;
                                  if (!showCommentField) {
                                    showCommentField = true;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const VSpace(extraSmallWhiteSpace),
                        if (showCommentField)
                          buildField(
                            "Say something about the user",
                            commentController,
                          ),
                      ],
                    ),
                  if (isRideActive || isRideCompleted)
                    Row(
                      children: [
                        Expanded(
                          child: SimpleButton(
                            title:
                                isRideAcceptedStatus
                                    ? "Arrived At Pickup"
                                    : isRideArrivedStatus
                                    ? 'Start Ride'
                                    : isRideStartedStatus
                                    ? 'Complete Ride'
                                    : checkIfCashRide
                                    ? "Confirm Cash Payment"
                                    : "Rate User",
                            onPressed: () {
                              if (isRideAcceptedStatus) {
                                context.read<RideCubit>().arrivedRide(context);
                              } else if (isRideArrivedStatus) {
                                context.read<RideCubit>().startRide(context);
                              } else if (isRideStartedStatus) {
                                context.read<RideCubit>().completeRide(context);
                              } else if (checkIfCashRide) {
                                context.read<RideCubit>().confirmCashPayment(
                                  context,
                                );
                              } else {
                                context.read<RideCubit>().rateRideUser(
                                  context,
                                  rating: userRating,
                                  comment: commentController.text,
                                );
                              }
                            },
                            backgroundColor:
                                isRideAcceptedStatus || isRideCompletedStatus
                                    ? thickFillColor
                                    : isRideStartedStatus
                                    ? Colors.black
                                    : greenColor,
                          ),
                        ),
                      ],
                    ),
                  if (!isRideCompletedStatus)
                    Row(
                      children: [
                        Expanded(
                          child: SimpleButton(
                            title:
                                isRideActive
                                    ? 'Cancel Ride'
                                    : 'Find Nearby Rides',
                            onPressed: () {
                              if (isRideActive) {
                                showCustomModal(
                                  context,
                                  btnCancelText: "Back",
                                  btnOkText: "Cancel Ride",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress:
                                      () =>
                                          context.read<RideCubit>().cancelRide(
                                            context,
                                            reason:
                                                reasonController.text.trim(),
                                          ),
                                  child: buildField(
                                    "Say reasons for canceling ride",
                                    reasonController,
                                  ),
                                ).show();
                              } else {
                                context.read<HomeCubit>().toggleNearByRides();
                              }
                            },
                            backgroundColor:
                                isRideActive ? redColor : thickFillColor,
                          ),
                        ),
                        const HSpace(extraSmallWhiteSpace),
                        Expanded(
                          child: SimpleButton(
                            title:
                                state.rideStatus == TransitStatus.accepted
                                    ? 'Navigate'
                                    : 'Search Another Area',
                            onPressed: () {
                              if (state.rideStatus == TransitStatus.accepted) {
                                Navigator.of(
                                  context,
                                ).pushNamed(InAppCallMap.routeName);
                              }
                            },
                            backgroundColor: greyColor,
                            textStyle: paragraphTextStyle.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundedLg),
      child: SizedBox(
        height: 100,
        width: Responsive.width(context),
        child: GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: context.driverLatLng!,
            zoom: 16.5,
          ),
        ),
      ),
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
                  ' Current Address',
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
                    const HSpace(2),
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
                                          style: TextStyle(
                                            color: thickFillColor,
                                          ),
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
                                          style: TextStyle(
                                            color: thickFillColor,
                                          ),
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
                                          style: TextStyle(
                                            color: thickFillColor,
                                          ),
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
                        (driver?.ridePreference
                                        .replaceFirst('both', 'Ride, delivery')
                                        .replaceFirst('normal', 'ride') ??
                                    'select preference')
                                .capitalize ??
                            '',
                        style: TextStyle(
                          fontSize: smallText.sp,
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
        if (state is DriverLoaded) {
          final driver = state.driver;

          final unavailable = DriverStatus.unavailable.name;

          final isUnavailable = driver.status == unavailable;

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
