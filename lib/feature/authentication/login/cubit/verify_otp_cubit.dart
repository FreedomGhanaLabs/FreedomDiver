import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(const VerifyOtpState());

  void verifyOtp(String otp) {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    log('isloading from state ${state.isLoading}');
    final isValid = isOtpValid(otp);
    if (isValid) {
      emit(
        state.copyWith(
          isVerified: isValid,
          isLoading: false,
          clearMessage: isValid,
          isError: false,
          errorMessage: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: 'Invalid OTP',
          isLoading: false,
          clearMessage: isValid,
          isVerified: false,
        ),
      );
    }
  }

  Future<void> isFirstTimer({required bool isFirstTimer}) async {
    final box = await Hive.openBox<bool>('firstTimerUser');
    await box.put('isFirstTimer', isFirstTimer);
    log('isFirstTimer: $isFirstTimer');
  }
}

bool isOtpValid(String otp) {
  const systemValue = 123456;
  if (otp.length == 6 && otp == systemValue.toString()) {
    return true;
  }
  return false;
}
