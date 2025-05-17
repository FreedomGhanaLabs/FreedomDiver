import 'package:flutter/material.dart';
import 'package:freedomdriver/utilities/responsive.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.height = 2, this.width})
      : assert(
          height > 0,
          'height must be greater than 0',
        );
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Responsive.width(context),
      height: height,
      decoration: const BoxDecoration(color: Color(0x72D9D9D9)),
    );
  }
}
