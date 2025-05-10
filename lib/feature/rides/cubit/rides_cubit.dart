import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/feature/rides/cubit/rides_state.dart';
import 'package:freedom_driver/feature/rides/models/rides.model.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

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
          (success, data) {

        }
      );
      final updatedRide = currentRide.copyWith(status: newStatus.name);
      emit(RideLoaded(updatedRide));
    } catch (_) {
      emit(RideError('Failed to update status'));
      emit(RideLoaded(currentRide)); // restore
    }
  }
}
