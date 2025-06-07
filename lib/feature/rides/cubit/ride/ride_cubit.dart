import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/widgets/home_widgets.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/utilities/hive/ride.dart';
import 'package:freedomdriver/utilities/socket_service.dart';
import 'package:get/get.dart';

import '../../../../core/di/locator.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  RideRequest? _cachedRideRequest;
  String? _cachedRideId;

  bool get hasAcceptedRide => _cachedRideRequest != null;

  final ApiController apiController = ApiController('ride');
  final driverSocketService = getIt<DriverSocketService>();

  void _updateRideRequest(
    RideRequest updated, {
    String? rideId,
    bool shouldPersist = true,
  }) async {
    _cachedRideRequest = updated;
    _cachedRideId = updated.rideId;
    emit(RideLoaded(_cachedRideRequest!));
    if (shouldPersist) await addRideRequestToHive(_cachedRideRequest!);
  }

  void logRide(String text) {
    log('[${text.capitalize} Ride] ${_cachedRideRequest?.toJson()}');
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
  }) async {
    if (_cachedRideRequest == null) {
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
        context.dismissRideDialog();
        if (success) {
          if (successLog != null) log(successLog);
          if (onSuccess != null && data is Map<String, dynamic>) {
            onSuccess(data);
          }
        } else {
          if (data is String && data.contains("already accepted")) {
            _cachedRideRequest = null;
            _cachedRideId = null;
            emit(RideInitial());
          }
          onError?.call(data);
        }
      }, showOverlay: showOverlay);
    } catch (e) {
      if (errorMsg != null) emit(RideError(errorMsg));
    }
  }

  void _resetRideRequest() {
    _cachedRideRequest = null;
    _cachedRideId = null;
    emit(RideInitial());
  }

  Future<void> checkForActiveRide() async {
    logRide("Active");
    if (_cachedRideRequest != null) {
      return;
    }

    final activeRide = await getRideRequestFromHive();

    if (activeRide != null) {
      _updateRideRequest(activeRide, shouldPersist: false);
    }

    log("No active ride found for driver");
  }

  Future<void> foundRide(RideRequest ride, BuildContext context) async {
    logRide("found");
    if (_cachedRideRequest != null) return;
    _updateRideRequest(ride, shouldPersist: false);
    context.read<HomeCubit>().toggleNearByRides(status: TransitStatus.found);
  }

  Future<void> acceptRide(BuildContext context) async {
    logRide("accept");

    final rideId = _cachedRideRequest?.rideId;
    final latitude = context.driverCords?[1];
    final longitude = context.driverCords?[0];

    await _postRideAction(
      context,
      '$rideId/accept',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: "[Accept Ride]",
      onSuccess: (data) {
        context.read<HomeCubit>().setRideAccepted(isAccepted: true);

        final ride = RideRequest.fromJson(data["data"]);
        _updateRideRequest(
          _cachedRideRequest!.copyWith(
            user: ride.user,
            etaToPickup: ride.etaToPickup,
            estimatedDistance: ride.estimatedDistance,
            estimatedDuration: ride.estimatedDuration,
            driverEarnings: ride.driverEarnings,
            status: ride.status,
          ),
        );
      },
      errorMsg: 'Failed to accept ride',
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
      onSuccess: (_) {
        _resetRideRequest();
      },
      errorMsg: 'Failed to reject ride',
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
    final latitude = lat ?? context.driverCords?[1];
    final longitude = long ?? context.driverCords?[0];
    await _postRideAction(
      context,
      showOverlay: true,
      '${rideId ?? _cachedRideId}/cancel',
      body: {
        'reason': reason ?? 'Too far from my current location',
        'latitude': latitude,
        'longitude': longitude,
      },
      successLog: '[RideCubit] ride cancel',
      onSuccess: (_) {
        context.read<HomeCubit>().endRide();
        _resetRideRequest();
      },
      errorMsg: 'Failed to cancel ride',
    );
  }

  Future<void> arrivedRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    await _postRideAction(
      context,
      '$rideId/arrived',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride arrived',
      errorMsg: 'Failed to arrive ride',
    );
  }

  Future<void> startRide(
    BuildContext context, {
    String? rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    await _postRideAction(
      context,
      '${rideId ?? _cachedRideId}/start',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride started',
      errorMsg: 'Failed to start ride',
    );
  }

  Future<void> completeRide(
    BuildContext context, {
    String? rideId,
    double? lat,
    double? long,
  }) async {
    final latitude = lat ?? context.driver?.location?.coordinates[1];
    final longitude = long ?? context.driver?.location?.coordinates[0];
    await _postRideAction(
      context,
      '${rideId ?? _cachedRideId}/complete',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride completed',
      onSuccess: (data) {
      
        // final ride = RideRequest.fromJson(data);
        // _updateRideRequest(ride, rideId: rideId);
      },
      errorMsg: 'Failed to end ride',
      showOverlay: true,
    );
  }

  Future<void> confirmRidePayment(
    BuildContext context, {
    required String rideId,
  }) async {
    await _postRideAction(
      context,
      '$rideId/confirm-payment',
      successLog: '[RideCubit] ride confirm payment',
      errorMsg: 'Failed to end ride',
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

  Future<void> rateRideUser(
    BuildContext context, {
    required String rideId,
    double rating = 3,
    String comment = 'Very polite and punctual',
  }) async {
    await _postRideAction(
      context,
      '$rideId/rate',
      body: {'rating': rating, 'comment': comment},
      successLog: '[RideCubit] ride user rated $rating',
      errorMsg: 'Failed to end ride',
      showOverlay: true,
    );
  }

  Future<void> updateStatus(
    BuildContext context,
    TransitStatus newStatus,
  ) async {
    if (!hasAcceptedRide) return;

    final previousStatusName = _cachedRideRequest!.status;
    emit(RideUpdating(_cachedRideRequest!.copyWith(status: newStatus.name)));
    emit(RideLoaded(_cachedRideRequest!.copyWith(status: newStatus.name)));

    try {
      await apiController.patch(
        context,
        _cachedRideRequest!.rideId,
        {'status': newStatus.name},
        (success, data) {
          if (success) {
            log('[ride cubit] status has been updated');
            if (data is Map<String, dynamic>) {
              final ride = RideRequest.fromJson(data);
              _updateRideRequest(ride, rideId: _cachedRideId);
            }
          } else {
            emit(
              RideLoaded(
                _cachedRideRequest!.copyWith(status: previousStatusName),
              ),
            );
          }
        },
      );
    } catch (_) {
      emit(RideError('Failed to update status'));
      emit(
        RideLoaded(_cachedRideRequest!.copyWith(status: previousStatusName)),
      );
    }
  }
}
