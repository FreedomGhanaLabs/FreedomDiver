import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';

// ---------- DRIVER LICENSE OVERALL STATE ----------
abstract class DriverLicenseState extends Equatable {
  const DriverLicenseState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseInitial extends DriverLicenseState {}
class DriverLicenseLoading extends DriverLicenseState {}
class DriverLicenseSuccess extends DriverLicenseState {}
class DriverLicenseError extends DriverLicenseState {
  final String message;
  const DriverLicenseError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------- DRIVER LICENSE IMAGE STATE ----------
abstract class DriverLicenseImageState extends Equatable {
  const DriverLicenseImageState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseImageInitial extends DriverLicenseImageState {}
class DriverLicenseImageLoading extends DriverLicenseImageState {}
class DriverLicenseImageSelected extends DriverLicenseImageState {
  final File image;
  const DriverLicenseImageSelected(this.image);

  @override
  List<Object?> get props => [image];
}

// ---------- DRIVER LICENSE DETAILS STATE ----------
abstract class DriverLicenseDetailsState extends Equatable {
  const DriverLicenseDetailsState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseDetailsInitial extends DriverLicenseDetailsState {}
class DriverLicenseDetailsLoading extends DriverLicenseDetailsState {}
class DriverLicenseDetailsLoaded extends DriverLicenseDetailsState {
  final DriverLicense driverLicense;
  const DriverLicenseDetailsLoaded(this.driverLicense);

  @override
  List<Object?> get props => [driverLicense];
}
class DriverLicenseDetailsError extends DriverLicenseDetailsState {
  final String message;
  const DriverLicenseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
