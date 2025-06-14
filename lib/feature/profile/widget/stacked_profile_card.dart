import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_state.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/copy_to_clipboard.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/utilities/pick_file.dart';
import 'package:freedomdriver/feature/main_activity/cubit/main_activity_cubit.dart';
import 'package:freedomdriver/feature/profile/view/profile_picture.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  void _navigateToIndex(BuildContext context, int index) {
    context.read<MainActivityCubit>().changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _buildBackgroundCard(),
        Positioned(top: whiteSpace, child: _buildProfileContent()),
      ],
    );
  }

  Widget _buildBackgroundCard() {
    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, state) {
        final completedRides =
            (state is EarningLoaded) ? state.earning.completedRides : 0;
        return Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(roundedLg),
          ),
          height: 200,
          width:
              Responsive.isBigMobile(context)
                  ? 350
                  : Responsive.width(context) - 50,
          padding: const EdgeInsets.only(
            left: medWhiteSpace,
            top: extraSmallWhiteSpace,
            right: medWhiteSpace,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileStatLink(
                text:
                    '$completedRides Ride${completedRides <= 1 ? '' : 's'} Completed',
                onTap: () => _navigateToIndex(context, 2),
              ),
              const Spacer(),
              ProfileStatLink(
                text: 'Reward',
                icon: 'arrow_right_icon',
                onTap: () => _navigateToIndex(context, 1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileContent() {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final name = context.driver?.fullName ?? '';
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(roundedLg),
            image: const DecorationImage(
              image: AssetImage('assets/app_images/profile_hbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          height: 187,
          width:
              Responsive.isBigMobile(context)
                  ? 375
                  : Responsive.width(context) - 20,
          child: Column(
            children: [
              const VSpace(smallWhiteSpace),
              const ProfileAvatar(),
              const VSpace(medWhiteSpace),
              ProfileTitleText(name),
              const VSpace(medWhiteSpace),
              const DriverContactInfo(),
              const VSpace(2),
              const Text(
                'Business Suite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: smallText,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileStatLink extends StatelessWidget {

  const ProfileStatLink({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });
  final String text;
  final VoidCallback onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: extraSmallText,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            AppIcon(iconName: icon!, height: 12),
          ],
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const DriverProfileImage(),
        Positioned(
          bottom: -4,
          right: -4,
          child: InkWell(
            onTap:
                () => pickFile(
                  context,
                  type: profileImage,
                  title: 'Update Profile Picture',
                  description:
                      'Select a new photo to refresh your profile image',
                ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 2),
              ),
              child: const AppIcon(iconName: 'edit_profile'),
            ),
          ),
        ),
      ],
    );
  }
}

class DriverProfileImage extends StatelessWidget {
  const DriverProfileImage({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final driver = context.driver;
    return Container(
      height: size ?? 50,
      width: size ?? 50,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(roundedLg),
        child:
            driver?.profilePicture != null
                ? GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        ProfilePictureScreen.routeName,
                      ),
                  child: Hero(
                    tag: driver?.id ?? '',
                    transitionOnUserGestures: true,
                    child: CachedNetworkImage(
                      imageUrl: driver?.profilePicture ?? '',
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, url, error) => const DefaultAvatar(),
                      placeholder: (context, url) => const DefaultAvatar(),
                    ),
                  ),
                )
                : const DefaultAvatar(),
      ),
    );
  }
}

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/app_images/user_profile.png', fit: BoxFit.fill);
  }
}

class DriverContactInfo extends StatelessWidget {
  const DriverContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneOrEmail = context.driver?.phone ?? context.driver?.email ?? '';

    return Container(
      width: 135,
      height: 24,
      padding: const EdgeInsets.only(left: medWhiteSpace),
      decoration: ShapeDecoration(
        color: Colors.white.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedXl),
        ),
      ),
      child: GestureDetector(
        onTap: () => copyTextToClipboard(context, phoneOrEmail),
        child: Row(
          children: [
            const AppIcon(iconName: 'copy_button_icon'),
            const HSpace(extraSmallWhiteSpace),
            Text(
              phoneOrEmail,
              style: const TextStyle(
                color: Colors.white,
                fontSize: extraSmallText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTitleText extends StatelessWidget {
  const ProfileTitleText(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: smallText,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
