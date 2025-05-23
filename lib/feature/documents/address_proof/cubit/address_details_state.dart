import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/documents/driver_license/driver_license.model.dart';

abstract class DriverLicenseDetailsState extends Equatable {
  const DriverLicenseDetailsState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseDetailsInitial extends DriverLicenseDetailsState {}

class DriverLicenseDetailsLoading extends DriverLicenseDetailsState {}

class DriverLicenseLoaded extends DriverLicenseDetailsState {
  const DriverLicenseLoaded(this.driverLicense);
  final DriverLicense driverLicense;

  @override
  List<Object?> get props => [driverLicense];
}
