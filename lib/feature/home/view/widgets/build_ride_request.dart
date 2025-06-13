import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/text_style.dart';
import 'package:freedomdriver/utilities/responsive.dart';

Widget buildCustomerDetail(BuildContext context, [RideRequest? ride]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RideDetailTile(
        title: 'Pickup Location',
        subtitle: ride?.pickupLocation.address ?? '',
      ),
      RideDetailTile(
        title: 'Dropoff Location',
        subtitle: ride?.dropoffLocation.address ?? '',
      ),
      RideDetailTile(
        title: 'Estimated Fare',
        subtitle: '${ride?.currency} ${ride?.estimatedFare.toStringAsFixed(2)}',
      ),
    ],
  );
}

class RideDetailTile extends StatelessWidget {
  const RideDetailTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(context),
      margin: const EdgeInsets.only(bottom: smallWhiteSpace),
      decoration: ShapeDecoration(
        color: const Color(0x0FFFBA40),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(smallWhiteSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: rideRequestTitleTextStyle),
            // const Spacer(),
            Text(
              subtitle.replaceAll('null', ''),
              style: rideRequestDetailTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
