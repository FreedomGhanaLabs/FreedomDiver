import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_carousel_one.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_carousel_two.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/hive/onboarding.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  static const routeName = '/onBoarding';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    const OnboardingCarouselOne(),
    const OnboardingCarouselTwo(),
  ];

  int _currentPage = 0;

  void goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> checkFirstTimer() async {
    final x = await getOnboardingFromHive();
    if (x != null) {
      await Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    checkFirstTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          const VSpace(16),
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: CustomizableEffect(
              dotDecoration: DotDecoration(
                width: 10,
                height: 10,
                color: carouselInactiveColor,
                borderRadius: const BorderRadius.all(Radius.circular(28)),
              ),
              activeDotDecoration: DotDecoration(
                width: 36,
                color: carouselActiveColor,
                borderRadius: const BorderRadius.all(Radius.circular(28)),
              ),
            ),
          ),
          const VSpace(46),
          if (_currentPage == 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: FreedomButton(
                backGroundColor: Colors.black,
                onPressed: () {
                  goToPage(1);
                },
                title: 'Next',
                buttonTitle: Text(
                  'Next',
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 17.41),
                ),
              ),
            ),
          if (_currentPage == 1)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  width: double.infinity,
                  child: FreedomButton(
                    backGroundColor: Colors.black,
                    height: 57.76.h,
                    onPressed: () {
                      addOnboardingToHive(true).then(
                        (_) => Navigator.pushNamed(context, '/register'),
                      );
                    },
                    buttonTitle: Text(
                      'Get Started',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17.41,
                      ),
                    ),
                  ),
                ),
                const VSpace(8.24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FreedomButton(
                        height: 57.76.h,
                        useGradient: true,
                        gradient: greenGradient,
                        borderRadius: BorderRadius.circular(13),
                        onPressed: () {
                          addOnboardingToHive(true).then(
                            (_) => Navigator.pushNamed(context, '/login'),
                          );
                        },
                        buttonTitle: Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17.41,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const VSpace(16),
        ],
      ),
    );
  }
}
