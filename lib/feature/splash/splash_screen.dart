import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedom_driver/utilities/hive/onboarding.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Image(
        image: AssetImage('assets/app_images/splash_image_rider.png'),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _navigateUser() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final box = Hive.box<bool>('firstTimerUser');
    final isFirstTimer = box.get('isFirstTimer', defaultValue: true) ?? true;
    final getFirstTimer = await getOnboardingFromHive();
    final getToken = await getTokenFromHive();
    if (!isFirstTimer || getToken != null) {
      await Navigator.pushReplacementNamed(
        context,
        MainActivityScreen.routeName,
      );
      return;
    }
    if (getFirstTimer != null) {
      await Navigator.pushReplacementNamed(
        context,
        LoginFormScreen.routeName,
      );
      return;
    }
    await Navigator.pushReplacementNamed(context, OnboardingView.routeName);
  }
}
