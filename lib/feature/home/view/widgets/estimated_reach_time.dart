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

        final isAccepted = ride?.status == "accepted";

        final etaToPickup = ride?.etaToPickup;
        final etaToDestination = ride?.estimatedDuration?.text;
        final destinationTime = etaToDestination.toString().split(" ")[0];
        final destinationUnit = etaToDestination.toString().split(" ")[1];
        final pickUpTime = etaToPickup?.text.toString().split(" ")[0];
        final pickUpUnit = etaToPickup?.text.toString().split(" ")[1] ?? "";
        final time = isAccepted ? pickUpTime : destinationTime;
        final unit = isAccepted ? pickUpUnit : destinationUnit;
        return Column(
          children: [
            Row(
              children: [
                GradientText(
                  text: time ?? "0",
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
                  'until you reach ${isAccepted ? "pickup location" : "your destination"}',
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
              totalMinutes: int.tryParse(time ?? "") ?? 0,
            ),
          ],
        );
      },
    );
  }
}
