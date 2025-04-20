import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_carousel_one.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/helpers/responsive.dart';
import 'package:freedom_driver/utilities/hive/onboarding.dart';
import 'package:freedom_driver/utilities/ui.dart';

class OnboardingCarouselTwo extends StatelessWidget {
  const OnboardingCarouselTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/app_images/driver_bcg_onboard2.png'),
                    fit: BoxFit.cover,
                  ),
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
                        borderRadius: BorderRadius.circular(5),
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
                top: Responsive.height(context) / 4,
                right: Responsive.width(context) / 2.5,
                child: Image.asset('assets/app_images/bcg2_decorator.png'),
              ),
              Positioned(
                bottom: -(Responsive.height(context) / 5),
                right: 0,
                child: Image.asset('assets/app_images/driver_bcg_model_2.png'),
              ),
            ],
          ),
          const VSpace(10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: smallWhiteSpace),
            child: CarouselDescription(
              description:
                  'As a customer, finding a bike has never been easier. Track nearby riders, compare fares, and get moving - all from the palm of your hand.',
              title: 'Designed for Your Convenience',
            ),
          ),
          const VSpace(smallWhiteSpace),
        ],
      ),
    );
  }
}
