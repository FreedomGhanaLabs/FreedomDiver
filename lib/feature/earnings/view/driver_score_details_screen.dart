import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/earnings/widgets/Gauge_score.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_divider.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverScoreDetailsScreen extends StatelessWidget {
  const DriverScoreDetailsScreen({super.key});
  static const String routeName = '/driver_score_details_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const DecoratedBackButton(),
                    Expanded(
                      child: Center(
                        child: Text(
                          'More Details',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ScoreGauge(
                score: 100,
                gradientColors: [colorRed, yellowGold, darkGoldColor],
                stops: const [0.1, 0.5, 0.9],
                // stops parameter is optional
              ),
              const VSpace(40),
              Text(
                'Driver Score',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 115,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '92',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 2.37,
                          letterSpacing: -0.66,
                        ),
                      ),
                      TextSpan(
                        text: '/100',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 2.37,
                          letterSpacing: -0.66,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.h),
              const CustomDivider(
                height: 7,
              ),
              const VSpace(17),
              Container(
                width: 386,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                decoration: ShapeDecoration(
                  color: const Color(0x0FEFEFEF),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                        color:
                            Colors.black.withValues(alpha: 0.07999999821186066),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                    children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: 367,
                      height: index == 2 ? 100 : 49,

                      decoration: ShapeDecoration(
                        color:
                            Colors.white.withValues(alpha: 0.11999999731779099),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Color(0x16996F26),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(moreDetailsList[index].title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.64,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                const HSpace(10),
                                moreDetailsList[index].image,
                                const Spacer(),
                                Text(moreDetailsList[index].ratioValue)
                                    .withGradient(),
                              ],
                            ),
                          ),
                          if (index == 2)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                  'Complete 30 trips with a score of 4.7 or above this week to receive a 5% bonus on your earnings!',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black.withValues(alpha: 0.43),
                                    fontSize: 11.98,
                                    fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class MoreDetailsModel {

  const MoreDetailsModel({
    required this.title,
    required this.image,
    required this.ratioValue,
  });
  final String title;
  final Widget image;
  final String ratioValue;
}

List<MoreDetailsModel> moreDetailsList = [
  MoreDetailsModel(
    title: 'Safety Compliance',
    image: SvgPicture.asset('assets/app_icons/freedom_info.svg'),
    ratioValue: '3.7/5',
  ),
  MoreDetailsModel(
    title: 'Delivery',
    image: SvgPicture.asset('assets/app_icons/freedom_info.svg'),
    ratioValue: '4.7/5',
  ),
  MoreDetailsModel(
    title: 'Rewards for High Scores',
    image: SvgPicture.asset('assets/app_icons/freedom_info.svg'),
    ratioValue: '30',
  ),
];

extension GradientText on Text {
  ShaderMask withGradient() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect rect) {
        return redLinearGradient.createShader(rect);
      },
      child: this,
    );
  }
}
