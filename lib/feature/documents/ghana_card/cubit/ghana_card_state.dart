import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/documents/ghana_card/ghana_card.model.dart';

abstract class GhanaCardState extends Equatable {
  const GhanaCardState();

  @override
  List<Object?> get props => [];
}

class GhanaCardInitial extends GhanaCardState {}

class GhanaCardLoading extends GhanaCardState {}

class GhanaCardLoaded extends GhanaCardState {

  const GhanaCardLoaded(this.ghanaCard);
  final GhanaCard ghanaCard;

  @override
  List<Object?> get props => [ghanaCard];
}

class GhanaCardError extends GhanaCardState {

  const GhanaCardError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
