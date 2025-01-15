import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/app_images/decorated_scaffold.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: GoogleFonts.poppins(
                                fontSize: 12.96.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.29,
                                letterSpacing: -0.31.sp,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/app_icons/location_icon.svg',
                                ),
                                const HSpace(1),
                                Text(
                                  'Ghana,Kumasi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.96.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.29,
                                    letterSpacing: -0.31.sp,
                                  ),
                                ),
                                const HSpace(1),
                                SvgPicture.asset(
                                  'assets/app_icons/down_arrow.svg',
                                ),
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'Logistic',
                          style: GoogleFonts.poppins(
                            fontSize: 12.96,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const HSpace(1),
                        SvgPicture.asset(
                          'assets/app_icons/down_arrow.svg',
                        ),
                      ],
                    ),
                    VSpace(19.h),
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.78),
                            color: Colors.red.withOpacity(0.1),
                            border: const Border.fromBorderSide(
                              BorderSide(
                                color: Colors.red,
                                width: 1.56,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    VSpace(19.h),
                    const Row(
                      children: [
                        _DriverTotalEarnings(),
                        HSpace(15),
                        Column(
                          children: const [
                            _DriverTotalScore(),
                            VSpace(7),
                            DriverTotalOrder()
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 16, top: 7.9, right: 14, bottom: 12.75),
            margin: const EdgeInsets.only(
              right: 16,
              left: 16,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.99,
                  color: Colors.black.withOpacity(0.05000000074505806),
                ),
                borderRadius: BorderRadius.circular(4.95),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find ride',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const VSpace(4),
                const Image(
                  image: AssetImage('assets/app_images/driver_image.png'),
                ),
                const VSpace(16),
                Text(
                  'Searching for ride requests near you…',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA6A6A6),
                    fontSize: 8.39,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const VSpace(16),
                Row(
                  children: [
                    Expanded(
                      child: SimpleButton(
                        title: 'Find Nearby Rides',
                        onPressed: () {},
                        backgroundColor: const Color(0xff29CC6A),
                        padding: const EdgeInsets.only(
                          top: 6.93,
                          bottom: 6.93,
                          left: 22,
                          right: 22,
                        ),
                        borderRadius: BorderRadius.circular(4.95),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const HSpace(28),
                    Expanded(
                      child: SimpleButton(
                        title: 'Search Another Area',
                        onPressed: () {},
                        backgroundColor: const Color(0xEDABABB1),
                        padding: const EdgeInsets.only(
                          top: 6.93,
                          bottom: 6.93,
                          left: 22,
                          right: 22,
                        ),
                        borderRadius: BorderRadius.circular(4.95),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const VSpace(10.69),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Text(
                  'Your Activity',
                  style: GoogleFonts.poppins(
                    fontSize: 14.53,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'See All',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF59E0B),
                    fontSize: 14.53,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                    child:
                        SvgPicture.asset('assets/app_icons/right-arrow.svg')),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DriverTotalEarnings extends StatelessWidget {
  const _DriverTotalEarnings();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 149,
      padding: const EdgeInsets.only(left: 19, top: 22),
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
            color: Colors.black.withOpacity(0.10000000149011612),
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
              'Total Earning',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.29,
                letterSpacing: -0.41,
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
              height: 1.29,
              letterSpacing: -0.54,
            ),
          ),
          const VSpace(12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_icons/arrow_right_up.svg',
              ),
              const HSpace(7),
              SizedBox(
                width: 127,
                child: Text(
                  '0.0% than last month',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12.35,
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                    letterSpacing: -0.30,
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

class _DriverTotalScore extends StatelessWidget {
  const _DriverTotalScore();

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

class DriverTotalOrder extends StatelessWidget {
  const DriverTotalOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      padding: const EdgeInsets.only(
        left: 17,
        top: 9,
        bottom: 13,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withOpacity(0.119),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Total Order',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.66,
            fontWeight: FontWeight.w400,
            height: 1.29,
            letterSpacing: -0.45,
          ),
        ),
        const VSpace(5),
        Text(
          '20',
          style: GoogleFonts.poppins(
            color: const Color(0xFFF59E0B),
            fontSize: 16.82,
            fontWeight: FontWeight.w600,
            height: 1.29,
            letterSpacing: -0.40,
          ),
        )
      ]),
    );
  }
}
