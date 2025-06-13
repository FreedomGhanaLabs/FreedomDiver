import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/utilities/responsive.dart';

class EarningsBanner extends StatelessWidget {
  const EarningsBanner({
    required this.title,
    required this.child,
    required this.subtitle,
    required this.child2,
    super.key,
  });
  final Widget child;
  final String title;
  final String subtitle;
  final Widget child2;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(context),
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-3.3, 0.72),
          end: Alignment(0.99, 0.05),
          colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
          stops: [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.0)),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: normalText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 160,
                child: Text(
                  subtitle,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: smallText,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              child,
            ],
          ),
          const Spacer(),
          child2,
        ],
      ),
    );
  }
}
