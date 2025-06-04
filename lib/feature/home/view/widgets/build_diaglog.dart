import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/home/view/widgets/build_ride_request.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/show_custom_modal.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../rides/cubit/ride/ride_state.dart';

Future<void> buildRideFoundDialog(BuildContext context) {
  return showCustomModal(
    padding: EdgeInsets.all(smallWhiteSpace),
    context,
    child: RideFoundModal(),
  ).show();
}

class RideFoundModal extends StatefulWidget {
  const RideFoundModal({super.key});

  @override
  State<RideFoundModal> createState() => _RideFoundModalState();
}

class _RideFoundModalState extends State<RideFoundModal> {
  TextEditingController reasonController = TextEditingController();
  @override
  void initState() {
    reasonController.text = "Too far from my current location";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        final ride = state is RideLoaded ? state.ride : null;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Ride Request!',
                  style: TextStyle(
                    fontSize: normalText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RideTypeChip(),
              ],
            ),
            const VSpace(smallWhiteSpace),
            buildCustomerDetail(context, ride),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SimpleButton(
                    title: 'Decline',
                    onPressed: () {
                      showCustomModal(
                        context,
                        btnCancelOnPress: () {},
                        btnCancelText: "Back",
                        btnOkText: "Decline",
                        btnOkOnPress: () {
                          Navigator.of(context).pop();
                          context.read<RideCubit>().rejectRide(
                            context,
                            reason: reasonController.text.trim(),
                          );
                        },
                        child: buildField(
                          "Say reasons for declining",
                          reasonController,
                        ),
                      ).show();
                    },
                  ),
                ),
                const HSpace(extraSmallWhiteSpace),
                Expanded(
                  child: SimpleButton(
                    title: 'Accept',
                    onPressed: () {
                      context.read<RideCubit>().acceptRide(context);
                      Navigator.of(context).pop();
                    },
                    backgroundColor: thickFillColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class RideTypeChip extends StatelessWidget {
  const RideTypeChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 9.08, vertical: 3.03),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.20999999344348907),
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
    );
  }
}
