import 'package:equatable/equatable.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';


abstract class DriverLicenseState extends Equatable {
  const DriverLicenseState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseInitial extends DriverLicenseState {}

class DriverLicenseLoading extends DriverLicenseState {}

class DriverLicenseLoaded extends DriverLicenseState {

  const DriverLicenseLoaded(this.driverLicense);
  final DriverLicense driverLicense;

  @override
  List<Object?> get props => [driverLicense];
}

class DriverLicenseError extends DriverLicenseState {

  const DriverLicenseError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
