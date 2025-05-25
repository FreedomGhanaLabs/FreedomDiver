
import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/models/earning.dart';

abstract class EarningState extends Equatable {
  const EarningState();

  @override
  List<Object?> get props => [];
}

class EarningInitial extends EarningState {}

class EarningLoading extends EarningState {}

class EarningLoaded extends EarningState {
  const EarningLoaded(this.earning);
  final Earning earning;

  @override
  List<Object?> get props => [earning];
}

class EarningError extends EarningState {
  const EarningError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
