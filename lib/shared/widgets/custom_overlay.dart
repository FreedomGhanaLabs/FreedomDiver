import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/ui.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({
    super.key,
    this.text,
  });
  final String? text;

  @override
  State<CustomLoader> createState() => CustomLoaderState();
}

class CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Durations.extralong4,
    lowerBound: 0.95,
    upperBound: 1.05,
  )..repeat(reverse: true);

  String text = '';

  @override
  void initState() {
    Future.delayed(Durations.long4, () {
      if (mounted) {
        setState(() {
          text = widget.text ?? 'We are customizing your Experience';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(whiteSpace),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: controller,
              child: AppIcon(iconName: 'location_duotone', height: 120.sp),
            ),
            const VSpace(smallWhiteSpace),
            Text(
              text,
              style: paragraphTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
