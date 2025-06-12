import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/constants/ride.dart';
import 'package:freedomdriver/core/di/locator.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/view/inapp_ride_messaging.dart';
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

import '../../../shared/widgets/custom_draggable_sheet.dart';
import '../../../utilities/copy_to_clipboard.dart';
import '../../../utilities/tts.dart';
import 'utilities/get_navigation_steps.dart';
import 'utilities/launch_map_navigation.dart';

class InAppCallMap extends StatefulWidget {
  const InAppCallMap({super.key});
  static const String routeName = '/inAppCallMap';

  @override
  State<InAppCallMap> createState() => _InAppCallMapState();
}

class _InAppCallMapState extends State<InAppCallMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
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

    if (rideProperties == null) Navigator.of(context).pop();

    _pickupLocation = LatLng(
      rideProperties!.pickupLocation.coordinates.last,
      rideProperties.pickupLocation.coordinates.first,
    );

    _destinationLocation = LatLng(
      rideProperties.dropoffLocation.coordinates.last,
      rideProperties.dropoffLocation.coordinates.first,
    );

    _setMapPins();
    _startDriverJourney();
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

  Future<List<LatLng>> _getPolylinePoints(LatLng start, LatLng end) async {
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: mapsAPIKey,
      request: PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isEmpty) return [];

    final steps = await getNavigationSteps(destination: end, origin: start);

    for (var step in steps) {
      log("[InApp Map] Instruction: $steps");
      await TTS.speak(step);
    }

    return result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  Future<void> _drawRoutePolyline(List<LatLng> points, String id) async {
    _polylines.removeWhere((p) => p.polylineId.value == id);
    _polylines.add(
      Polyline(
        polylineId: PolylineId(id),
        width: 5,
        color: gradient1,
        points: points,
      ),
    );
    setState(() {});
  }

  Future<void> _animateDriverAlong(List<LatLng> route) async {
    for (int i = 0; i < route.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1000), () {
        final point = route[i];
        _driverLocation = point;
        _markers.removeWhere((m) => m.markerId.value == 'driver');
        _markers.add(
          Marker(
            markerId: const MarkerId('driver'),
            position: point,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(title: 'Driver'),
          ),
        );
        _mapController?.animateCamera(CameraUpdate.newLatLng(point));
        setState(() {});
      });
    }
  }

  Future<void> _startDriverJourney() async {
    if (_driverLocation == null ||
        _pickupLocation == null ||
        _destinationLocation == null) {
      return;
    }

    final toPickupRoute = await _getPolylinePoints(
      _driverLocation!,
      _pickupLocation!,
    );
    await _drawRoutePolyline(toPickupRoute, 'toPickup');
    await _animateDriverAlong(toPickupRoute);

    final toDestinationRoute = await _getPolylinePoints(
      _pickupLocation!,
      _destinationLocation!,
    );
    await _drawRoutePolyline(toDestinationRoute, 'toDestination');
    await _animateDriverAlong(toDestinationRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RideCubit, RideState>(
        listener: (context, state) {},
        builder: (context, state) {
          final ride = state is RideLoaded ? state.ride : null;

          final userPhone = ride?.user?.phone ?? "";

          final isAccepted = ride?.status == "accepted";
          final isRideArrivedStatus = ride?.status == arrivedRide;

          final etaToPickup = ride?.etaToPickup?.text;
          final etaToDropoff = ride?.etaToDropoff?.text;
          final averageTime = isRideArrivedStatus ? etaToPickup : etaToDropoff;
          return Stack(
            children: [
              showGoogleMap(),
              Positioned(
                top: Responsive.top(context) + smallWhiteSpace,
                left: whiteSpace,
                child: const DecoratedBackButton(),
              ),
              Positioned(
                top: Responsive.top(context) + smallWhiteSpace,
                right: whiteSpace,
                child: IconButton(
                  icon: Icon(Icons.navigation),
                  color: Colors.black,
                  onPressed:
                      () => launchExternalNavigation(
                        isRideArrivedStatus
                            ? _pickupLocation!
                            : _destinationLocation!,
                      ),
                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User's Contact", style: normalTextStyle),
                              SelectableText(
                                userPhone,
                                maxLines: 2,
                                onTap:
                                    () => copyTextToClipboard(
                                      context,
                                      userPhone,
                                      copyText: "Phone number",
                                    ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: paragraphText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          OutlinedContainer(rideType: ride?.rideType ?? ""),
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
                        InfoColumn(
                          title: 'Price',
                          value:
                              "${ride?.currency} ${ride?.estimatedFare.toStringAsFixed(2) ?? "0.00"}",
                        ),
                        InfoColumn(
                          title: 'Expected Distance Covered',
                          value: ride?.estimatedDistance?.text ?? "",
                        ),
                        InfoColumn(title: 'Avg.Time', value: averageTime ?? ""),
                      ],
                    ),
                    const VSpace(whiteSpace),
                    const CustomDivider(),
                    const VSpace(whiteSpace),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: smallWhiteSpace,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SimpleButton(
                              title: "Call User",
                              icon: Icons.call,
                              onPressed:
                                  () => callUser(ride?.user?.phone ?? ''),
                            ),
                          ),
                          const SizedBox(width: extraSmallWhiteSpace),
                          Expanded(
                            child: SimpleButton(
                              title: "Message",
                              icon: Icons.send,
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    InappRideMessaging.routeName,
                                  ),
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
      initialCameraPosition: CameraPosition(
        target: context.driverLatLng!,
        zoom: 16,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(context.driverLatLng!),
        );
      },
    );
  }
}

class InfoColumn extends StatelessWidget {
  const InfoColumn({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: smallText.sp - 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        const VSpace(medWhiteSpace - 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: paragraphText.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

void callUser(String phoneNumber) async {
  final url = Uri.parse('tel:$phoneNumber');
  if (await canLaunchUrl(url)) await launchUrl(url);
}

class OutlinedContainer extends StatelessWidget {
  const OutlinedContainer({super.key, required this.rideType});

  final String rideType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: smallWhiteSpace,
        vertical: extraSmallWhiteSpace,
      ),
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
