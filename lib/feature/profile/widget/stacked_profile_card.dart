
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 215,
          width: 348,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 9, right: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10 Ride Completed',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Reward',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset('assets/app_icons/arrow_right_icon.svg'),
              ],
            ),
          ),
        ),
        Positioned(
          top: 28,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            height: 187,
            width: 372,
            child: Column(
              children: [
                const VSpace(13),
                Container(
                  width: 67,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/app_images/user_profile.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -8,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black, width: 2),
                          ),
                          child: SvgPicture.asset(
                            'assets/app_icons/edit_profile.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Chale Kumasi',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const VSpace(10),
                Container(
                  width: 132,
                  height: 24,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: ShapeDecoration(
                    color: Colors.white.withOpacity(0.34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                          'assets/app_icons/copy_button_icon.svg'),
                      const HSpace(7),
                      Text(
                        '08012345678',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Business Suite',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}