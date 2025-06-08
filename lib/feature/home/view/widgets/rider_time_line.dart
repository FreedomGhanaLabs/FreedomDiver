import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_type.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/copy_to_clipboard.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../kyc/view/background_verification_screen.dart';
import '../../../profile/widget/stacked_profile_card.dart';

class RiderTimeLine extends StatelessWidget {
  const RiderTimeLine({
    super.key,
    this.destinationDetails = '',
    this.pickUpDetails = '',
    this.activityType = ActivityType.ride,
    this.riderId = '',
    this.currency,
    this.fare,
    this.status,
    this.completedAt,
  });

  final String destinationDetails;
  final String pickUpDetails;
  final String riderId;
  final ActivityType activityType;
  final String? currency;
  final String? status;
  final String? completedAt;
  final double? fare;

  @override
  Widget build(BuildContext context) {
    final driver = context.driver;

    return Container(
      padding: const EdgeInsets.fromLTRB(14.07, 10.47, 9, 6.17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(context, driver), _buildDetailsRow()],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, driver) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DriverProfileImage(size: 35),
            const HSpace(7),
            _buildDriverInfo(context, driver),
          ],
        ),
        SimpleButton(
          title: '',
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(iconName: 'feedback_icon'),
              const HSpace(extraSmallWhiteSpace),
              const Text(
                'Provide Feedback',
                style: TextStyle(color: Colors.white, fontSize: smallText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(context, driver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          driver?.fullName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: extraSmallText,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap:
              () => copyTextToClipboard(context, riderId, copyText: "Ride id"),
          child: Text(
            riderId.substring(0, 10),
            style: const TextStyle(
              fontSize: smallText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        RideType(activityType: activityType),
      ],
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLocationsColumn(), _buildFareStatusColumn()],
    );
  }

  Widget _buildLocationsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VSpace(smallWhiteSpace),
        SvgPicture.asset('assets/app_images/distance_line.svg'),
        SizedBox(
          width: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLocationInfo('Pick up', pickUpDetails, 9.50),
              ),
              const HSpace(41),
              Expanded(
                child: _buildLocationInfo(
                  'Destination',
                  destinationDetails,
                  9.07,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(String label, String details, double fontSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8.78,
            fontWeight: FontWeight.w400,
          ),
        ),
        VSpace(label == 'Pick up' ? medWhiteSpace : 10),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback:
              (Rect bounds) => darkGoldGradient.createShader(bounds),
          child: Text(
            details,
            style: TextStyle(
              color: const Color(0xFFF59E0B),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFareStatusColumn() {
    return Column(
      children: [
        const VSpace(smallWhiteSpace),
        Text(
          '${currency ?? appCurrency} ${fare?.toStringAsFixed(2) ?? "0.00"}',
          style: const TextStyle(
            fontSize: smallText,
            fontWeight: FontWeight.w500,
            color: Color(0xFF727272),
          ),
        ),
        const VSpace(medWhiteSpace),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == "completed") AppIcon(iconName: 'checked_icon'),
            Text(
              status?.capitalize ?? "Completed",
              style: TextStyle(
                fontSize: smallText,
                fontWeight: FontWeight.w500,
                color: greenColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
