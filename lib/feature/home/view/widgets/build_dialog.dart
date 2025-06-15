import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/home/view/inappcall_map.dart';
import 'package:freedomdriver/feature/home/view/widgets/home_widgets.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';

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

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  bool isDeclining = false;
  double _offsetX = 0.0;
  double _scale = 1.0;
  bool _isDismissing = false;

  static const double _slideDismissThreshold = 120.0;
  static const double _pinchDismissThreshold = 0.7;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() => _offsetX += details.delta.dx);
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_offsetX.abs() > _slideDismissThreshold) {
      _dismissDialog();
    } else {
      setState(() => _offsetX = 0.0);
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() => _scale = details.scale);
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_scale < _pinchDismissThreshold) {
      _dismissDialog();
    } else {
      setState(() => _scale = 1.0);
    }
  }

  void _dismissDialog() {
    if (_isDismissing) return;
    _isDismissing = true;
    widget.onDismiss();
  }

  Widget _buildDialogContent(BuildContext context, RideState state) {
    final ride = state is RideLoaded ? state.ride : null;

    if (ride == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogHeader(context, ride),
          const VSpace(extraSmallWhiteSpace),
          Text(
            'No ride/delivery request yet...',
            style: paragraphTextStyle.copyWith(color: Colors.grey.shade500),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDialogHeader(context, ride),
        const VSpace(smallWhiteSpace),
        buildCustomerDetail(context, ride),
        if (isDeclining)
          buildField('Say reasons for declining', reasonController),
        Row(
          children: [
            Expanded(
              child: SimpleButton(
                title: 'Decline',
                onPressed: () => _onDeclinePressed(context),
              ),
            ),
            const HSpace(extraSmallWhiteSpace),
            Expanded(
              child: SimpleButton(
                title: 'Accept',
                onPressed: () => context.read<RideCubit>().acceptRide(context),
                backgroundColor: thickFillColor,
              ),
            ),
          ],
        ),
        SimpleButton(
          title: 'Clear ${ride.type.capitalize} Request',
          onPressed: () => context.read<RideCubit>().resetRideRequest(),
          backgroundColor: gradient2,
        ),
      ],
    );
  }

  Widget _buildDialogHeader(BuildContext context, dynamic ride) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ride == null ? 'Ride Request' : 'New ${ride.type} request!',
          style: const TextStyle(
            fontSize: paragraphText,
            fontWeight: FontWeight.bold,
          ),
        ),
    
        Row(
          children: [
            if (ride != null)
              OutlinedContainer(
                rideType: ride?.type == 'delivery' ? 'Dispatch' : 'Rider',
              ),
            const HSpace(extraSmallWhiteSpace),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.dismissRideDialog(),
              icon: const Icon(Icons.cancel),
              tooltip: 'Close dialog',
            ),
          ],
        ),
      ],
    );
  }

  void _onDeclinePressed(BuildContext context) {
    if (isDeclining) {
      context.read<RideCubit>().rejectRide(
        context,
        reason: reasonController.text.trim(),
      );
      setState(() => isDeclining = false);
    } else {
      setState(() => isDeclining = true);
    }
  }

  double _dialogWidth(BuildContext context) {
    if (Responsive.isTablet(context)) {
      return tabletWidth - whiteSpace;
    } else if (Responsive.isBigMobile(context)) {
      return Responsive.width(context) * 0.85;
    } else {
      return Responsive.width(context) * 0.9;
    }
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
                  child: GestureDetector(
                    onHorizontalDragUpdate: _handleHorizontalDragUpdate,
                    onHorizontalDragEnd: _handleHorizontalDragEnd,
                    onScaleUpdate: _handleScaleUpdate,
                    onScaleEnd: _handleScaleEnd,
                    child: Transform.translate(
                      offset: Offset(_offsetX, 0),
                      child: Transform.scale(
                        scale: _scale,
                        child: Container(
                          width: _dialogWidth(context),
                          padding: const EdgeInsets.all(smallWhiteSpace),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(medWhiteSpace),
                          ),
                          child: BlocBuilder<RideCubit, RideState>(
                            builder: _buildDialogContent,
                          ),
                        ),
                      ),
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

extension RideDialogExtension on BuildContext {
  void showRideDialog() => CustomRideDialog.show(context: this);
  void dismissRideDialog() => CustomRideDialog.dismiss();
}
