import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedom_driver/feature/earnings/cubit/earnings_state.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/utilities/ui.dart';

class DriverTotalScore extends StatelessWidget {
  const DriverTotalScore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, state) {
        final earning = state is EarningLoaded ? state.earning : null;
        return Container(
          padding: const EdgeInsets.only(
            left: smallWhiteSpace,
            top: 9,
            bottom: 10,
            right: whiteSpace,
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(roundedLg),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Score',
                style: TextStyle(
                  fontSize: normalText,
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                  letterSpacing: -0.45,
                ),
              ),
              const VSpace(extraSmallWhiteSpace),
              Row(
                children: [
                  const AppIcon(iconName: 'driver_score_icon'),
                  const HSpace(10),
                  Text(
                    '${earning?.totalRideFares ?? 0}',
                    style: const TextStyle(
                      fontSize: headingText,
                      fontWeight: FontWeight.w600,
                      height: 1.29,
                      letterSpacing: -0.40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

