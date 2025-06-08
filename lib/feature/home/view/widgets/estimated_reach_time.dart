import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/constants/ride.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_indicator.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/gradient_text.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../rides/cubit/ride/ride_state.dart';

class EstimatedReachTime extends StatelessWidget {
  const EstimatedReachTime({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        final ride = state is RideLoaded ? state.ride : null;

        final isArrived = ride?.status == acceptedRide;

        String? getTimeText(bool toPickup) =>
            (toPickup ? ride?.etaToPickup?.text : ride?.etaToDropoff?.text)
                ?.toString();

        String timeText = getTimeText(isArrived) ?? "0 min";
        final parts = timeText.split(" ");
        final time = parts.isNotEmpty ? parts[0] : "0";
        final unit = parts.length > 1 ? parts[1] : "min";
        final location = isArrived ? "pickup" : "dropoff";

        return Column(
          children: [
            Row(
              children: [
                GradientText(
                  text: time,
                  fontSize: emphasisText,
                  fontWeight: FontWeight.bold,
                ),
                const HSpace(3),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: paragraphText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const HSpace(extraSmallWhiteSpace),
                Text(
                  'until you reach $location location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: smallText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            RiderProgressTracker(
              currentMinutes: 0,
              totalMinutes: int.tryParse(time) ?? 0,
            ),
          ],
        );
      },
    );
  }
}
