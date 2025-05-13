import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/feature/home/view/widgets/build_ride_request.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/feature/rides/cubit/ride/rides_cubit.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';

Future<void> buildRideFoundDialog(BuildContext context) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return SizedBox(
        width: double.infinity,
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(roundedLg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Ride Request!',
                      style: TextStyle(
                        fontSize: normalText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9.08,
                        vertical: 3.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black
                              .withValues(alpha: 0.20999999344348907),
                        ),
                        borderRadius: BorderRadius.circular(8.08),
                      ),
                      child: Center(
                        child: Text(
                          'Rider',
                          style: TextStyle(
                            fontSize: normalText,
                            fontWeight: FontWeight.w500,
                            color: darkGoldColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(18.47),
              ...buildCustomerDetail(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SimpleButton(
                      title: 'Decline',
                      onPressed: () {
                        context
                            .read<RideCubit>()
                            .rejectRide(context, rideId: 'xyz-abcd');
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(6.90),
                      backgroundColor: colorBlack,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.51,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9.5,
                      ),
                    ),
                  ),
                  const HSpace(20),
                  Expanded(
                    child: SimpleButton(
                      title: 'Accept',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      onPressed: () {
                        context
                            .read<HomeCubit>()
                            .setRideAccepted(isAccepted: true);
                        Navigator.of(context).pop();
                      },
                      backgroundColor: thickFillColor,
                      borderRadius: BorderRadius.circular(6.90),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
