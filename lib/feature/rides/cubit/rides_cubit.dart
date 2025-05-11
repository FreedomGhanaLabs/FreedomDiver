import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/feature/rides/cubit/rides_state.dart';
import 'package:freedom_driver/feature/rides/models/rides.model.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  AcceptRide? _cachedAcceptRide;

  AcceptRide? get currentDriver => _cachedAcceptRide;
  bool get hasDriver => _cachedAcceptRide != null;

  void _updateAcceptRide(AcceptRide updated) {
    _cachedAcceptRide = updated;
    emit(RideLoaded(_cachedAcceptRide!));
  }

  void _emitIfChanged(AcceptRide updated) {
    if (_cachedAcceptRide != updated) {
      _updateAcceptRide(updated);
    } else {
      log('[RideCubit] No changes detected, not emitting new state');
    }
  }

  final ApiController apiController = ApiController('ride');

  Future<void> fetchRide(BuildContext context, String rideId) async {
    emit(RideLoading());
    try {
      await apiController.getData(context, rideId, (success, data) {
        if (success) {
          final ride = AcceptRide.fromJson(data as Map<String, dynamic>);
          emit(RideLoaded(ride));
        }
      });
    } catch (e) {
      emit(RideError('Failed to load ride'));
    }
  }

  Future<void> acceptRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    emit(RideLoading());
    try {
      await apiController.post(context, '$rideId/accept',
          {'latitude': latitude, 'longitude': longitude}, (success, data) {
        if (success) {
          final ride = AcceptRide.fromJson(data as Map<String, dynamic>);
          _updateAcceptRide(ride);
        }
      });
    } catch (e) {
      emit(RideError('Failed to load ride'));
    }
  }

  Future<void> rejectRide(
    BuildContext context, {
    required String rideId,
    String reason = 'Too far from my current location',
  }) async {
    try {
      await apiController.post(context, '$rideId/reject', {'reason': reason},
          (success, data) {
        if (success) {
          log('[RideCubit] ride rejected');
        }
      });
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
      await apiController.post(context, '$rideId/arrived',
          {'latitude': latitude, 'longitude': longitude}, (success, data) {
        if (success) {
          log('[RideCubit] ride arrived');
        }
      });
    } catch (e) {
      emit(RideError('Failed to cancel ride'));
    }
  }

  Future<void> startRide(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(context, '$rideId/start',
          {'latitude': latitude, 'longitude': longitude}, (success, data) {
        if (success) {
          log('[RideCubit] ride started');
          // updateStatus(context, )
        }
      });
    } catch (e) {
      emit(RideError('Failed to cancel ride'));
    }
  }

  Future<void> updateStatus(BuildContext context, RideStatus newStatus) async {
    if (state is! RideLoaded) return;
    final currentRide = (state as RideLoaded).ride;
    emit(RideUpdating(currentRide));

    try {
      await apiController.patch(
        context,
        currentRide.rideId,
        {
          'status': newStatus.name,
        },
        (success, data) {},
      );
      final updatedRide = currentRide.copyWith(status: newStatus.name);
      emit(RideLoaded(updatedRide));
    } catch (_) {
      emit(RideError('Failed to update status'));
      emit(RideLoaded(currentRide)); // restore
    }
  }
}
