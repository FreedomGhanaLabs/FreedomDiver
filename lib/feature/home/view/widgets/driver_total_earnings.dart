import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/ui.dart';


class DriverTotalEarnings extends StatelessWidget {
  const DriverTotalEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, state) {
        final earning = state is EarningLoaded ? state.earning : null;
        return Container(
          padding:
              const EdgeInsets.only(left: 19, top: 22, right: 19, bottom: 20),
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-2.6, 0.72),
              end: Alignment(0.99, 0.05),
              colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
              stops: [0.1, 0.58, 0.7],
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Colors.black.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(roundedLg),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Earning',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: paragraphText,
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                  letterSpacing: -0.41,
                ),
              ),
              5.verticalSpace,
              Text(
                '\$${earning?.totalRideEarnings.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: headingText,
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.54,
                ),
              ),
              smallWhiteSpace.verticalSpace,
              Row(
                children: [
                  const AppIcon(iconName: 'arrow_right_up'),
                  const HSpace(7),
                  SizedBox(
                    width: 90.w,
                    child: const Text(
                      '0.0% than last month',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.35,
                        fontWeight: FontWeight.w400,
                      ),
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

class TotalEarnings extends StatelessWidget {
  const TotalEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 19,
        top: 22,
      ),
      height: 149,
      width: 190,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-2.6, 0.72),
          end: Alignment(0.99, 0.05),
          colors: [Color(0x00F6AE35), Color(0xF6FBDCA7), Colors.white],
          stops: [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 102,
            child: Text(
              'Total ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            width: 102,
            child: Text(
              'Earning',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const VSpace(5),
          const Text(
            r'$0.00',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.59,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VSpace(12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_icons/arrow_right_up.svg',
              ),
              const HSpace(7),
              const Text(
                '0.0% than last month',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.35,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
