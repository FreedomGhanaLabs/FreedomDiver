import 'package:equatable/equatable.dart';

abstract class DebtState extends Equatable {
  const DebtState();

  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  const DebtLoaded(this.debt);
  final debt;

  @override
  List<Object?> get props => [debt];
}

class DebtError extends DebtState {
  const DebtError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
