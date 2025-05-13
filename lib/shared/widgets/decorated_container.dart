import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/app_config.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(smallWhiteSpace),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(119, 119, 119, 0.08),
        borderRadius: BorderRadius.circular(roundedMd),
      ),
      child: child,
    );
  }
}
