import 'package:equatable/equatable.dart';
import '../ghana_card.model.dart';

abstract class GhanaCardState extends Equatable {
  const GhanaCardState();

  @override
  List<Object?> get props => [];
}

class GhanaCardInitial extends GhanaCardState {}

class GhanaCardLoading extends GhanaCardState {}

class GhanaCardLoaded extends GhanaCardState {
  final GhanaCard ghanaCard;

  const GhanaCardLoaded(this.ghanaCard);

  @override
  List<Object?> get props => [ghanaCard];
}

class GhanaCardError extends GhanaCardState {
  final String message;

  const GhanaCardError(this.message);

  @override
  List<Object?> get props => [message];
}
