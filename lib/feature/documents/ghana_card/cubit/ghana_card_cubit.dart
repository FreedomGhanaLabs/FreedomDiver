import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freedomdriver/feature/documents/ghana_card/ghana_card.model.dart';
import 'package:freedomdriver/feature/documents/ghana_card/cubit/ghana_card_state.dart';

class GhanaCardCubit extends Cubit<GhanaCardState> {
  GhanaCardCubit() : super(GhanaCardInitial());

  void loadGhanaCard(GhanaCard card) {
    emit(GhanaCardLoaded(card));
  }

  void updateGhanaCard(GhanaCard updatedCard) {
    emit(GhanaCardLoaded(updatedCard));
  }

  void resetGhanaCard() {
    emit(GhanaCardInitial());
  }

  void setError(String message) {
    emit(GhanaCardError(message));
  }
}
