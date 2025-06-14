import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';

abstract class DeliveryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryLoaded extends DeliveryState {
  DeliveryLoaded(this.ride);
  final RideRequest ride;

  @override
  List<Object?> get props => [ride];
}

class DeliveryError extends DeliveryState {
  DeliveryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
