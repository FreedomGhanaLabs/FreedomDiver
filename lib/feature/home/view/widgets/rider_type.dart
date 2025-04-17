import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class RideType extends StatelessWidget {
  const RideType({
    super.key,
    this.activityType,
  });
  final ActivityType? activityType;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                SvgPicture.asset(
                  'assets/app_images/green_color_motorcycle.svg',
                )
              else
                SvgPicture.asset(
                  'assets/app_icons/delivery_cart.svg',
                ),
              const HSpace(1.08),
              Text(
                activityType == ActivityType.ride ? 'Ride' : 'Logistics item',
                style: GoogleFonts.poppins(
                  color: activityType == ActivityType.ride
                      ? const Color(0xFF0BF535)
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
