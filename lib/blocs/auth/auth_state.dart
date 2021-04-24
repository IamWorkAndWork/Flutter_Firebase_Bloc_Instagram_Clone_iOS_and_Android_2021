part of 'auth_bloc.dart';

enum AuthStatus { unknow, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User user;
  final AuthStatus status;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknow,
  });

  factory AuthState.unknow() => const AuthState();

  factory AuthState.autheticated({@required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unAuthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}
