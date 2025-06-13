import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/view/wallet_screen.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_background_widget.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_banner.dart';
import 'package:freedomdriver/feature/home/view/home_screen.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../cubit/finance/financial_cubit.dart';
import '../cubit/finance/financial_state.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  static const String routeName = '/earnings';

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FinancialCubit, FinancialState>(
        builder: (context, state) {
          final finance = state is FinancialLoaded ? state.finance : null;
          return Stack(
            children: [
              const EarningsBackgroundWidget(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: smallWhiteSpace,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpace(
                        MediaQuery.of(context).padding.top +
                            extraSmallWhiteSpace,
                      ),
                      Text('Earnings Overview', style: normalTextStyle),
                      SizedBox(
                        width:
                            Responsive.isMobile(context)
                                ? 310
                                : Responsive.width(context),
                        child: Text(
                          "See how much you've made this week at a glance.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: smallText.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      smallWhiteSpace.verticalSpace,
                      const HomeEarnings(),
                      smallWhiteSpace.verticalSpace,
                      Text('Logistics Summary', style: normalTextStyle),
                      smallWhiteSpace.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: DashboardContainer(
                              svgImage: const AppIcon(
                                iconName: 'driver_score_icon',
                              ),
                              title: 'Number of trips',
                              value: '${finance?.rideCount ?? 0}',
                            ),
                          ),
                          smallWhiteSpace.horizontalSpace,
                          const Expanded(
                            child: DashboardContainer(
                              svgImage: AppIcon(iconName: 'time_icons'),
                              title: 'Timely Delivery',
                              value: '100%',
                            ),
                          ),
                        ],
                      ),
                      const VSpace(whiteSpace),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Wallet',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: normalText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const VSpace(10),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '$appCurrency ',
                                      style: TextStyle(
                                        fontSize: headingText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          finance?.availableBalance
                                              .toStringAsFixed(2) ??
                                          '0.00',
                                      style: const TextStyle(
                                        fontSize: emphasisText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VSpace(8),
                              SimpleButton(
                                title: '',
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(WalletScreen.routeName);
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 19,
                                  vertical: 12,
                                ),
                                borderRadius: BorderRadius.circular(roundedLg),
                                child: const Row(
                                  children: [
                                    AppIcon(iconName: 'withdraw_icons'),
                                    HSpace(medWhiteSpace),
                                    Text(
                                      'Withdraw',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: paragraphText,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const HSpace(whiteSpace),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 6,
                              ),
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-0, 1),
                                  end: Alignment.topCenter,
                                  colors: gradientColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Color(0x21E61D2A),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    roundedLg,
                                  ),
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
                                            borderRadius: BorderRadius.circular(
                                              roundedLg,
                                            ),
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 9,
                                          bottom: 9,
                                          left: 8,
                                          right: 8,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/app_icons/gold_medal.svg',
                                        ),
                                      ),
                                      const HSpace(4),
                                      const Text(
                                        'Bonuses and Incentives',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.65,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VSpace(3),
                                  const Text(
                                    'Complete 10 rides a day to earn an extra $appCurrency 20.00!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: smallText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const RideBonusContainer(totalRides: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VSpace(smallWhiteSpace),
                      EarningsBanner(
                        title: 'Earn $appCurrency 5,000 per invite',
                        subtitle:
                            'Invite your friends and family to ride with GofreedomApp',
                        child2: SvgPicture.asset('assets/app_icons/3d_tag.svg'),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(roundedLg),
                            ),
                          ),
                          child: const Text(
                            'Invite',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: paragraphText,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const VSpace(12),
                      const EarningsBanner(
                        title: 'Daily Earnings Breakdown',
                        subtitle:
                            'Invite your friends and family to ride with GofreedomApp',
                        child2: AppIcon(iconName: 'stats'),
                        child: SizedBox(
                          child: Row(
                            children: [
                              Text(
                                'Monday: $appCurrency 80.00',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: smallText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_sharp),
                            ],
                          ),
                        ),
                      ),
                      const VSpace(normalWhiteSpace),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RideBonusContainer extends StatefulWidget {
  const RideBonusContainer({
    required this.totalRides,
    super.key,
    this.requiredRides = 10,
  });
  final int totalRides;
  final int requiredRides;

  @override
  RideBonusContainerState createState() => RideBonusContainerState();
}

class RideBonusContainerState extends State<RideBonusContainer>
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

    _animation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (widget.totalRides / widget.requiredRides).clamp(
      0.0,
      1.0,
    );
    final isRewardReady = widget.totalRides >= widget.requiredRides;

    return ScaleTransition(
      scale: isRewardReady ? _animation : const AlwaysStoppedAnimation(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 8),
            child: LinearProgressIndicator(
              minHeight: 25,
              borderRadius: BorderRadius.circular(roundedLg),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Bonus Claimed!')));
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 17),
      // width: 190,
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(
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
                  child: svgImage,
                ),
              if (svgImage != null) const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value ?? '',
                  style: const TextStyle(
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
