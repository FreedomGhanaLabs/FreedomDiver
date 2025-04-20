import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/earnings/widgets/utility.dart';
import 'package:freedom_driver/feature/profile/view/availability_dashboard.dart';
import 'package:freedom_driver/feature/profile/view/document_management_screen.dart';
import 'package:freedom_driver/feature/profile/view/profile_details.dart';
import 'package:freedom_driver/feature/profile/widget/stacked_profile_card.dart';
import 'package:freedom_driver/utilities/ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.32;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const DecoratedBackButton(),
                  HSpace(size),
                  const Center(child: Text('Profile')),
                ],
              ),
            ),
            const VSpace(22),
            const ProfileCard(),
            const VSpace(14),
            Container(
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFFF1F1F1)),
            ),
            const VSpace(22),
            PersonalDataSection(
              onProfileTap: () {
                Navigator.pushNamed(context, ProfileDetails.routeName);
              },
              onWalletTap: () {
                Navigator.of(context)
                    .pushNamed(DocumentManagementScreen.routeName);
              },
            ),
            MoreSection(
              onTapAddress: () {},
              onTapSecurity: () {
                Navigator.of(context)
                    .pushNamed(AvailabilityDashboard.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
