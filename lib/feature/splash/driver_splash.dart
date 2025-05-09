import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedom_driver/utilities/hive/onboarding.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:hive/hive.dart';

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
    await Future<void>.delayed(const Duration(seconds: 1));
    final box = Hive.box<bool>('firstTimerUser');
    final isFirstTimer = box.get('isFirstTimer', defaultValue: true) ?? true;
    final getFirstTimer = await getOnboardingFromHive();
    final getToken = await getTokenFromHive();
    if (!isFirstTimer || getToken != null) {
      final driverCubit = context.read<DriverCubit>();
      await driverCubit.getDriverProfile(context);
      await driverCubit.toggleStatus(
        context,
        setAvailable: true,
        toggleOnlyApi: true,
      );
      await Navigator.pushNamedAndRemoveUntil(
        context,
        MainActivityScreen.routeName,
        (route) => false,
      );
      return;
    } else if (getFirstTimer != null) {
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
