import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/widgets/home_widgets.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/api/load_dashboard.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/hive/messaging.dart';
import 'package:freedomdriver/utilities/hive/ride.dart';
import 'package:freedomdriver/utilities/socket_service.dart';
import 'package:get/get.dart';

import '../../../../core/di/locator.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  final driverLocation = getIt<DriverLocationService>();
  final ApiController apiController = ApiController('ride');
  final driverSocketService = getIt<DriverSocketService>();

  RideRequest? _cachedRideRequest;
  String? _cachedRideId;

  bool get hasAcceptedRide => _cachedRideRequest != null;

  void _updateRideRequest(
    RideRequest updated, {
    bool shouldPersist = true,
  }) async {
    _cachedRideRequest = updated;
    _cachedRideId = updated.rideId;
    emit(RideLoaded(_cachedRideRequest!));
    if (shouldPersist) {
      await addRideRequestToHive(_cachedRideRequest!);
      log("[Update ride Request] Ride request is being persisted");
    }
  }

  void logRide(String text) {
    log(
      '[${text.capitalize} Ride] Cached Ride Request ${_cachedRideRequest?.toJson()}',
    );
  }

  Future<void> _postRideAction(
    BuildContext context,
    String endpoint, {
    Map<String, dynamic>? body,
    String? successLog,
    Function(Map<String, dynamic> data)? onSuccess,
    Function(dynamic response)? onError,
    String? errorMsg,
    bool showOverlay = false,
    bool dismissDialog = true,
    bool requireRide = true,
  }) async {
    if (requireRide && _cachedRideRequest == null) {
      showToast(
        context,
        "No Ride Request",
        "Sorry! you don't have any ride request at the moment",
        toastType: ToastType.error,
      );
      return;
    }
    try {
      await apiController.post(context, endpoint, body ?? {}, (success, data) {
        if (success) {
          if (successLog != null) log(successLog);
          if (onSuccess != null && data is Map<String, dynamic>) {
            onSuccess(data);
          }
          if (dismissDialog) context.dismissRideDialog();
        } else {
          if (data is String && data.contains("already accepted")) {
            _cachedRideRequest = null;
            _cachedRideId = null;
            emit(RideInitial());
          }
          onError?.call(data);
          if (dismissDialog) context.dismissRideDialog();
        }
      }, showOverlay: showOverlay);
    } catch (e) {
      if (errorMsg != null) emit(RideError(errorMsg));
    }
  }

  void resetRideRequest({bool shouldRemovePersistence = true}) async {
    _cachedRideRequest = null;
    _cachedRideId = null;
    emit(RideInitial());

    if (shouldRemovePersistence) {
      await Future.wait([
        deleteRideRequestFromHive(),
        deleteMessagesFromHive(),
      ]);
    }
  }

  Future<void> checkForActiveRide(BuildContext context) async {
    logRide("active");
    if (_cachedRideRequest != null) return;

    final activeRide = await getRideRequestFromHive();
    if (activeRide != null) {
      _updateRideRequest(activeRide, shouldPersist: false);
      context.read<HomeCubit>().toggleNearByRides(
        status: TransitStatus.accepted,
      );
      driverLocation.startLiveLocationUpdates(context);
      log("[Active Ride] Using persisted ride request");
      return;
    }
    log("No active ride found for driver");
  }

  Future<void> foundRide(RideRequest ride, BuildContext context) async {
    logRide("found");
    _updateRideRequest(ride, shouldPersist: false);
    context.read<HomeCubit>().toggleNearByRides(status: TransitStatus.found);
  }

  Future<void> _rideActionWithLocation(
    BuildContext context,
    String endpoint, {
    Map<String, dynamic>? extraBody,
    String? successLog,
    Function(Map<String, dynamic> data)? onSuccess,
    String? errorMsg,
    bool showOverlay = false,
  }) async {
    final latitude = context.driverCords?[1];
    final longitude = context.driverCords?[0];
    await _postRideAction(
      context,
      endpoint,
      body: {
        if (extraBody != null) ...extraBody,
        'latitude': latitude,
        'longitude': longitude,
      },
      successLog: successLog,
      onSuccess: onSuccess,
      errorMsg: errorMsg,
      showOverlay: showOverlay,
    );
  }

  Future<void> acceptRide(BuildContext context) async {
    logRide("accept");
    final rideId = _cachedRideRequest?.rideId;
    await _rideActionWithLocation(
      context,
      '$rideId/accept',
      successLog: "[Accept Ride]",
      onSuccess: (data) {
        context.read<HomeCubit>().setRideAccepted(isAccepted: true);
        driverLocation.startLiveLocationUpdates(context);

        final ride = RideRequest.fromJson(data["data"]);
        _updateRideRequest(
          _cachedRideRequest!.copyWith(
            user: ride.user,
            etaToPickup: ride.etaToPickup,
            estimatedDistance: ride.estimatedDistance,
            estimatedDuration: ride.estimatedDuration,
            driverEarnings: ride.driverEarnings,
            status: ride.status,
            paymentMethod: ride.paymentMethod,
          ),
        );
      },
      errorMsg: 'Failed to accept ride',
      showOverlay: true,
    );
  }

  Future<void> rejectRide(
    BuildContext context, {
    String? rideId,
    String? reason,
  }) async {
    await _postRideAction(
      context,
      '${rideId ?? _cachedRideId}/reject',
      body: {'reason': reason ?? 'Too far from my current location'},
      successLog: '[RideCubit] ride rejected',
      onSuccess: (_) => resetRideRequest(),
      errorMsg: 'Failed to reject ride',
      showOverlay: true,
    );
  }

  Future<void> cancelRide(
    BuildContext context, {
    String? rideId,
    String? reason,
    double? lat,
    double? long,
  }) async {
    logRide("cancel");
    if (_cachedRideRequest == null) return;
    await _rideActionWithLocation(
      context,
      '${rideId ?? _cachedRideId}/cancel',
      extraBody: {
        'reason': reason ?? 'Too far from my current location',
        if (lat != null) 'latitude': lat,
        if (long != null) 'longitude': long,
      },
      successLog: '[RideCubit] ride cancel',
      onSuccess: (_) {
        context.read<HomeCubit>().endRide();
        resetRideRequest(shouldRemovePersistence: true);
      },
      errorMsg: 'Failed to cancel ride',
      showOverlay: true,
    );
  }

  Future<void> arrivedRide(BuildContext context) async {
    final rideId = _cachedRideRequest?.rideId;
    await _rideActionWithLocation(
      context,
      '$rideId/arrived',
      successLog: '[RideCubit] ride arrived',
      onSuccess: (data) {
        _updateRideRequest(
          _cachedRideRequest!.copyWith(status: data["data"]['status']),
        );
      },
      errorMsg: 'Failed to arrive ride',
      showOverlay: true,
    );
  }

  Future<void> startRide(BuildContext context) async {
    final rideId = _cachedRideRequest?.rideId;
    await _rideActionWithLocation(
      context,
      '$rideId/start',
      successLog: '[RideCubit] ride started',
      onSuccess: (data) {
        final newData = data['data'];
        _updateRideRequest(
          _cachedRideRequest!.copyWith(
            status: newData['status'],
            etaToDropoff: DurationInfo.fromJson(newData['etaToDropoff']),
          ),
        );
      },
      errorMsg: 'Failed to start ride',
      showOverlay: true,
    );
  }

  Future<void> completeRide(BuildContext context) async {
    final rideId = _cachedRideRequest?.rideId;
    await _rideActionWithLocation(
      context,
      '$rideId/complete',
      successLog: '[RideCubit] ride completed',
      onSuccess: (data) async {
        final newData = data['data'];
        _updateRideRequest(
          _cachedRideRequest!.copyWith(
            status: newData['status'],
            paymentMethod: newData["paymentMethod"],
            paymentStatus: newData['paymentStatus'],
          ),
        );
        context.read<HomeCubit>().toggleNearByRides(
          status: TransitStatus.completed,
        );
        await loadDashboard(context, loadAll: false);
      },
      errorMsg: 'Failed to end ride',
      showOverlay: true,
    );
  }

  Future<void> confirmCashPayment(BuildContext context) async {
    final rideId = _cachedRideRequest?.rideId;
    await _postRideAction(
      context,
      '$rideId/confirm-payment',
      successLog: '[RideCubit] ride confirm payment',
      onSuccess: (data) async {
        log('[Confirm Payment Data] $data');
        _updateRideRequest(
          _cachedRideRequest!.copyWith(paymentStatus: "confirmed"),
        );
        await loadDashboard(context, loadAll: false);
      },
      errorMsg: 'Failed to confirm cash payment',
      showOverlay: true,
    );
  }

  Future<void> rateRideUser(
    BuildContext context, {
    required int rating,
    String comment = '',
  }) async {
    final rideId = _cachedRideRequest?.rideId;
    await _postRideAction(
      context,
      '$rideId/rate',
      body: {'rating': rating, 'comment': comment},
      successLog: '[RideCubit] ride user rated $rating',
      errorMsg: 'Failed to rate user',
      onSuccess: (_) async {
        resetRideRequest(shouldRemovePersistence: true);
        context.read<HomeCubit>().toggleNearByRides(
          status: TransitStatus.initial,
        );
        await loadDashboard(context, loadAll: false);
      },
      showOverlay: true,
    );
  }

  Future<void> sendUserMessage(
    BuildContext context, {
    String? rideId,
    required String message,
  }) async {
    await _postRideAction(
      context,
      '${rideId ?? _cachedRideId}/message',
      body: {"message": message},
      successLog: '[RideCubit] Message sent',
      errorMsg: 'Failed to send ride message',
    );
  }
}
