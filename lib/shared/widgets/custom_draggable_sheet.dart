import 'package:flutter/material.dart';

import 'package:freedomdriver/shared/app_config.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    required this.child,
    this.height,
    super.key,
    this.padding,
  });
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          height: height ?? 200,
          padding: padding ?? EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(roundedLg),
              topRight: Radius.circular(roundedLg),
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30)],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: child,
          ),
        );
      },
    );
  }
}
