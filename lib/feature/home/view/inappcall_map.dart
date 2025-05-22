import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/di/locator.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_divider.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

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
  String averageTime = '0 mins';
  String distance = '0 KM';

  late final DriverLocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = getIt<DriverLocationService>();
    _locationService.startLiveLocationUpdates(context);
    _driverLocation = LatLng(
      context.driver?.location?.coordinates[0] ?? 37.774546,
      context.driver?.location?.coordinates[1] ?? -122.433523,
    );

    _pickupLocation = _locationService.generateRandomCoordinates(
      _driverLocation!,
      radius: 1000,
    );
    _destinationLocation = _locationService.generateRandomCoordinates(
      _driverLocation!,
      radius: 1000,
    );
    _setMapPins();
    _setPolylines().then((_) {
      _animateDriver();
      _getETA().then((eta) {
        debugPrint('ETA: $eta');
        setState(() {
          averageTime = eta['duration'] ?? '0 mins';
          distance = eta['distance'] ?? '0 KM';
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationService.stopLiveLocationUpdates();
  }

  Future<void> _setMapPins() async {
    final motorbikeIcon =
        await _createCustomMarker('assets/app_images/user_profile.png');
    final userIcon =
        await _createCustomMarker('assets/app_images/client_holder_image.png');
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
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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
            color: Colors.blue,
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

  final Dio dio = Dio();

  Future<Map<String, String>> _getETA() async {
    const apiKey = mapsAPIKey;
    final originLat = _driverLocation!.latitude;
    final originLng = _driverLocation!.longitude;
    final destLat = _pickupLocation!.latitude;
    final destLng = _pickupLocation!.longitude;

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200 &&
          response.data['routes'].isNotEmpty as bool) {
        // debugPrint('${response.data['routes'][0]}');
        final duration =
            response.data['routes'][0]['legs'][0]['duration']['text'];
        final distance =
            response.data['routes'][0]['legs'][0]['distance']['text'];
        return {
          'duration': duration as String,
          'distance': distance.toString(),
        };
      } else {
        throw Exception('No routes found or bad response.');
      }
    } catch (e) {
      throw Exception('Failed to load ETA: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _driverLocation!,
              zoom: 13,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;

              _mapController?.animateCamera(
                CameraUpdate.newLatLng(_driverLocation!),
              );
            },
          ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/app_images/client_holder_image.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                      const HSpace(smallWhiteSpace),
                      const Text(
                        'Dr Ben Larry Cage',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: paragraphText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const TypeCapsule(),
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
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    'A passenger is waiting for you',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: smallText.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const VSpace(19),
                // EqualSignCrossContainer(),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        PassengerDestinationDetailBox(),
                        VSpace(38),
                        PassengerDestinationDetailBox(),
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
                            color: Colors.black
                                .withValues(alpha: 0.5600000023841858),
                            fontSize: extraSmallText.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const VSpace(10),
                        Text(
                          r'$20.5',
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
                          distance,
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
                          'Avg.TIme',
                          style: TextStyle(
                            color: Colors.black
                                .withValues(alpha: 0.5600000023841858),
                            fontSize: extraSmallText.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const VSpace(10),
                        Text(
                          averageTime,
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
                const VSpace(37),
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDropDown(
                        items: const <String>['In-App Call', 'Video Call'],
                        initialValue: 'In-App Call',
                        onChanged: (i) {},
                      ),
                      const HSpace(30),
                      Container(
                        margin: const EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        width: 139,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: GradientBoxBorder(gradient: gradient),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => gradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.99,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VSpace(18),
                const CustomDivider(),
                const VSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      title: '',
                      onPressed: () {},
                      borderRadius: BorderRadius.circular(5),
                      padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                      backgroundColor: const Color(0xFFD47F00),
                      child: const Text(
                        'Waiting',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.99,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const VSpace(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PassengerDestinationDetailBox extends StatelessWidget {
  const PassengerDestinationDetailBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Container(
        width: 369,
        padding: const EdgeInsets.only(left: 8, top: 13, bottom: 12.96),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0x19110F51)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pickup Point',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5099999904632568),
                fontSize: 7.90,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              '23,Canada ,avenue',
              style: TextStyle(
                color: Colors.black,
                fontSize: 9.17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
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
  const TypeCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(roundedMd),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Logistics',
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
