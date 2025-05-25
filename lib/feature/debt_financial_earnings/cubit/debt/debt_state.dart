import 'package:equatable/equatable.dart';

abstract class DebtState extends Equatable {
  const DebtState();

  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  const DebtLoaded(this.finance);
  final  finance;

  @override
  List<Object?> get props => [finance];
}

class DebtError extends DebtState {
  const DebtError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
