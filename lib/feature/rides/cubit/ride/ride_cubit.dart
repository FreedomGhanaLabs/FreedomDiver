import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/utilities/hive/ride.dart';
import 'package:freedomdriver/utilities/socket_service.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  RideRequest? _cachedAcceptRide;
  String? _cachedRideId;

  RideRequest? get currentDriver => _cachedAcceptRide;
  bool get hasAcceptedRide => _cachedAcceptRide != null;

  void _updateAcceptRide(RideRequest updated, {String? rideId}) {
    _cachedAcceptRide = updated;
    _cachedRideId = updated.rideId;
    emit(RideLoaded(_cachedAcceptRide!));
  }

  final ApiController apiController = ApiController('ride');

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
    // await addRideToHive(ride);
    _updateAcceptRide(ride);
    context.read<HomeCubit>().toggleNearByRides(status: TransitStatus.found);
  }

  Future<void> acceptRide(BuildContext context) async {
    if (_cachedAcceptRide == null) return;
    final rideId = _cachedAcceptRide?.rideId;
    final latitude = context.driver?.location?.coordinates[1];
    final longitude = context.driver?.location?.coordinates[0];

    context.read<HomeCubit>().setRideAccepted(isAccepted: true);
    try {
      await apiController.post(
        context,
        '$rideId/accept',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log("[Accept Ride] $data");
            final ride = RideRequest.fromJson(data as Map<String, dynamic>);
            // _updateAcceptRide(ride);
            // updateStatus(context, TransitStatus.accepted);
          }
        },
      );
    } catch (e) {
      emit(RideError('Failed to accept ride'));
    }
  }

  Future<void> rejectRide(
    BuildContext context, {
    String? rideId,
    String? reason,
  }) async {
    DriverSocketService().rejectRideRequest(rideId ?? "");
    try {
      await apiController.post(
        context,
        '$rideId/reject',
        {'reason': reason ?? 'Too far from my current location'},
        (success, data) {
          if (success) {
            log('[RideCubit] ride rejected');
            updateStatus(context, TransitStatus.declined);
            _cachedAcceptRide = null;
            _cachedRideId = null;
          }
        },
      );
    } catch (e) {
      emit(RideError('Failed to reject ride'));
    }
  }

  Future<void> cancelRide(
    BuildContext context, {
    required String rideId,
    String reason = 'Too far from my current location',
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/cancel',
        {'reason': reason, 'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[RideCubit] ride cancel');
            updateStatus(context, TransitStatus.initial);
            _cachedAcceptRide = null;
            _cachedRideId = null;
          }
        },
      );
    } catch (e) {
      emit(RideError('Failed to cancel ride'));
    }
  }

  Future<void> arrivedRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/arrived',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[RideCubit] ride arrived');
          }
        },
      );
    } catch (e) {
      emit(RideError('Failed to arrive ride'));
    }
  }

  Future<void> startRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/start',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[RideCubit] ride started');
            // updateStatus(context, TransitStatus.started);
          }
        },
      );
    } catch (e) {
      emit(RideError('Failed to cancel ride'));
    }
  }

  Future<void> completeRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/complete',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[RideCubit] ride completed');
            updateStatus(context, TransitStatus.completed);
            // Optionally update cache if API returns updated ride
            if (data is Map<String, dynamic>) {
              final ride = RideRequest.fromJson(data);
              _updateAcceptRide(ride, rideId: rideId);
            }
          }
        },
        showOverlay: true,
      );
    } catch (e) {
      emit(RideError('Failed to end ride'));
    }
  }

  Future<void> confirmRidePayment(
    BuildContext context, {
    required String rideId,
  }) async {
    try {
      await apiController.post(context, '$rideId/confirm-payment', {}, (
        success,
        data,
      ) {
        if (success) {
          log('[RideCubit] ride confirm payment');
        }
      }, showOverlay: true);
    } catch (e) {
      emit(RideError('Failed to end ride'));
    }
  }

  Future<void> rateRideUser(
    BuildContext context, {
    required String rideId,
    double rating = 5,
    String comment = 'Very polite and punctual',
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/rate',
        {'rating': rating, 'comment': comment},
        (success, data) {
          if (success) {
            log('[RideCubit] ride user rated $rating');
          }
        },
        showOverlay: true,
      );
    } catch (e) {
      emit(RideError('Failed to end ride'));
    }
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
            // Optionally update cache if API returns updated ride
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
      emit(
        RideLoaded(_cachedAcceptRide!.copyWith(status: previousStatusName)),
      ); // restore
    }
  }
}
