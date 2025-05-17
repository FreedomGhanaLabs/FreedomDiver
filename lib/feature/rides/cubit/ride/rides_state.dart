

import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/rides/models/accept_ride.dart';

abstract class RideState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RideInitial extends RideState {}

class RideLoading extends RideState {}

class RideUpdating extends RideState {
  RideUpdating(this.ride);
  final AcceptRide ride;

  @override
  List<Object?> get props => [ride];
}

class RideLoaded extends RideState {
  RideLoaded(this.ride);
  final AcceptRide ride;

  @override
  List<Object?> get props => [ride];
}

class RideError extends RideState {
  RideError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
