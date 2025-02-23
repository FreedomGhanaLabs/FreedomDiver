import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/view/personal_details.dart';
import 'package:freedom_driver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/earnings/view/driver_score_details_screen.dart';
import 'package:freedom_driver/feature/earnings/view/earnings_screen.dart';
import 'package:freedom_driver/feature/earnings/view/wallet_screen.dart';
import 'package:freedom_driver/feature/home/view/inappcall_map.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedom_driver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedom_driver/feature/profile/view/availability_dashboard.dart';
import 'package:freedom_driver/feature/profile/view/document_management_screen.dart';
import 'package:freedom_driver/feature/profile/view/profile_details.dart';
import 'package:freedom_driver/feature/profile/view/profile_screen.dart';
import 'package:freedom_driver/feature/splash/splash_screen.dart';
import 'package:freedom_driver/router/error_route_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  log('Route: ${settings.name}');
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
    case InAppCallMap.routeName:
      return _pageBuilder(
        (_) => const InAppCallMap(),
        settings: settings,
      );
    case EarningsScreen.routeName:
      return _pageBuilder(
        (_) => const EarningsScreen(),
        settings: settings,
      );
    case WalletScreen.routeName:
      return _pageBuilder(
            (_) => const WalletScreen(),
        settings: settings,
      );
    case DriverScoreDetailsScreen.routeName:
      return _pageBuilder(
            (_) => const DriverScoreDetailsScreen(),
        settings: settings,
      );
    case ProfileScreen.routeName:
      return _pageBuilder(
            (_) => const ProfileScreen(),
        settings: settings,
      );
    case ProfileDetails.routeName:
      return _pageBuilder(
            (_) => const ProfileDetails(),
        settings: settings,
      );
    case DocumentManagementScreen.routeName:
      return _pageBuilder(
            (_) => const DocumentManagementScreen(),
        settings: settings,
      );
    case AvailabilityDashboard.routeName:
      return _pageBuilder(
            (_) => const AvailabilityDashboard(),
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
