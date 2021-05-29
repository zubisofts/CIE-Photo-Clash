part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailAndPasswordEvent extends AuthEvent {}

class SignupWithEmailAndPasswordEvent extends AuthEvent {}

class AuthStateChangedEvent extends AuthEvent {
  final CIEUser? user;
  AuthStateChangedEvent({required this.user});

  @override
  List<Object> get props => [user!];
}

class LogoutEvent extends AuthEvent {}

class SignupEvent extends AuthEvent {}

class LoginWithGoogleEvent extends AuthEvent {}

class SignupWithGoogleEvent extends AuthEvent {}

class LoginWithFacebokEvent extends AuthEvent {}

class SignupWithFacebokEvent extends AuthEvent {}

class OnSubmitLoginFormEvent extends AuthEvent {}
