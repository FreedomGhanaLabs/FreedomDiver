import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../documents/driver_license/view/license_form.dart';
import '../../../kyc/view/background_verification_screen.dart';
import 'home_widgets.dart';

class CustomRideDialog {
  factory CustomRideDialog() => _instance;
  CustomRideDialog._internal();
  static final CustomRideDialog _instance = CustomRideDialog._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    double verticalPadding = 24.0,
  }) {
    if (_isVisible) return;

    _overlayEntry = OverlayEntry(
      builder:
          (_) => _RideDialogWidget(
            onDismiss: dismiss,
            verticalPadding: verticalPadding,
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }

  static void dismiss() {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}

class _RideDialogWidget extends StatefulWidget {
  final VoidCallback onDismiss;
  final double verticalPadding;
  const _RideDialogWidget({
    required this.onDismiss,
    required this.verticalPadding,
  });

  @override
  State<_RideDialogWidget> createState() => _RideDialogWidgetState();
}

class _RideDialogWidgetState extends State<_RideDialogWidget> {
  final TextEditingController reasonController = TextEditingController(
    text: "Too far from my current location",
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Material(
          color: Colors.black.withValues(alpha: 0.5),
          child: Padding(
            padding: EdgeInsets.all(widget.verticalPadding),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(smallWhiteSpace),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(medWhiteSpace),
                ),
                child: BlocBuilder<RideCubit, RideState>(
                  builder: (context, state) {
                    final ride = state is RideLoaded ? state.ride : null;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
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
                          children: [
                            Expanded(
                              child: SimpleButton(
                                title: 'Decline',
                                onPressed: () {
                                  CustomRideDialog.dismiss();
                                  _showDeclineReason(context);
                                },
                              ),
                            ),
                            const HSpace(extraSmallWhiteSpace),
                            Expanded(
                              child: SimpleButton(
                                title: 'Accept',
                                onPressed: () {
                                  context.read<RideCubit>().acceptRide(context);
                                  CustomRideDialog.dismiss();
                                },
                                backgroundColor: thickFillColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeclineReason(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Decline Ride"),
            content: buildField("Say reasons for declining", reasonController),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<RideCubit>().rejectRide(
                    context,
                    reason: reasonController.text.trim(),
                  );
                },
                child: const Text("Decline"),
              ),
            ],
          ),
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
        border: Border.all(color: Colors.black.withOpacity(0.21)),
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

extension RideDialogExtension on BuildContext {
  void showRideDialog() {
    CustomRideDialog.show(context: this);
  }

  void dismissRideDialog() {
    CustomRideDialog.dismiss();
  }
}
