import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registeration_state.dart';

class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit() : super(const RegistrationFormState());
  void setEmail(String? email) {
    emit(state.copyWith(email: email));
  }
}
