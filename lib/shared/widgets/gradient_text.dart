import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

class GradientText extends StatelessWidget {
  const GradientText({
    required this.text,
    this.routeNameToMoveTo,
    super.key,
    this.onTap,
    this.fontSize,
    this.fontWeight,
  });
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? routeNameToMoveTo;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: InkWell(
        onTap:
            routeNameToMoveTo != null
                ? () {
                  Navigator.pushNamed(context, routeNameToMoveTo!);
                }
                : onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? paragraphText,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
