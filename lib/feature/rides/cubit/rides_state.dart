

import 'package:equatable/equatable.dart';
import 'package:freedom_driver/feature/rides/models/rides.model.dart';

abstract class RideState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RideInitial extends RideState {}

class RideLoading extends RideState {}

class RideUpdating extends RideState {
  final AcceptRide ride;
  RideUpdating(this.ride);

  @override
  List<Object?> get props => [ride];
}

class RideLoaded extends RideState {
  final AcceptRide ride;
  RideLoaded(this.ride);

  @override
  List<Object?> get props => [ride];
}

class RideError extends RideState {
  final String message;
  RideError(this.message);

  @override
  List<Object?> get props => [message];
}
