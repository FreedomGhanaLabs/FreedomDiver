import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.iconName,
    super.key,
    this.colorFilter,
    this.size,
    this.height,
    this.width,
    this.padding,
  });
  final String iconName;
  final ColorFilter? colorFilter;
  final double? size;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SvgPicture.asset(
        'assets/app_icons/$iconName.svg',
        colorFilter: colorFilter,
        height: height ?? size,
        width: width ?? size,
      ),
    );
  }
}
