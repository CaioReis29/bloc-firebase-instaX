part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticaded, unauthenticaded, unknow }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User? user;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknow,
    this.user,
  });

  // Sem informações sobre o AuthenticationStatus do usuário
  const AuthenticationState.unknow() : this._();

  // o usuário atual está autenticado
  // a classe MyUser vai representar o atual usuário autenticado
  const AuthenticationState.authenticaded(User user)
      : this._(
          status: AuthenticationStatus.authenticaded,
          user: user,
        );

  // o usuário atual não foi autenticado
  const AuthenticationState.unauthenticaded()
      : this._(
          status: AuthenticationStatus.unauthenticaded,
        );

  @override
  List<Object?> get props => [status, user];
}
