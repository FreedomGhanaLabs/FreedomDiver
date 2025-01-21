import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverTotalScore extends StatelessWidget {
  const DriverTotalScore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      padding: const EdgeInsets.only(left: 17, top: 9, bottom: 13),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withOpacity(0.119),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver Score',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18.66,
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.45,
            ),
          ),
          Row(
            children: [
              SvgPicture.asset('assets/app_icons/driver_score_icon.svg'),
              const HSpace(9),
              Text(
                '200',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.82,
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.40,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
