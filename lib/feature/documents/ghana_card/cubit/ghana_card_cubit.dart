import 'package:flutter_bloc/flutter_bloc.dart';

import '../ghana_card.model.dart';
import 'ghana_card_state.dart';

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
