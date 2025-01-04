import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/view/personal_details.dart';
import 'package:freedom_driver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedom_driver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedom_driver/feature/splash/splash_screen.dart';
import 'package:freedom_driver/router/error_route_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return _pageBuilder(
        (_) => const SplashScreen(),
        settings: settings,
      );
    case OnboardingView.routeName:
      return _pageBuilder(
        (_) => const OnboardingView(),
        settings: settings,
      );
    case MainActivityScreen.routeName:
      return _pageBuilder(
        (_) => const MainActivityScreen(),
        settings: settings,
      );
    case RegisterFormScreen.routeName:
      return _pageBuilder(
        (_) => const RegisterFormScreen(),
        settings: settings,
      );
    case VerifyOtpScreen.routeName:
      return _pageBuilder(
        (_) => const VerifyOtpScreen(),
        settings: settings,
      );
    case PersonalDetailScreen.routeName:
      return _pageBuilder(
        (_) => const PersonalDetailScreen(),
        settings: settings,
      );
    case VehicleDetailsScreen.routeName:
      return _pageBuilder(
        (_) => const VehicleDetailsScreen(),
        settings: settings,
      );
    case BackgroundVerificationScreen.routeName:
      return _pageBuilder(
        (_) => const BackgroundVerificationScreen(),
        settings: settings,
      );
    case CriminalBackgroundCheckScreen.routeName:
      return _pageBuilder(
        (_) => const CriminalBackgroundCheckScreen(),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const ErrorRouteScreen(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) pageBuilder, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, __) => pageBuilder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
