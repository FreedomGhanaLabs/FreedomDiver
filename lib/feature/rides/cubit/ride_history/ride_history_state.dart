import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/rides/models/ride.dart';

abstract class RideHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class RideHistoryLoaded extends RideHistoryState {
  RideHistoryLoaded(this.ride);
  final Ride ride;

  @override
  List<Object?> get props => [ride];
}

class RideHistoryError extends RideHistoryState {
  RideHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
