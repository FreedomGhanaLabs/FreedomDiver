// ---------- DRIVER LICENSE IMAGE STATE ----------
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class DriverLicenseImageState extends Equatable {
  const DriverLicenseImageState();

  @override
  List<Object?> get props => [];
}

class DriverLicenseImageInitial extends DriverLicenseImageState {}

class DriverLicenseImageLoading extends DriverLicenseImageState {}

class DriverLicenseImageSelected extends DriverLicenseImageState {
  const DriverLicenseImageSelected(this.image);
  final File image;

  @override
  List<Object?> get props => [image];
}

class DriverLicenseImageError extends DriverLicenseImageState {
  const DriverLicenseImageError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
