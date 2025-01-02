import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_carousel_one.dart';
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
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/app_images/driver_bcg_onboard2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 44,
                right: 16,
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
                    onPressed: () {},
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 13.7),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 219,
                child: Image.asset('assets/app_images/bcg2_decorator.png'),
              )
            ],
          ),
          const VSpace(10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CarouselDescription(
              description:
                  // ignore: lines_longer_than_80_chars
                  'As a customer, finding a bike has never been easier. Track nearby riders, compare fares, and get moving – all from the palm of your hand.',
              title: 'Designed for Your Convenience',
            ),
          ),
          const VSpace(20),
        ],
      ),
    );
  }
}
