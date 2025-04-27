import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/copy_to_clipboard.dart';
import 'package:freedom_driver/utilities/responsive.dart';
import 'package:freedom_driver/utilities/ui.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final driver = state is DriverLoaded ? state.driver : null;
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(roundedMd),
              ),
              height: 200,
              width: Responsive.isMobile(context)
                  ? 350
                  : Responsive.width(context) - 45,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 6, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '10 Ride Completed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: extraSmallText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Reward',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: extraSmallText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppIcon(iconName: 'arrow_right_icon'),
                  ],
                ),
              ),
            ),
            Positioned(
              top: whiteSpace,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  image: const DecorationImage(
                    image: AssetImage('assets/app_images/profile_hbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 187,
                width: Responsive.isMobile(context)
                    ? 375
                    : Responsive.width(context) - 20,
                child: Column(
                  children: [
                    const VSpace(smallWhiteSpace),
                    Container(
                      // width: 67,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/app_images/user_profile.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            bottom: -2,
                            right: -8,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                ),
                              ),
                              child: const AppIcon(iconName: 'edit_profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VSpace(2),
                    Text(
                      driver?.fullName ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: smallText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const VSpace(smallWhiteSpace),
                    Container(
                      width: 132,
                      height: 24,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withValues(alpha: 0.34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            copyTextToClipboard(context, driver?.phone ?? ''),
                        child: Row(
                          children: [
                            const AppIcon(iconName: 'copy_button_icon'),
                            const HSpace(7),
                            Text(
                              driver?.phone ?? driver?.email ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
