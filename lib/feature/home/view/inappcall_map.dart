import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/di/locator.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_divider.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppCallMap extends StatefulWidget {
  const InAppCallMap({super.key});
  static const String routeName = '/inAppCallMap';

  @override
  State<InAppCallMap> createState() => _InAppCallMapState();
}

class _InAppCallMapState extends State<InAppCallMap> {
  // static LatLng sanFrancisco = const LatLng(37.774546, -122.433523);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  LatLng? _driverLocation;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;

  late final DriverLocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = getIt<DriverLocationService>();
    _locationService.startLiveLocationUpdates(context);
    final rideState = context.read<RideCubit>().state;
    _driverLocation = LatLng(
      context.driver?.location?.coordinates.last ?? 37.774546,
      context.driver?.location?.coordinates.first ?? -122.433523,
    );

    final rideProperties = rideState is RideLoaded ? rideState.ride : null;

    _pickupLocation =
        rideProperties != null
            ? LatLng(
              rideProperties.pickupLocation.coordinates.last,
              rideProperties.pickupLocation.coordinates.first,
            )
            : _locationService.generateRandomCoordinates(
              _driverLocation!,
              radius: 5000,
            );

    _destinationLocation =
        rideProperties != null
            ? LatLng(
              rideProperties.dropoffLocation.coordinates.last,
              rideProperties.dropoffLocation.coordinates.first,
            )
            : _locationService.generateRandomCoordinates(
              _driverLocation!,
              radius: 5000,
            );
    _setMapPins();
    _setPolylines().then((_) {
      _animateDriver();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationService.stopLiveLocationUpdates();
  }

  Future<void> _setMapPins() async {
    final motorbikeIcon = await _createCustomMarker(
      'assets/app_images/user_profile.png',
    );
    final userIcon = await _createCustomMarker(
      'assets/app_images/client_holder_image.png',
    );
    // final shopIcon =
    //     await _createCustomMarker('/assets/app_images/');

    _markers
      ..add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation!,
          icon: motorbikeIcon,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      )
      ..add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          icon: userIcon,
          infoWindow: const InfoWindow(title: 'User Location'),
        ),
      )
      ..add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'User Destination'),
        ),
      );
  }

  Future<BitmapDescriptor> _createCustomMarker(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    return BitmapDescriptor.bytes(bytes);
  }

  Future<void> _setPolylines() async {
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: mapsAPIKey,
      request: PolylineRequest(
        origin: PointLatLng(
          _driverLocation!.latitude,
          _driverLocation!.longitude,
        ),
        destination: PointLatLng(
          _pickupLocation!.latitude,
          _pickupLocation!.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      _polylineCoordinates.clear();
      for (final point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            width: 5,
            color: gradient1,
            points: _polylineCoordinates,
          ),
        );
      });
    }
  }

  Future<void> _animateDriver() async {
    for (var i = 0; i < _polylineCoordinates.length; i++) {
      await Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _driverLocation = _polylineCoordinates[i];
          _markers
            ..removeWhere((m) => m.markerId.value == 'driver')
            ..add(
              Marker(
                markerId: const MarkerId('driver'),
                position: _driverLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
                infoWindow: const InfoWindow(title: 'Your Location'),
              ),
            );
        });
      });
    }
  }

  void _callUser(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _messageUser(String phoneNumber) async {
    final url = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RideCubit, RideState>(
        listener: (context, state) {},
        builder: (context, state) {
          final ride = state is RideLoaded ? state.ride : null;

          final isAccepted = ride?.status == "accepted";

          final etaToPickup = ride?.etaToPickup;
          final etaToDestination = ride?.estimatedDuration?.value;
          final destinationTime = etaToDestination.toString();
          final pickUpTime = etaToPickup?.text.toString();
          final averageTime = isAccepted ? pickUpTime : destinationTime;
          return Stack(
            children: [
              showGoogleMap(),
              Positioned(
                top: MediaQuery.of(context).padding.top + smallWhiteSpace,
                left: whiteSpace,
                child: const DecoratedBackButton(),
              ),
              CustomBottomSheet(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(whiteSpace),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: smallWhiteSpace,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User's Contact", style: normalTextStyle),
                              InkWell(
                                child: Text(
                                  ride?.user?.phone ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: paragraphText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TypeCapsule(rideType: ride?.rideType ?? ""),
                        ],
                      ),
                    ),
                    const VSpace(whiteSpace),
                    Container(
                      width: Responsive.width(context),
                      height: 2,
                      decoration: const BoxDecoration(color: Color(0x72D9D9D9)),
                    ),
                    const VSpace(smallWhiteSpace),
                    if (isAccepted)
                      Padding(
                        padding: const EdgeInsets.only(left: smallWhiteSpace),
                        child: Text(
                          'A ${ride?.rideType == "normal" ? "passenger" : "package"} is waiting for you',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: paragraphText.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const VSpace(whiteSpace),
                    // EqualSignCrossContainer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            PassengerDestinationDetailBox(
                              title: 'Pickup Point',
                              subtitle: ride?.pickupLocation.address ?? "",
                            ),
                            VSpace(30),
                            PassengerDestinationDetailBox(
                              title: 'Destination',
                              subtitle: ride?.dropoffLocation.address ?? "",
                            ),
                          ],
                        ),
                        AppIcon(iconName: 'conversion'),
                      ],
                    ),
                    const VSpace(whiteSpace),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.black.withValues(
                                  alpha: 0.5600000023841858,
                                ),
                                fontSize: extraSmallText.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const VSpace(10),
                            Text(
                              "${ride?.currency} ${ride?.estimatedFare.toStringAsFixed(2) ?? "0.00"}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: paragraphText.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Expected Distance Covered',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.56),
                                fontSize: extraSmallText.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const VSpace(10),
                            Text(
                              ride?.estimatedDistance?.text ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: paragraphText.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Avg.Time',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.56),
                                fontSize: extraSmallText.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const VSpace(medWhiteSpace),
                            Text(
                              averageTime ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: paragraphText.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const VSpace(whiteSpace),
                    const CustomDivider(),
                    const VSpace(whiteSpace),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: whiteSpace,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SimpleButton(
                              title: "Call User",
                              onPressed:
                                  () => _callUser(ride?.user?.phone ?? ''),
                            ),
                          ),
                          const SizedBox(width: extraSmallWhiteSpace),
                          Expanded(
                            child: SimpleButton(
                              title: "Message User",
                              onPressed:
                                  () => _messageUser(ride?.user?.phone ?? ''),
                              backgroundColor: thickFillColor,
                            ),
                          ),
                        ],
                      ),

                    ),
                    const VSpace(whiteSpace),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  GoogleMap showGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _driverLocation!, zoom: 13),
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;

        _mapController?.animateCamera(CameraUpdate.newLatLng(_driverLocation!));
      },
    );
  }
}

class PassengerDestinationDetailBox extends StatelessWidget {
  const PassengerDestinationDetailBox({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(smallWhiteSpace),
      margin: const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x19110F51)),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: paragraphText,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: normalText, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    required this.child,
    this.height,
    super.key,
    this.padding,
  });
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          height: height ?? 200,
          padding: padding ?? EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(roundedLg),
              topRight: Radius.circular(roundedLg),
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30)],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: child,
          ),
        );
      },
    );
  }
}

class TypeCapsule extends StatelessWidget {
  const TypeCapsule({super.key, required this.rideType});

  final String rideType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(roundedMd),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rideType.replaceAll("normal", "Ride"),
            style: TextStyle(
              color: gradient1,
              fontSize: smallText.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
