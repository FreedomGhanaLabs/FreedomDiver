import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/helpers/responsive.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/hive/onboarding.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingCarouselOne extends StatelessWidget {
  const OnboardingCarouselOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  child: const Image(
                    fit: BoxFit.cover,
                    image:
                        AssetImage('assets/app_images/driver_bcg_onboard.png'),
                  ),
                ),
                Positioned(
                  top: normalWhiteSpace,
                  right: smallWhiteSpace,
                  child: SizedBox(
                    height: 29,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(roundedMd),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 4,
                        ),
                      ),
                      onPressed: () {
                        addOnboardingToHive(true).then(
                          (_) => Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginFormScreen.routeName,
                            (route) => false,
                          ),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: paragraphText,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Responsive.height(context) / 7,
                  right: Responsive.width(context) / 9,
                  child: Image.asset('assets/app_images/bcg_decorator.png'),
                ),
                Positioned(
                  bottom: -50,
                  right: 0,
                  child:
                      Image.asset('assets/app_images/driver_bcg_model_1.png'),
                ),
              ],
            ),
            const VSpace(28),
            const CarouselDescription(
              description:
                  'Discover a new way to move through the city, quickly and affordably. With Gofreedom, bikes are at your fingertips, ready to take you where you need to go in minutes.',
              title: 'Welcome to Gofreedom',
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselDescription extends StatelessWidget {
  const CarouselDescription({
    required this.description,
    required this.title,
    super.key,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: headingText,
            fontWeight: FontWeight.w600,
            color: colorRed,
          ),
        ),
        const VSpace(6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            textAlign: TextAlign.center,
            description,
            style: GoogleFonts.poppins(
              fontSize: normalText,
              color: colorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
