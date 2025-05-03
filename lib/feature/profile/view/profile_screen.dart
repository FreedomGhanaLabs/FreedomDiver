import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedom_driver/feature/earnings/widgets/utility.dart';
import 'package:freedom_driver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedom_driver/feature/profile/view/availability_dashboard.dart';
import 'package:freedom_driver/feature/profile/view/document_management_screen.dart';
import 'package:freedom_driver/feature/profile/view/profile_details.dart';
import 'package:freedom_driver/feature/profile/widget/stacked_profile_card.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/show_dialog.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:get/get_utils/get_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.hasBackButton = false,
  });
  static const routeName = '/profileScreen';
  final bool hasBackButton;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: 'profile', hasBackButton: false),
          const VSpace(whiteSpace),
          const ProfileCard(),
          const VSpace(smallWhiteSpace),
          Container(
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFFF1F1F1)),
          ),
          const VSpace(whiteSpace),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    onTapAddress: () {
                      Navigator.of(context)
                          .pushNamed(VehicleDetailsScreen.routeName);
                    },
                    onTapSecurity: () {
                      Navigator.of(context)
                          .pushNamed(AvailabilityDashboard.routeName);
                    },
                    onTapLogout: () => showAlertDialog(
                      context,
                      'Logout',
                      'Are you sure you want to logout?',
                      buttonText: 'Continue',
                      titleColor: gradient2,
                      okButtonColor: gradient2,
                      hasSecondaryButton: true,
                      onPressed: () async {
                        final apiController = ApiController('auth');

                        await apiController.post(
                          context,
                          'logout',
                          {},
                          (success, responseData) {
                            if (success) {
                              deleteTokenToHive().then((onValue) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LoginFormScreen.routeName,
                                  (route) => false,
                                );
                              });
                            }
                          },
                          showOverlay: true,
                        );
                      },
                    ),
                  ),
                  const VSpace(whiteSpace),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.hasBackButton = true,
    this.actions,
  });

  final String? title;
  final bool hasBackButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(context),
      padding: EdgeInsets.only(
        left: smallWhiteSpace,
        right: smallWhiteSpace,
        top: MediaQuery.of(context).padding.top + smallWhiteSpace,
        bottom: extraSmallWhiteSpace,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (hasBackButton)
            const DecoratedBackButton()
          else
            const SizedBox(width: smallWhiteSpace),
          Text(
            title?.capitalize ?? '',
            style: TextStyle(
              fontSize: paragraphText.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actions != null)
            Row(children: actions!)
          else
            const SizedBox(width: smallWhiteSpace),
        ],
      ),
    );
  }
}
