import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/utilities/ui.dart';

class DriverTotalOrder extends StatelessWidget {
  const DriverTotalOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: smallWhiteSpace,
        top: 9,
        bottom: 13,
        right: whiteSpace,
      ),
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.119),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Total Order',
            style: TextStyle(
              fontSize: normalText,
            fontWeight: FontWeight.w400,
          ),
        ),
          VSpace(extraSmallWhiteSpace),
        Text(
          '20',
            style: TextStyle(
              color: Color(0xFFF59E0B),
              fontSize: headingText,
            fontWeight: FontWeight.w600,
            height: 1.29,
            letterSpacing: -0.40,
          ),
          ),
        ],
      ),
    );
  }
}
