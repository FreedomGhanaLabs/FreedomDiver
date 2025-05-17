import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';

abstract class DriverState extends Equatable {
  const DriverState();

  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverLoaded extends DriverState {

  const DriverLoaded(this.driver);
  final Driver driver;

  @override
  List<Object?> get props => [driver];
}

class DriverError extends DriverState {

  const DriverError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
