import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void launchExternalNavigation(LatLng destination) {
  if (Platform.isAndroid) {
    launchGoogleMapsNavigation(destination);
  } else if (Platform.isIOS) {
    launchAppleMapsNavigation(destination);
  }
}

void launchAppleMapsNavigation(LatLng destination) async {
  final uri = Uri.parse(
    'http://maps.apple.com/?daddr=${destination.latitude},${destination.longitude}&dirflg=d',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('Could not launch Apple Maps');
  }
}

void launchGoogleMapsNavigation(LatLng destination) async {
  final uri = Uri.parse(
    'google.navigation:q=${destination.latitude},${destination.longitude}&mode=d',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('Could not launch Google Maps');
  }
}
