import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FreedomButton extends StatelessWidget {
  const FreedomButton({
    Key? key,
    required this.onPressed,
    this.borderRadius,
    this.width,
    this.height = 57.0,
    this.title = '',
    this.useGradient = false,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
    this.leadingIcon = '',
    this.icon,
    this.backGroundColor,
    this.titleColor,
    this.fontSize,
    this.useLoader,
    this.child,
    this.useOnlBorderGradient = false,
    this.buttonTitle,
  }) : super(key: key);

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final String title;
  final bool useGradient;
  final String leadingIcon;
  final IconData? icon;
  final Color? backGroundColor;
  final Color? titleColor;
  final double? fontSize;
  final bool? useLoader;
  final Widget? child;
  final bool useOnlBorderGradient;
  final Widget? buttonTitle;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(13);
    final effectiveTextColor =
        useGradient ? Colors.white : (titleColor ?? Colors.white);

    return Container(
      width: width,
      height: height,
      decoration: useGradient
          ? BoxDecoration(
              gradient: useOnlBorderGradient ? null : gradient,
              borderRadius: borderRadius,
              border: useOnlBorderGradient
                  ? const GradientBoxBorder(
                      gradient: LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xffE61D2A)]),
                    )
                  : null,
            )
          : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: useGradient ? Colors.transparent : backGroundColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: useLoader == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize ?? 17.41,
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(height: 20, width: 20, child: child),
                ],
              )
            : Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon.isNotEmpty)
                      SvgPicture.asset('assets/app_icons/$leadingIcon.svg'),
                    if (leadingIcon.isNotEmpty) const SizedBox(width: 8),
                    FittedBox(child: buttonTitle),
                  ],
                ),
              ),
      ),
    );
  }
}
