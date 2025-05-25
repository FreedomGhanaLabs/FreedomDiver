import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/kyc/view/vehicle_details_screen.dart';
import 'package:freedomdriver/feature/profile/view/availability_dashboard.dart';
import 'package:freedomdriver/feature/profile/view/document_management_screen.dart';
import 'package:freedomdriver/feature/profile/view/profile_details.dart';
import 'package:freedomdriver/feature/profile/widget/stacked_profile_card.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/show_dialog.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../shared/api/api_controller.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../utilities/hive/token.dart';
import '../../authentication/login/view/login_form_screen.dart';
import 'debt_management_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.hasBackButton = false});
  static const routeName = '/profile-screen';
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
                      Navigator.of(
                        context,
                      ).pushNamed(DocumentManagementScreen.routeName);
                    },
                    onDebtTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(DebtManagementScreen.routeName);
                    },
                  ),
                  MoreSection(
                    onTapAddress: () {
                      Navigator.of(
                        context,
                      ).pushNamed(VehicleDetailsScreen.routeName);
                    },
                    onTapSecurity: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AvailabilityDashboard.routeName);
                    },
                    onTapLogout:
                        () => showAlertDialog(
                          context,
                          'Logout',
                          'Are you sure you want to logout?',
                          buttonText: 'Continue',
                          titleColor: gradient2,
                          okButtonColor: gradient2,
                          hasSecondaryButton: true,
                          onPressed: () {
                            final apiController = ApiController('auth');

                            apiController.post(context, 'logout', {}, (
                              success,
                              responseData,
                            ) {
                              if (success) {
                                deleteTokenToHive().then((onValue) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginFormScreen.routeName,
                                    (route) => false,
                                  );
                                });
                              }
                            }, showOverlay: true);
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
        top: MediaQuery.of(context).padding.top + extraSmallWhiteSpace,
        bottom: extraSmallWhiteSpace,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (hasBackButton)
            const DecoratedBackButton()
          else
            const SizedBox(width: smallWhiteSpace),
          Expanded(
            child: Text(
              title?.capitalize ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: normalText.sp,
                fontWeight: FontWeight.w600,
              ),
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
