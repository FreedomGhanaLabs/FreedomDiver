import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/copy_to_clipboard.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, earningState) {
        final earning =
            earningState is EarningLoaded ? earningState.earning : null;

        final completedRides = earning?.completedRides ?? 0;
        return BlocBuilder<DriverCubit, DriverState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(roundedLg),
                  ),
                  height: 200,
                  width:
                      Responsive.isBigMobile(context)
                          ? 350
                          : Responsive.width(context) - 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 6, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$completedRides Ride${completedRides <= 1 ? '' : 's'} Completed',
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
                              const SizedBox(
                                height: 50,
                                width: 50,
                                child: Image(
                                  image: AssetImage(
                                    'assets/app_images/user_profile.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                bottom: -2,
                                right: -8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(width: 2),
                                  ),
                                  child: const AppIcon(
                                    iconName: 'edit_profile',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VSpace(2),
                        Text(
                          context.driver?.fullName ?? '',
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
                            onTap:
                                () => copyTextToClipboard(
                                  context,
                                  context.driver?.phone ?? '',
                                ),
                            child: Row(
                              children: [
                                const AppIcon(iconName: 'copy_button_icon'),
                                const HSpace(7),
                                Text(
                                  context.driver?.phone ??
                                      context.driver?.email ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: extraSmallText,
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
      },
    );
  }
}
