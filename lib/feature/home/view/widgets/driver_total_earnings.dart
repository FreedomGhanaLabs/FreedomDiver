import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverTotalEarnings extends StatelessWidget {
  const DriverTotalEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 19, top: 22, right: 19, bottom: 20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-2.6, 0.72),
          end: Alignment(0.99, 0.05),
          colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
          stops: [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total\nEarning',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.41,
            ),
          ),
          5.verticalSpace,
          Text(
            '\$1,200.00',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.59,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.29,
              letterSpacing: -0.54,
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_icons/arrow_right_up.svg',
              ),
              const HSpace(7),
              SizedBox(
                width: 90.w,
                child: Text(
                  '0.0% than last month',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ],
      ),

    );
  }
}

class TotalEarnings extends StatelessWidget {
  const TotalEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 19,
        top: 22,
      ),
      height: 149,
      width: 190,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-2.6, 0.72),
          end: Alignment(0.99, 0.05),
          colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
          stops: [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 102,
            child: Text(
              'Total ',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 102,
            child: Text(
              'Earning',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const VSpace(5),
          Text(
            '\$0.00',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 22.59,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VSpace(12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_icons/arrow_right_up.svg',
              ),
              const HSpace(7),
              Text(
                '0.0% than last month',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12.35,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
