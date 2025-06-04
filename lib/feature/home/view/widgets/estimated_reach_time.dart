import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_indicator.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/gradient_text.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../rides/cubit/ride/ride_state.dart';

class EstimatedReachTime extends StatefulWidget {
  const EstimatedReachTime({super.key});

  @override
  State<EstimatedReachTime> createState() => _EstimatedReachTimeState();
}

class _EstimatedReachTimeState extends State<EstimatedReachTime> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        final ride = state is RideLoaded ? state.ride : null;

        final totalMinutes = ride?.etaToPickup?.value ?? 0;
        return Column(
          children: [
            Row(
              children: [
                GradientText(
                  text: ride?.etaToPickup?.value.toString() ?? "0",
                  fontSize: emphasisText,
                  fontWeight: FontWeight.bold,
                ),
                const HSpace(3.1),
                Text(
                  ride?.etaToPickup?.text.toString() ?? 'mins',
                  style: TextStyle(
                    fontSize: paragraphText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const HSpace(medWhiteSpace),
                Text(
                  'until you reach pickup location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: smallText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            RiderProgressTracker(currentMinutes: 0, totalMinutes: totalMinutes),
          ],
        );
      },
    );
  }
}
