import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/screens/auth/login_screen.dart';
import 'package:cie_photo_clash/src/screens/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is AuthStateChangedState,
      listener: (context, state) {
        if (state is AuthStateChangedState) {
          print('Status:${state.user}');
        }
      },
      builder: (context, state) {
        if (state is AuthStateChangedState) {
          if (state.user != null) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
        return SpinKitThreeBounce(
          color: Theme.of(context).colorScheme.secondary,
        );
      },
    );
  }
}
