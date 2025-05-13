import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/feature/home/view/widgets/rider_type.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: Image(
                      image: AssetImage(riderImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const HSpace(7.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riderName,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 6.14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        riderId,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 11.83,
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
                      right: 5.75,
                      bottom: 8.34,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/app_icons/feedback_icon.svg',
                        ),
                        const HSpace(3.25),
                        const Text(
                          'Provide Feedback',
                          style: TextStyle(color: Colors.white),
                        )
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
                  SvgPicture.asset(
                    'assets/app_images/distance_line.svg',
                  ),
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
                                style: GoogleFonts.poppins(
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
                                  style: GoogleFonts.poppins(
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
                                style: GoogleFonts.poppins(
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
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFF59E0B),
                                    fontSize: 9.07,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const VSpace(16),
                  Text(
                    'Rs. 2,000',
                    style: GoogleFonts.poppins(
                      fontSize: 11.78,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF727272),
                    ),
                  ),
                  const VSpace(12.97),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/app_icons/checked_icon.svg'),
                      Text(
                        'Completed',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0BF535),
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
