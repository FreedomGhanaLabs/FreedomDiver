import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/authentication/register/models/register_model.dart';
import 'package:freedomdriver/feature/authentication/register/register_repository.dart';

part 'registration_state.dart';

class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit() : super(const RegistrationFormState());
  void setPhoneNumber(String phoneNumber) {
    log('phoneNumber: $phoneNumber');
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  final authRepo = RegisterRepository();

  void setUserDetails({
    String? phoneNumber,
    String? driversName,
    String? driversEmail,
    String? motorcycleType,
    String? motorcycleColor,
    String? licenseNumber,
    String? motorcycleNumber,
    String? motorcycleYear,
    String? address,
    String? password,
    String? securedImageUrl,
  }) {
    emit(state.copyWith(
        phoneNumber: phoneNumber,
        driversName: driversName,
        driversEmail: driversEmail,
        motorcycleType: motorcycleType,
        motorcycleColor: motorcycleColor,
        licenseNumber: licenseNumber,
        motorcycleNumber: motorcycleNumber,
        motorcycleYear: motorcycleYear,
        address: address,
        password: password,
        profilePicture: securedImageUrl,
      ),
    );
  }

  Future<void> registerDrivers() async {
    try{
      emit(state.copyWith(formStatus: FormStatus.submitting));
      await authRepo.registerNewDriver(RegisterModel(
        phoneNumber: state.phoneNumber,
        driversName: state.driversName,
        driversEmail: state.driversEmail,
        motorcycleType: state.motorcycleType,
        motorcycleColor: state.motorcycleColor,
        licenseNumber: state.licenseNumber,
        motorcycleNumber: state.motorcycleNumber,
        motorcycleYear: state.motorcycleYear,
        address: state.address,
        password: state.password,
        profilePicture: state.profilePicture,
        ),
      );
      emit(state.copyWith(formStatus: FormStatus.success));
    } catch (e) {
      emit(state.copyWith(formStatus: FormStatus.failure));
    }
  }

}
