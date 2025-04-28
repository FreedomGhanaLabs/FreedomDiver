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
  const DriverLicenseError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

