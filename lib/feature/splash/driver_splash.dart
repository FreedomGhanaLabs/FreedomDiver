import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/main_activity/main_activity_screen.dart';
import 'package:freedomdriver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedomdriver/shared/api/load_dashboard.dart';
import 'package:freedomdriver/utilities/hive/onboarding.dart';
import 'package:freedomdriver/utilities/hive/token.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({super.key});
  static const routeName = '/driver-splash';

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen> {
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
    final [isFirstTimer, token] = await Future.wait([
      getOnboardingFromHive(),
      getTokenFromHive(),
    ]);

    if (!context.mounted) return;

    if (token != null) {
      await loadDashboard(context, loadAll: false);

      await Navigator.pushNamedAndRemoveUntil(
        context,
        MainActivityScreen.routeName,
        (route) => false,
      );
      return;
    } else if (isFirstTimer != null) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        LoginFormScreen.routeName,
        (route) => false,
      );
      return;
    } else {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        OnboardingView.routeName,
        (route) => false,
      );
    }
  }
}
