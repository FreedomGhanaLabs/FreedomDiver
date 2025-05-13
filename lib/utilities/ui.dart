import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _Space extends StatelessWidget {
  const _Space(this.width, this.height);
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}

class VSpace extends StatelessWidget {
  const VSpace(this.size, {super.key});
  final double size;

  @override
  Widget build(BuildContext context) => _Space(0, size.h);

  static VSpace get xs => VSpace(Insets.xs);
  static VSpace get sm => VSpace(Insets.sm);
  static VSpace get md => VSpace(Insets.m);
  static VSpace get lg => VSpace(Insets.l);
  static VSpace get xl => VSpace(Insets.xl);
  static List<VSpace> get bottomOffset => [
        VSpace.xl,
        VSpace.xl,
        VSpace.xl,
      ];
}

class HSpace extends StatelessWidget {
  const HSpace(this.size, {super.key});
  final double size;

  @override
  Widget build(BuildContext context) => _Space(size, 0);

  static HSpace get xs => HSpace(Insets.xs);
  static HSpace get sm => HSpace(Insets.sm);
  static HSpace get md => HSpace(Insets.m);
  static HSpace get lg => HSpace(Insets.l);
  static HSpace get xl => HSpace(Insets.xl);
}

class Insets {
  static double gutterScale = 1;

  static double scale = 1;

  /// Dynamic insets, may get scaled with the device size
  static double get mGutter => m * gutterScale;

  static double get lGutter => l * gutterScale;

  static double get xs => 2 * scale;

  static double get sm => 6 * scale;

  static double get m => 15 * scale;

  static double get l => 24 * scale;

  static double get xl => 34 * scale;
}
