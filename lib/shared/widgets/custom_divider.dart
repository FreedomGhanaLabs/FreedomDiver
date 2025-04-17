import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.height = 2})
      : assert(
          height > 0,
          'height must be greater than 0',
        );
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 424,
      height: height,
      decoration: const BoxDecoration(color: Color(0x72D9D9D9)),
    );
  }
}
