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

import '../../../profile/widget/stacked_profile_card.dart';

class RiderTimeLine extends StatelessWidget {
  const RiderTimeLine({
    super.key,
    this.destinationDetails = '',
    this.pickUpDetails = '',
    this.activityType = ActivityType.ride,
    this.riderName = 'Chale Emma',
    this.riderId = 'XRFSGT2D',
    this.riderImage = 'assets/app_images/rider2.png',
  });
  final String destinationDetails;
  final String pickUpDetails;
  final String riderName;
  final String riderId;
  final ActivityType activityType;
  final String riderImage;

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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        riderId,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: smallText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RideType(activityType: activityType),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleButton(
                    title: '',
                    onPressed: () {},
                    borderRadius: BorderRadius.circular(8.65),
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 7,
                      right: extraSmallWhiteSpace,
                      bottom: 8.34,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(iconName: 'feedback_icon'),
                        const HSpace(4),
                        const Text(
                          'Provide Feedback',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: paragraphText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  const VSpace(14.61),
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
                              const VSpace(10),
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
                    '$appCurrency 2,000',
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
                        'Completed',
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
