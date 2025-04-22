import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/ui.dart';

class DriverTotalScore extends StatelessWidget {
  const DriverTotalScore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: smallWhiteSpace,
        top: 9,
        bottom: 12,
        right: whiteSpace,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.119),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver Score',
            style: TextStyle(
              fontSize: normalText,
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.45,
            ),
          ),
          VSpace(extraSmallWhiteSpace),
          Row(
            children: [
              AppIcon(iconName: 'driver_score_icon'),
              HSpace(10),
              Text(
                '200',
                style: TextStyle(
                  fontSize: headingText,
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EarningsTotalScore extends StatelessWidget {
  const EarningsTotalScore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: smallWhiteSpace,
        top: 9,
        bottom: 12,
        right: whiteSpace,
      ),
      height: 71,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.119),
          ),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Score',
            style: TextStyle(
              color: Colors.black,
              fontSize: normalText,
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.45,
            ),
          ),
          Row(
            children: [
              SvgPicture.asset('assets/app_icons/driver_score_icon.svg'),
              const HSpace(9),
              const Text(
                '200',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.82,
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
