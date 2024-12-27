import 'package:flutter/material.dart';
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
