import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class DriverImageState extends Equatable {
  const DriverImageState();

  @override
  List<Object?> get props => [];
}

class DriverImageInitial extends DriverImageState {}

class DriverImageLoading extends DriverImageState {}

class DriverImageSelected extends DriverImageState {
  const DriverImageSelected(this.image);
  final File image;

  @override
  List<Object?> get props => [image];
}

class DriverImageError extends DriverImageState {
  const DriverImageError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
