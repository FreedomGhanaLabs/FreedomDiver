import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void toggleNearByRides() {
    emit(state.copyWith(rideStatus: TransitStatus.searching));
    Timer(const Duration(seconds: 2), () {
      emit(state.copyWith(rideStatus: TransitStatus.found));
    });
  }

  void setRideAccepted({bool? isAccepted}) {
    log('setRideAccepted: $state');
    if (isAccepted == null) return;

    emit(state.copyWith(rideStatus: TransitStatus.accepted));
    log('Current State after accept: ${state.rideStatus}');
  }

  void endRide() {
    emit(state.copyWith(rideStatus: TransitStatus.initial));
  }
}
