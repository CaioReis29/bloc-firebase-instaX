part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInRquired extends SignInEvent {
  final String email;
  final String password;

  const SignInRquired({
    required this.email,
    required this.password,
  });
}

class SignOutRequired extends SignInEvent {
  const SignOutRequired();
}
