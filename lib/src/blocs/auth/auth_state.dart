part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthStateChangedState extends AuthState {
  final CIEUser? user;

  AuthStateChangedState({required this.user});

  @override
  List<Object> get props => [user!];
}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;
  AuthErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class LoginErrorState extends AuthState {
  final String error;

  LoginErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class LoggedInState extends AuthState {
  final CIEUser user;

  LoggedInState(this.user);

  @override
  List<Object> get props => [user];
}
