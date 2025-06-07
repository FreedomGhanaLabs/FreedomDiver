import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                top: Responsive.top(context) + smallWhiteSpace,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User's Contact", style: normalTextStyle),
                              SelectableText(
                                ride?.user?.phone ?? "",
                                maxLines: 2,
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
