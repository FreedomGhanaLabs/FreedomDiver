import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';

class SecurityAndPrivacy extends StatefulWidget {
  const SecurityAndPrivacy({super.key});
  static const routeName = '/security_privacy';

  @override
  State<SecurityAndPrivacy> createState() => _SecurityAndPrivacy();
}

class _SecurityAndPrivacy extends State<SecurityAndPrivacy> {
  final vehicleColor = TextEditingController();
  final vehicleMakeAndModel = TextEditingController();
  final vehicleLicensePlate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Security and privacy',
      bodyHeader: 'Secure your account',
      children: [SecurityAndPrivacySection(padding: EdgeInsets.zero)],
    );
  }
}
