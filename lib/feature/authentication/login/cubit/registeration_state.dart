part of 'registeration_cubit.dart';

class RegistrationFormState extends Equatable {
  const RegistrationFormState({
    this.email,
  });
  final String? email;

  RegistrationFormState copyWith({
    String? email,
  }) {
    return RegistrationFormState(
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [email];
}
