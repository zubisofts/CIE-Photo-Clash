import 'package:cie_photo_clash/src/blocs/app/app_bloc.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/blocs/data/data_bloc.dart';
import 'package:cie_photo_clash/src/repository/auth_repository.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:cie_photo_clash/src/screens/onbaording/splashscreen.dart';
import 'package:cie_photo_clash/src/utils/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  // Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationRepository _authService = AuthenticationRepository();
  DataRepository _dataService = DataRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                  authenticationRepository: _authService,
                )),
        BlocProvider<DataBloc>(
            create: (context) => DataBloc(
                  dataRepository: _dataService,
                )),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.dark,
            home: App(),
          );
        },
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
