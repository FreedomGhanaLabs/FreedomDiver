import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/authentication/forgot_password/view/forgot_password_form.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/view/personal_details.dart';
import 'package:freedomdriver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedomdriver/feature/documents/address_proof/view/address_proof_form.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/earnings/view/driver_score_details_screen.dart';
import 'package:freedomdriver/feature/earnings/view/earnings_screen.dart';
import 'package:freedomdriver/feature/earnings/view/wallet_screen.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/kyc/view/criminal_background_check_screen.dart';
import 'package:freedomdriver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedomdriver/feature/main_activity/main_activity_screen.dart';
import 'package:freedomdriver/feature/onboarding/vew/onboarding_view.dart';
import 'package:freedomdriver/feature/profile/view/availability_dashboard.dart';
import 'package:freedomdriver/feature/profile/view/document_management_screen.dart';
import 'package:freedomdriver/feature/profile/view/profile_details.dart';
import 'package:freedomdriver/feature/profile/view/profile_screen.dart';
import 'package:freedomdriver/feature/splash/driver_splash.dart';
import 'package:freedomdriver/feature/splash/splash_screen.dart';
import 'package:freedomdriver/router/error_route_screen.dart';
import 'package:freedomdriver/shared/screens/success_screen.dart';
import 'package:freedomdriver/shared/screens/verification_status_screen.dart';

import '../feature/documents/ghana_card/view/ghana_card_form.dart';
import '../feature/profile/view/profile_image_cropper.dart';
import '../feature/profile/view/profile_picture.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  log('Next Route: ${settings.name}');
  switch (settings.name) {
    case SplashScreen.routeName:
      return _pageBuilder(
        (_) => const SplashScreen(),
        settings: settings,
      );
    case DriverSplashScreen.routeName:
      return _pageBuilder(
        (_) => const DriverSplashScreen(),
        settings: settings,
      );
    case OnboardingView.routeName:
      return _pageBuilder(
        (_) => const OnboardingView(),
        settings: settings,
      );
    case SuccessScreen.routeName:
      return _pageBuilder(
        (_) => const SuccessScreen(),
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
    case LoginFormScreen.routeName:
      return _pageBuilder(
        (_) => const LoginFormScreen(),
        settings: settings,
      );
    case ForgotPasswordFormScreen.routeName:
      return _pageBuilder(
        (_) => const ForgotPasswordFormScreen(),
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
    case GhanaCardForm.routeName:
      return _pageBuilder((_) => const GhanaCardForm(), settings: settings);
    case DriverLicenseForm.routeName:
      return _pageBuilder(
        (_) => const DriverLicenseForm(),
        settings: settings,
      );
    case AddressProofForm.routeName:
      return _pageBuilder(
        (_) => const AddressProofForm(),
        settings: settings,
      );
    case VerificationStatusScreen.routeName:
      return _pageBuilder(
        (_) => const VerificationStatusScreen(),
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
    case ProfileImageCropper.routeName:
      return _pageBuilder(
        (_) => const ProfileImageCropper(),
        settings: settings,
      );
    case ProfilePictureScreen.routeName:
      return _pageBuilder(
        (_) => const ProfilePictureScreen(),
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
