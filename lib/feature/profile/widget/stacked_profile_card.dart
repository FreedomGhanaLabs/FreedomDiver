import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image_state.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_state.dart';
import 'package:freedomdriver/feature/profile/view/profile_image_cropper.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/copy_to_clipboard.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../utilities/pick_file.dart';
import '../../documents/cubit/document_image.dart';
import '../../main_activity/cubit/main_activity_cubit.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  void _navigateToIndex(BuildContext context, int index) {
    context.read<MainActivityCubit>().changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final imageCubit = context.watch<DriverImageCubit>();

    if (imageCubit.state is DriverImageSelected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, ProfileImageCropper.routeName);
      });
    }

    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, earningState) {
        final completedRides =
            (earningState is EarningLoaded)
                ? earningState.earning.completedRides ?? 0
                : 0;

        return BlocBuilder<DriverCubit, DriverState>(
          builder: (context, state) {
            final driver = (state is DriverLoaded) ? state.driver : null;
            final name = context.driver?.fullName ?? '';

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                _buildBackgroundCard(context, completedRides),
                Positioned(
                  top: whiteSpace,
                  child: _buildProfileContent(context, driver, name),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBackgroundCard(BuildContext context, int completedRides) {
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
      padding: EdgeInsets.only(
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
  }

  Widget _buildProfileContent(
    BuildContext context,
    dynamic driver,
    String name,
  ) {
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
          ProfileAvatar(imageUrl: driver?.profilePicture),
          const VSpace(medWhiteSpace),
          ProfileTitleText(name),
          const VSpace(medWhiteSpace),
          const DriverContactInfo(),
          VSpace(2),
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
  }
}

class ProfileStatLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String? icon;

  const ProfileStatLink({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

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
  final String? imageUrl;

  const ProfileAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(roundedLg),
            child:
                imageUrl != null
                    ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => DefaultAvatar(),
                    )
                    : DefaultAvatar(),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: InkWell(
            onTap:
                () => pickFile(
                  context,
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
      padding: const EdgeInsets.only(left: 10),
      decoration: ShapeDecoration(
        color: Colors.white.withAlpha(34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
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
  final String name;
  const ProfileTitleText(this.name, {super.key});

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
