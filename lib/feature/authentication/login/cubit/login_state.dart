part of 'login_cubit.dart';

class LoginFormState extends Equatable {
  const LoginFormState({
    this.email,
  });
  final String? email;

  LoginFormState copyWith({
    String? email,
  }) {
    return LoginFormState(
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [email];
}
