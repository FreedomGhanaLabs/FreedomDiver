import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/home/view/widgets/home_widgets.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/utilities/hive/ride.dart';
import 'package:freedomdriver/utilities/socket_service.dart';
import 'package:get/get.dart';

import '../../../../core/di/locator.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  RideRequest? _cachedAcceptRide;
  String? _cachedRideId;

  bool get hasAcceptedRide => _cachedAcceptRide != null;

  final ApiController apiController = ApiController('ride');
  final driverSocketService = getIt<DriverSocketService>();

  void _updateAcceptRide(RideRequest updated, {String? rideId}) {
    _cachedAcceptRide = updated;
    _cachedRideId = updated.rideId;
    emit(RideLoaded(_cachedAcceptRide!));
  }

  void logRide(String text) {
    log('[${text.capitalize} Ride] ${_cachedAcceptRide?.toJson()}');
  }

  Future<void> fetchRide(
    BuildContext context,
    String rideId, {
    bool refresh = false,
  }) async {
    if (!refresh && _cachedAcceptRide != null && _cachedRideId == rideId) {
      emit(RideLoaded(_cachedAcceptRide!));
      return;
    }
    emit(RideLoading());
    try {
      final activeRide = await getRideFromHive();
      if (activeRide != null) {
        _updateAcceptRide(activeRide);
      }
    } catch (e) {
      emit(RideError('Failed to load ride'));
    }
  }

  Future<void> foundRide(RideRequest ride, BuildContext context) async {
    logRide("found");
    _updateAcceptRide(ride);
    context.read<HomeCubit>().toggleNearByRides(status: TransitStatus.found);
  }

  Future<void> _postRideAction(
    BuildContext context,
    String endpoint, {
    Map<String, dynamic>? body,
    String? successLog,
    Function(Map<String, dynamic> data)? onSuccess,
    String? errorMsg,
    bool showOverlay = false,
  }) async {
    try {
      await apiController.post(context, endpoint, body ?? {}, (success, data) {
        context.dismissRideDialog();
        if (success) {
          if (successLog != null) log(successLog);
          if (onSuccess != null && data is Map<String, dynamic>) {
            onSuccess(data);
          }
        } else {
          _cachedAcceptRide = null;
          _cachedRideId = null;
        }
      }, showOverlay: showOverlay);
    } catch (e) {
      if (errorMsg != null) emit(RideError(errorMsg));
    }
  }

  Future<void> acceptRide(BuildContext context) async {
    logRide("accept");
    if (_cachedAcceptRide == null) return;
    final rideId = _cachedAcceptRide?.rideId;
    final latitude = context.driver?.location?.coordinates[1];
    final longitude = context.driver?.location?.coordinates[0];

    await _postRideAction(
      context,
      '$rideId/accept',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: "[Accept Ride]",
      onSuccess: (data) {
        driverSocketService.acceptRideRequest(rideId ?? "");
        context.read<HomeCubit>().setRideAccepted(isAccepted: true);
        context.dismissRideDialog();
        // Optionally update cache if needed
        // final ride = RideRequest.fromJson(data);
        // _updateAcceptRide(ride);
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
        driverSocketService.rejectRideRequest(rideId ?? "");
        _cachedAcceptRide = null;
        _cachedRideId = null;
        context.dismissRideDialog();
      },
      errorMsg: 'Failed to reject ride',
    );
  }

  Future<void> cancelRide(
    BuildContext context, {
    required String rideId,
    String reason = 'Too far from my current location',
    double? lat,
    double? long,
  }) async {
    logRide("cancel");
    if (_cachedAcceptRide == null) return;
    final latitude = lat ?? context.driver?.location?.coordinates[1];
    final longitude = long ?? context.driver?.location?.coordinates[0];
    await _postRideAction(
      context,
      '$rideId/cancel',
      body: {'reason': reason, 'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride cancel',
      onSuccess: (_) {
        // updateStatus(context, TransitStatus.initial);
        _cachedAcceptRide = null;
        _cachedRideId = null;
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
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    await _postRideAction(
      context,
      '$rideId/start',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride started',
      errorMsg: 'Failed to start ride',
    );
  }

  Future<void> completeRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    await _postRideAction(
      context,
      '$rideId/complete',
      body: {'latitude': latitude, 'longitude': longitude},
      successLog: '[RideCubit] ride completed',
      onSuccess: (data) {
        updateStatus(context, TransitStatus.completed);
        final ride = RideRequest.fromJson(data);
        _updateAcceptRide(ride, rideId: rideId);
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

    final previousStatusName = _cachedAcceptRide!.status;
    emit(RideUpdating(_cachedAcceptRide!.copyWith(status: newStatus.name)));
    emit(RideLoaded(_cachedAcceptRide!.copyWith(status: newStatus.name)));

    try {
      await apiController.patch(
        context,
        _cachedAcceptRide!.rideId,
        {'status': newStatus.name},
        (success, data) {
          if (success) {
            log('[ride cubit] status has been updated');
            if (data is Map<String, dynamic>) {
              final ride = RideRequest.fromJson(data);
              _updateAcceptRide(ride, rideId: _cachedRideId);
            }
          } else {
            emit(
              RideLoaded(
                _cachedAcceptRide!.copyWith(status: previousStatusName),
              ),
            );
          }
        },
      );
    } catch (_) {
      emit(RideError('Failed to update status'));
      emit(RideLoaded(_cachedAcceptRide!.copyWith(status: previousStatusName)));
    }
  }
}
