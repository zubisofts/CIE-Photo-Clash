import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthenticationRepository authenticationRepository;
  late StreamSubscription<CIEUser?> _authStateChangesSubcription;

  late String name;
  late String email;
  late String password;
  late File photo;
  late bool isEmailValid = true;
  late bool isPasswordValid = true;
  late bool isNameValid = true;

  static String uid = '';

  AuthBloc({required this.authenticationRepository}) : super(AuthInitial()) {
    // _authStateChangesSubcription.cancel();
    _authStateChangesSubcription = authenticationRepository.user.listen((user) {
      add(AuthStateChangedEvent(user: user));
      // print('Something changed:${user!.name}');
    });
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginWithGoogleEvent) {
      yield* _mapSignInWithGoogleEventToState();
    }

    if (event is LoginWithFacebokEvent) {
      yield* _mapLoginWithFacebokEventToState();
    }

    if (event is LogoutEvent) {
      authenticationRepository.logOut();
    }

    if (event is AuthStateChangedEvent) {
      // var user =event.user?.id !=null ? await new DataRepository().user(event.user.id):null;
      if (event.user != null) {
        uid = event.user!.id;
      }
      yield AuthStateChangedState(user: event.user);
    }
  }

  Stream<AuthState> _mapSignInWithGoogleEventToState() async* {
    yield AuthLoadingState();
    var loginRes = await authenticationRepository.logInWithGoogle();
    if (loginRes.error) {
      yield LoginErrorState(loginRes.data);
    } else {
      yield LoggedInState(loginRes.data);
    }
  }

  Stream<AuthState> _mapLoginWithFacebokEventToState() async* {
    yield AuthLoadingState();
    var loginRes = await authenticationRepository.signupUserWithFBCredentials();
    if (loginRes.error) {
      yield LoginErrorState(loginRes.data);
    } else {
      yield LoggedInState(loginRes.data);
    }
  }
}
