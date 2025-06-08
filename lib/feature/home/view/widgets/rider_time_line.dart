import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_type.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../profile/widget/stacked_profile_card.dart';

class RiderTimeLine extends StatelessWidget {
  const RiderTimeLine({
    super.key,
    this.destinationDetails = '',
    this.pickUpDetails = '',
    this.activityType = ActivityType.ride,
    this.riderId = 'XRFSGT2D',
    this.currency,
    this.fare,
    this.status,
  });
  final String destinationDetails;
  final String pickUpDetails;
  final String riderId;
  final ActivityType activityType;
  final String? currency;
  final String? status;
  final double? fare;

  @override
  Widget build(BuildContext context) {
    final driver = context.driver;
    return Container(
      padding: const EdgeInsets.fromLTRB(14.07, 10.47, 9, 6.17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DriverProfileImage(size: 35),
                  const HSpace(7.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver?.fullName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: extraSmallText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        riderId.substring(0, 10),
                        style: TextStyle(
                          fontSize: smallText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RideType(activityType: activityType),
                    ],
                  ),
                ],
              ),
              SimpleButton(
                title: '',
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(iconName: 'feedback_icon'),
                    const HSpace(4),
                    const Text(
                      'Provide Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: smallText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pick up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.78,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const VSpace(medWhiteSpace),
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return darkGoldGradient.createShader(bounds);
                                },
                                child: Text(
                                  pickUpDetails,
                                  style: TextStyle(
                                    color: const Color(0xFFF59E0B),
                                    fontSize: 9.50,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const HSpace(41),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Destination',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.78,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const VSpace(10),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return darkGoldGradient.createShader(bounds);
                                },
                                child: Text(
                                  destinationDetails,
                                  style: TextStyle(
                                    color: const Color(0xFFF59E0B),
                                    fontSize: 9.07,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const VSpace(smallWhiteSpace),
                  Text(
                    '${currency ?? appCurrency} ${fare?.toStringAsFixed(2) ?? "0.00"}',
                    style: TextStyle(
                      fontSize: smallText,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF727272),
                    ),
                  ),
                  const VSpace(medWhiteSpace),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcon(iconName: 'checked_icon'),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
