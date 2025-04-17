import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({required this.iconName, super.key});
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/app_icons/$iconName.svg',
    );
  }
}
