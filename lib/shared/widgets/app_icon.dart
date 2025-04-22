import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({required this.iconName, super.key, this.colorFilter});
  final String iconName;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/app_icons/$iconName.svg',
      colorFilter: colorFilter,
    );
  }
}
