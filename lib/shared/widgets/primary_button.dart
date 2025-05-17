import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FreedomButton extends StatelessWidget {
  const FreedomButton({
    required this.onPressed,
    super.key,
    this.borderRadius,
    this.width,
    this.height,
    this.title = '',
    this.useGradient = false,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
    this.leadingIcon = '',
    this.icon,
    this.backGroundColor,
    this.titleColor,
    this.fontSize,
    this.useLoader = false,
    this.child,
    this.useOnlBorderGradient = false,
    this.buttonTitle,
    this.disabled = false,
  });

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final String title;
  final bool useGradient;
  final String leadingIcon;
  final IconData? icon;
  final Color? backGroundColor;
  final Color? titleColor;
  final double? fontSize;
  final bool useLoader;
  final Widget? child;
  final bool useOnlBorderGradient;
  final Widget? buttonTitle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(roundedLg);
    final effectiveTextColor = useOnlBorderGradient
        ? titleColor
        :
        useGradient ? Colors.white : (titleColor ?? Colors.white);

    return Container(
      width: width ??
          (Responsive.isBigMobile(context) ? 375 : Responsive.width(context)),
      height: height ?? 50.0.sp,
      decoration: useGradient
          ? BoxDecoration(
              gradient: useOnlBorderGradient ? null : gradient,
              borderRadius: borderRadius,
              border: useOnlBorderGradient
                  ? GradientBoxBorder(
                      gradient: LinearGradient(colors: gradientColor),
                    )
                  : null,
            )
          : null,
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () {
                FocusScope.of(context).unfocus();
                onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: useGradient ? Colors.transparent : backGroundColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: !useLoader
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize ?? paragraphText.sp,
                      color: effectiveTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (child != null)
                    SizedBox(height: 20, width: 20, child: child),
                ],
              )
            : Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon.isNotEmpty) ...[
                      AppIcon(iconName: leadingIcon),
                      const SizedBox(width: 8),
                    ],
                    FittedBox(child: buttonTitle),
                  ],
                ),
              ),
      ),
    );
  }
}
