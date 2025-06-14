import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:freedomdriver/shared/app_config.dart';

class RideType extends StatelessWidget {
  const RideType({
    super.key,
    this.activityType,
  });
  final ActivityType? activityType;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.51),
        color: activityType == ActivityType.ride
            ? const Color(0xFFE6FFF7)
            : const Color(0xFFFFF5E6),
      ),
      child: Row(
        children: [
          Row(
            children: [
              if (activityType == ActivityType.ride)
                const AppIcon(iconName: 'green_color_motorcycle')
              else
                const AppIcon(iconName: 'delivery_cart'),
              const HSpace(1.08),
              Text(
                activityType == ActivityType.ride ? 'Ride' : 'Logistics item',
                style: GoogleFonts.poppins(
                  color: activityType == ActivityType.ride
                          ? greenColor
                      : thickFillColor,
                  fontSize: 3.98.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
