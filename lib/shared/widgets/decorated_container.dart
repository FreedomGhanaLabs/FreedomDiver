import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({
    super.key,
    this.child,
    this.margin,
    this.backgroundImage,
    this.backgroundColor,
  });
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(smallWhiteSpace),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromRGBO(119, 119, 119, 0.08),
        borderRadius: BorderRadius.circular(roundedMd),
        image:
            backgroundImage != null
                ? DecorationImage(image: backgroundImage!, fit: BoxFit.fill)
                : null,
      ),
      child: child,
    );
  }
}
