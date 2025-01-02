import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registeration_state.dart';

class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit() : super(const RegistrationFormState());
  void setPhoneNumber(String phoneNumber) {
    log('phoneNumber: $phoneNumber');
    emit(state.copyWith(phoneNumber: phoneNumber));
  }
}
