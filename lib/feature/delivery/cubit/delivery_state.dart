import 'package:equatable/equatable.dart';

abstract class DeliveryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryUpdating extends DeliveryState {
  DeliveryUpdating(this.ride);
  final  ride;

  @override
  List<Object?> get props => [ride];
}

class DeliveryLoaded extends DeliveryState {
  DeliveryLoaded(this.ride);
  final  ride;

  @override
  List<Object?> get props => [ride];
}

class DeliveryError extends DeliveryState {
  DeliveryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
