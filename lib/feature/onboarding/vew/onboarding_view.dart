import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedomdriver/feature/onboarding/vew/onboarding_carousel_one.dart';
import 'package:freedomdriver/feature/onboarding/vew/onboarding_carousel_two.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/hive/onboarding.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  static const routeName = '/onBoarding';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = const [
    OnboardingCarouselOne(),
    OnboardingCarouselTwo(),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkFirstTimer();
  }

  Future<void> _checkFirstTimer() async {
    final x = await getOnboardingFromHive();
    if (x != null) {
      await Navigator.pushReplacementNamed(context, LoginFormScreen.routeName);
    }
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildButton({
    required String title,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Gradient? gradient,
    bool useGradient = false,
  }) {
    return FreedomButton(
      backGroundColor: backgroundColor,
      gradient: gradient ?? LinearGradient(colors: gradientColor),
      useGradient: useGradient,
      title: title,
      onPressed: onPressed,
    );
  }

  Widget _buildActionButtons() {
    final double horizontalPadding = whiteSpace.w;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          if (_currentPage == 1)
            _buildButton(
              title: 'Get Started',
              backgroundColor: Colors.black,
              onPressed: () async {
                await addOnboardingToHive(true);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RegisterFormScreen.routeName,
                  (route) => false,
                );
              },
            ),
          VSpace(
            Responsive.isBigMobile(context) ? medWhiteSpace : smallWhiteSpace,
          ),
          _buildButton(
            title: 'Continue',
            useGradient: true,
            gradient: greenGradient,
            onPressed: () async {
              await addOnboardingToHive(true);
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginFormScreen.routeName,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = whiteSpace.w;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          const VSpace(smallWhiteSpace),
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: CustomizableEffect(
              dotDecoration: DotDecoration(
                width: 10.w,
                height: 10.w,
                color: carouselInactiveColor,
                borderRadius: BorderRadius.circular(roundedLg),
              ),
              activeDotDecoration: DotDecoration(
                width: 30.w,
                color: carouselActiveColor,
                borderRadius: BorderRadius.circular(roundedLg),
              ),
            ),
          ),
          const VSpace(whiteSpace),
          if (_currentPage == 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildButton(
                title: 'Next',
                backgroundColor: Colors.black,
                onPressed: () => _goToPage(1),
              ),
            ),
          _buildActionButtons(),
          VSpace(Responsive.bottom(context) + smallWhiteSpace.sp),
        ],
      ),
    );
  }
}
