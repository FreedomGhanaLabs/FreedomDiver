part of 'registeration_cubit.dart';

class RegistrationFormState extends Equatable {
  const RegistrationFormState({
    this.phoneNumber,
  });
  final String? phoneNumber;

  RegistrationFormState copyWith({
    String? phoneNumber,
  }) {
    return RegistrationFormState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [phoneNumber];
}
