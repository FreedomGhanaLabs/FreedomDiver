import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/feature/earnings/widgets/earnings_background_widget.dart';
import 'package:freedom_driver/feature/earnings/widgets/earnings_banner.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_earnings.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_order.dart';
import 'package:freedom_driver/feature/home/view/widgets/driver_total_score.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  static const String routeName = '/earnings';

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.red,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              const EarningsBackgroundWidget(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      70.verticalSpace,
                      const Text(
                        'Earnings Overview',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 310,
                        child: Text(
                          "See how much you've made this week at a glance.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.98,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Row(
                        children: [
                          const Expanded(child: TotalEarningsWidget()),
                          15.horizontalSpace,
                          Expanded(
                            child: Column(
                              children: [
                                const DriverTotalScore(),
                                12.verticalSpace,
                                const DriverTotalOrder(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      const Text(
                        'Logistics Summary',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.23,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.29,
                          letterSpacing: -0.34,
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: DashboardContainer(
                                svgImage: SvgPicture.asset(
                                    'assets/app_icons/driver_score_icon.svg'),
                                title: 'Number of trips',
                                value: '200'),
                          ),
                          15.horizontalSpace,
                          Expanded(
                            child: DashboardContainer(
                                svgImage: SvgPicture.asset(
                                    'assets/app_icons/time_icons.svg'),
                                title: 'Timely Delivery',
                                value: '100%'),
                          ),
                        ],
                      ),
                      const VSpace(23),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const VSpace(8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'C',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 27.17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' 2,600.00',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 27.17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VSpace(8),
                              SimpleButton(
                                title: '',
                                onPressed: () {},
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 19, vertical: 12),
                                borderRadius: BorderRadius.circular(6),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/app_icons/withdraw_icons.svg'),
                                    const HSpace(6),
                                    Text(
                                      'Withdraw',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const HSpace(36),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 6),
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment(-0.00, 1.00),
                                  end: Alignment(0, -1),
                                  colors: [
                                    Color(0xFFF55C0B),
                                    Color(0xFFD04F09)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Color(0x21E61D2A),
                                  ),
                                  borderRadius: BorderRadius.circular(14.32),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                        ),
                                        padding: const EdgeInsets.only(
                                            top: 9,
                                            bottom: 9,
                                            left: 8,
                                            right: 8),
                                        child: SvgPicture.asset(
                                            'assets/app_icons/gold_medal.svg'),
                                      ),
                                      const HSpace(4),
                                      Text(
                                        'Bonuses and Incentives',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10.65,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                  const VSpace(3),
                                  Text(
                                    'Complete 10 rides a day to earn an extra ₵20.00!',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10.89,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const RideBonusContainer(
                                      totalRides: 5, requiredRides: 10),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const VSpace(15),
                       EarningsBanner(
                        title: 'Earn C 5,000 per invite',
                        subtitle: 'Invite your friends and family to ride with GofreedomApp', svgImage: 'assets/app_icons/3d_tag.svg',
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.47))),
                          child: Text(
                            'Invite ',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10.63,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const VSpace(12),
                      const EarningsBanner(
                        title: 'Daily Earnings Breakdown',
                        subtitle: 'Invite your friends and family to ride with GofreedomApp', svgImage: 'assets/app_icons/stats.svg',
                        child: SizedBox(

                          child: Row(
                            children: [
                              Text(
                                'Monday: ₵80.00',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11.77,

                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_sharp)
                            ],
                          ),
                        )
                        ),
                      const VSpace(41)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalEarningsWidget extends StatelessWidget {
  const TotalEarningsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 23),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.99, 0.14),
          end: Alignment(-0.99, -0.14),
          colors: [
            // Color(0x00F6AE35),
            Colors.white,
            Color(0xF6FBDCA7),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withOpacity(0.10000000149011612),
          ),
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
          const Text(
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
          const Text(
            '2.5% than last month',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.35,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.30,
            ),
          )
        ],
      ),
    );
  }
}

class RideBonusContainer extends StatefulWidget {
  const RideBonusContainer({
    super.key,
    required this.totalRides,
    this.requiredRides = 10,
  });
  final int totalRides;
  final int requiredRides;

  @override
  _RideBonusContainerState createState() => _RideBonusContainerState();
}

class _RideBonusContainerState extends State<RideBonusContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progressPercentage =
        (widget.totalRides / widget.requiredRides).clamp(0.0, 1.0);
    bool isRewardReady = widget.totalRides >= widget.requiredRides;

    return ScaleTransition(
      scale: isRewardReady ? _animation : const AlwaysStoppedAnimation(1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 8),
            child: LinearProgressIndicator(
              minHeight: 25,
              borderRadius: BorderRadius.circular(5),
              value: progressPercentage,
              backgroundColor: const Color(0xfff28c57),
              valueColor: AlwaysStoppedAnimation<Color>(
                isRewardReady ? Colors.green : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isRewardReady)
            ElevatedButton(
              onPressed: () {
                // Handle reward claim logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bonus Claimed!')),
                );
              },
              child: const Text('Claim Bonus'),
            ),
          const VSpace(15),
        ],
      ),
    );
  }
}

class DashboardContainer extends StatelessWidget {
  const DashboardContainer({
    required this.svgImage,
    required this.title,
    required this.value,
    super.key,
  });

  final String? title;
  final Widget? svgImage;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 17,
      ),
      // width: 190,
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.12),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (svgImage != null)
                SizedBox(
                  width: 24, // Fixed width for icon
                  height: 24, // Fixed height for icon
                  child: svgImage!,
                ),
              if (svgImage != null) const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


