import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/utilities/ui.dart';

import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_state.dart';

class DriverTotalOrder extends StatelessWidget {
  const DriverTotalOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
      builder: (context, state) {
        final finance = state is FinancialLoaded ? state.finance : null;
        return Container(
          padding: const EdgeInsets.only(
            left: smallWhiteSpace,
            top: 9,
            bottom: 10,
            right: whiteSpace,
          ),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.119),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Rides',
                style: TextStyle(
                  fontSize: normalText,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const VSpace(extraSmallWhiteSpace),
              Text(
                '${finance?.rideCount ?? 0}',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: headingText,
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.40,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
