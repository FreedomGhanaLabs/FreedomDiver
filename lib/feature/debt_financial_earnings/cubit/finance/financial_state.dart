import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/models/finance.dart';

abstract class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object?> get props => [];
}

class FinancialInitial extends FinancialState {}

class FinancialLoading extends FinancialState {}

class FinancialLoaded extends FinancialState {
  const FinancialLoaded(this.finance);
  final Finance  finance;

  @override
  List<Object?> get props => [finance];
}

class FinancialError extends FinancialState {
  const FinancialError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
