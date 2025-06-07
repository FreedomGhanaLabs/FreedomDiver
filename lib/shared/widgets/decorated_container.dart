import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({super.key, this.child, this.margin});
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(smallWhiteSpace),
      margin: margin,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(119, 119, 119, 0.08),
        borderRadius: BorderRadius.circular(roundedMd),
      ),
      child: child,
    );
  }
}
