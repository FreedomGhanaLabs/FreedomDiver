import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/splash/driver_splash.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToDriverSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          height: Responsive.height(context),
          width: Responsive.width(context),
          padding: const EdgeInsets.all(whiteSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Center(child: AppIcon(iconName: 'freedom_logo')),
              ),
              Text(
                'No delays, no traffic, just a bike and your destination.',
                style: TextStyle(
                  fontSize: smallText.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const VSpace(extraSmallWhiteSpace),
              Text(
                copyrightText,
                style:
                    TextStyle(fontSize: smallText, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToDriverSplash() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        DriverSplashScreen.routeName,
        (route) => false,
      );
    });
  }
}
