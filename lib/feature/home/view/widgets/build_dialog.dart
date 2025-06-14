import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/home/view/widgets/home_widgets.dart';

class CustomRideDialog {
  factory CustomRideDialog() => _instance;
  CustomRideDialog._internal();
  static final CustomRideDialog _instance = CustomRideDialog._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    double verticalPadding = whiteSpace,
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
  const _RideDialogWidget({
    required this.onDismiss,
    required this.verticalPadding,
  });
  final VoidCallback onDismiss;
  final double verticalPadding;

  @override
  State<_RideDialogWidget> createState() => _RideDialogWidgetState();
}

class _RideDialogWidgetState extends State<_RideDialogWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController reasonController = TextEditingController(
    text: 'Too far from my current location',
  );

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool isDeclining = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Material(
          color: Colors.black.withValues(alpha: 0.35),
          child: Padding(
            padding: EdgeInsets.all(widget.verticalPadding),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width:
                        Responsive.isTablet(context)
                            ? tabletWidth - whiteSpace
                            : Responsive.isBigMobile(context)
                            ? Responsive.width(context) * 0.85
                            : Responsive.width(context) * 0.9,
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
                              children: [
                                Text(
                                  ride == null
                                      ? 'Ride Request'
                                      : 'New Ride Request!',
                                  style: const TextStyle(
                                    fontSize: normalText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const RideTypeChip(),
                                    const HSpace(extraSmallWhiteSpace),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed:
                                          () => context.dismissRideDialog(),
                                      icon: const Icon(Icons.cancel),
                                      tooltip: 'Close dialog',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const VSpace(smallWhiteSpace),
                            
                            if (ride != null) ...[
                              buildCustomerDetail(context, ride),
                              if (isDeclining)
                                buildField(
                                  'Say reasons for declining',
                                  reasonController,
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SimpleButton(
                                      title: 'Decline',
                                      onPressed: () {
                                        if (isDeclining) {
                                          context.read<RideCubit>().rejectRide(
                                            context,
                                            reason:
                                                reasonController.text.trim(),
                                          );
                                          setState(() {
                                            isDeclining = false;
                                          });
                                          return;
                                        }
                                        setState(() {
                                          isDeclining = true;
                                        });
                                      },
                                    ),
                                  ),
                                  const HSpace(extraSmallWhiteSpace),
                                  Expanded(
                                    child: SimpleButton(
                                      title: 'Accept',
                                      onPressed: () {
                                        context.read<RideCubit>().acceptRide(
                                          context,
                                        );
                                      },
                                      backgroundColor: thickFillColor,
                                    ),
                                  ),
                                ],
                              ),
                            ] else
                              Text(
                                'No ride request yet...',
                                style: paragraphTextStyle,
                              )
                             
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RideTypeChip extends StatelessWidget {
  const RideTypeChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: medWhiteSpace),
      height: 30,
      padding: const EdgeInsets.symmetric(
        horizontal: medWhiteSpace,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(roundedMd),
      ),
      child: Center(
        child: Text(
          'Rider',
          style: TextStyle(
            fontSize: paragraphText,
            fontWeight: FontWeight.w400,
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
