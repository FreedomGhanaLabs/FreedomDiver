import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/constants/ride.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_background_widget.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';
import 'package:freedomdriver/feature/home/view/utilities/create_custom_marker.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_earnings.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_order.dart';
import 'package:freedomdriver/feature/home/view/widgets/driver_total_score.dart';
import 'package:freedomdriver/feature/home/view/widgets/estimated_reach_time.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/main_activity/cubit/main_activity_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_state.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride_history/ride_history_state.dart';
import 'package:freedomdriver/shared/api/load_dashboard.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/star_rating.dart';
import 'package:freedomdriver/utilities/format_number_with_prefix.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/show_custom_modal.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    super.initState();
    loadDashboard(context);
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
                mainAxisSize: MainAxisSize.min,
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

        return Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const HomeEarnings(),
              const VSpace(smallWhiteSpace),
              const HomeRide(),
              const VSpace(smallWhiteSpace),
              Column(
                children: [
                  const HomeActivity(),
                  const VSpace(smallWhiteSpace),
                  if (state is RideHistoryLoading) showProgressIndicator(),
                  if (state is RideHistoryError)
                    Text(
                      'Failed to load activity',
                      style: descriptionTextStyle,
                    ),
                  if (firstRide != null)
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
              const VSpace(whiteSpace),
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
    text: 'Too far from my current location',
  );
  final TextEditingController commentController = TextEditingController(
    text: "He's a very nice and punctual person",
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<RideCubit, RideState>(
          builder: (context, rideState) {
            final rideDetails = rideState is RideLoaded ? rideState.ride : null;
            final rideStatus = homeState.rideStatus;
            final isRideActive = rideStatus == TransitStatus.accepted;
            final isRideCompleted = rideStatus == TransitStatus.completed;
            final rideType = rideDetails?.type ?? '';
            final isMultiStop = rideDetails?.isMultiStop ?? false;
            final isAccepted = rideDetails?.status == acceptedRide;
            final isArrived = rideDetails?.status == arrivedRide;
            final isStarted = rideDetails?.status == inProgressRide;
            final isCompleted = rideDetails?.status == completedRide;
            final isCashPending =
                rideDetails?.paymentMethod == 'cash' &&
                rideDetails?.paymentStatus == 'pending';

            Widget buildActionButton() {
              String title;
              VoidCallback? onPressed;
              Color backgroundColor = thickFillColor;

              if (isAccepted) {
                title = 'Arrived At Pickup';
                onPressed =
                    () => context.read<RideCubit>().arrivedRide(context);
              } else if (isArrived) {
                title = 'Start ${rideType.capitalize}';
                onPressed = () => context.read<RideCubit>().startRide(context);
                backgroundColor = Colors.black;
              } else if (isStarted) {
                if (isMultiStop) {
                  title =
                      'Complete ${getOrdinal(rideDetails?.numberOfStops ?? 0)}/4 Stop';
                  onPressed =
                      () => context.read<RideCubit>().completeMultiStopRide(
                        context,
                      );
                } else {
                  title = 'Complete ${rideType.capitalize}';
                  onPressed =
                      () => context.read<RideCubit>().completeRide(context);
                }
                backgroundColor = Colors.black;
              } else if (isCashPending) {
                title = 'Confirm Cash Payment';
                onPressed =
                    () => context.read<RideCubit>().confirmCashPayment(context);
                backgroundColor = greenColor;
              } else if (isCompleted && !isCashPending) {
                title = 'Rate ${rideType == "delivery" ? "Delivery" : "User"}';
                onPressed =
                    () => context.read<RideCubit>().rateRideUser(
                      context,
                      rating: userRating,
                      comment: commentController.text,
                    );
                backgroundColor = thickFillColor;
              } else {
                title = '';
                onPressed = null;
              }

              if (title.isEmpty) return const SizedBox.shrink();

              return SimpleButton(
                title: title,
                onPressed: onPressed,
                backgroundColor: backgroundColor,
              );
            }

            Widget buildCancelOrFindButton() {
              final isActive = rideDetails != null && isRideActive;
              final title =
                  isActive
                      ? 'Cancel ${rideDetails.type.capitalize}'
                      : 'Find Nearby Rides';
              final backgroundColor = isActive ? redColor : thickFillColor;

              return Expanded(
                child: SimpleButton(
                  title: title,
                  onPressed: () {
                    if (isActive) {
                      showCustomModal(
                        context,
                        btnCancelText: 'Back',
                        btnOkText: 'Cancel ${rideDetails.type.capitalize}',
                        btnCancelOnPress: () {},
                        btnOkOnPress:
                            () => context.read<RideCubit>().cancelRide(
                              context,
                              reason: reasonController.text.trim(),
                            ),
                        child: buildField(
                          'Say reasons for canceling ${rideDetails.type}',
                          reasonController,
                        ),
                      ).show();
                    } else {
                      context.read<HomeCubit>().toggleNearByRides();
                    }
                  },
                  backgroundColor: backgroundColor,
                ),
              );
            }

            List<Widget> buildNavigateButton() {
              if (rideDetails != null &&
                  rideStatus == TransitStatus.accepted &&
                  !isArrived) {
                return [
                  const HSpace(extraSmallWhiteSpace),
                  Expanded(
                    child: SimpleButton(
                      title: 'Navigate',
                      onPressed: () {
                        Navigator.of(context).pushNamed(InAppCallMap.routeName);
                      },
                      backgroundColor: greyColor,
                      textStyle: paragraphTextStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ];
              }
              return const [SizedBox.shrink()];
            }

            Widget buildRatingSection() {
              if (rideDetails != null && isCompleted && !isCashPending) {
                return Column(
                  children: [
                    Text(
                      'How will you rate this $rideType? Tap to rate User',
                      style: const TextStyle(fontSize: normalText),
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
                              showCommentField = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const VSpace(extraSmallWhiteSpace),
                    if (showCommentField)
                      buildField(
                        'Say something about the user',
                        commentController,
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }

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
                  const GoogleMapView(),
                  const VSpace(smallWhiteSpace),
                  if (rideStatus == TransitStatus.searching)
                    Text(
                      'Searching for ride requests near you…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: smallText,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (rideDetails != null &&
                      rideStatus == TransitStatus.accepted &&
                      !isCompleted &&
                      !isArrived)
                    const EstimatedReachTime(),
                  const VSpace(smallWhiteSpace),
                  buildRatingSection(),
                  if (rideDetails != null && (isRideActive || isRideCompleted))
                    Row(children: [Expanded(child: buildActionButton())]),
                  if (!isCompleted)
                    Row(
                      children: [
                        buildCancelOrFindButton(),
                        ...buildNavigateButton(),
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

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    _setMapPins();
    super.initState();
  }

  Future<void> _setMapPins() async {
    final driverImage = await createCustomMarker(
      fallbackAssetPath: 'assets/app_images/user_profile.png',
      networkImageUrl: context.driver?.profilePicture,
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: context.driverLatLng!,
        icon: driverImage,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundedLg),
      child: SizedBox(
        height: 100,
        width: Responsive.width(context),
        child: GoogleMap(
          zoomControlsEnabled: false,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: context.driverLatLng!,
            zoom: 13,
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
