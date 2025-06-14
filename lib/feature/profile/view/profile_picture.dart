import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/profile/view/profile_details.dart';
import 'package:freedomdriver/feature/profile/widget/stacked_profile_card.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_divider.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/utilities/copy_to_clipboard.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/utils.dart';

import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});
  static const String routeName = '/profile-picture';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final driver = (state is DriverLoaded) ? state.driver : null;
        return CustomScreen(
          title: driver?.fullName ?? '',
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.pushNamed(context, ProfileDetails.routeName),
              child: Text(
                'Edit',
                style: paragraphTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          children: [
            DriverProfileImage(size: Responsive.width(context)),
            const VSpace(smallWhiteSpace),
            Row(
              children: [
                Text('Profile Information', style: normalTextStyle),
                const HSpace(smallWhiteSpace),
                const Expanded(child: CustomDivider()),
                const HSpace(smallWhiteSpace),
                DecoratedContainer(
                  backgroundColor: Colors.black,
                  child: Column(
                    children: [
                      Text('Profile Rating', style: descriptionTextStyle),
                      Text(
                        driver?.ratings.toString() ?? '',
                        style: normalTextStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace(smallWhiteSpace),
            DecoratedContainer(
              child: Column(
                children: [
                  ProfilePictureTile(
                    leading: 'Full Name',
                    trailing: driver?.fullName.capitalize,
                  ),
                  ProfilePictureTile(leading: 'Email', trailing: driver?.email),
                  ProfilePictureTile(
                    leading: 'Phone Number',
                    trailing: driver?.phone,
                  ),
                  ProfilePictureTile(
                    leading: 'Personal Address',
                    trailing: driver?.address.street.capitalize,
                  ),
                  ProfilePictureTile(
                    leading: 'Ride Status',
                    trailing: driver?.status?.capitalize,
                  ),
                  ProfilePictureTile(
                    leading: 'Ride Preference',
                    trailing:
                        (driver?.ridePreference
                            .replaceAll('normal', 'Ride only')
                            .replaceAll('both', 'Ride, Delivery'))?.capitalize,
                  ),

                  ProfilePictureTile(
                    leading: 'License Number',
                    trailing: driver?.licenseNumber,
                  ),
                  ProfilePictureTile(
                    leading: 'Motorcycle Number',
                    trailing: driver?.motorcycleNumber,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfilePictureTile extends StatelessWidget {
  const ProfilePictureTile({
    super.key,
    this.leading,
    this.trailing,
    this.isLast = false,
  });

  final String? leading;
  final String? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(),
          leading: Text(leading?.capitalize ?? '', style: descriptionTextStyle),
          trailing: SelectableText(
            trailing ?? 'N/A',
            onTap:
                () => copyTextToClipboard(
                  context,
                  trailing ?? '',
                  copyText: leading,
                ),
            style: paragraphTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        if (!isLast) const CustomDivider(),
      ],
    );
  }
}
