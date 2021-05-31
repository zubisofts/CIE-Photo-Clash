import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/blocs/data/data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.8,
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  foregroundDecoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  child: Image.asset(
                    'assets/images/bg.jpg',
                    fit: BoxFit.cover,
                    width: 800,
                  ),
                ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cie_logo.png',
                        width: 150,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'CIE Photo Clash',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Login to upload your best shot 😎',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.3,
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.white,
                elevation: 0.0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(32.0),
                        topStart: Radius.circular(32.0))),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        'Sign in with social Networks',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      MaterialButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LoginWithFacebokEvent());
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        color: Color(0xFF4267b3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/facebookF.png',
                              width: 32.0,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              'Facebook',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthLoadingState) {
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: SpinKitDualRing(
                                  color: Theme.of(context).iconTheme.color!,
                                  lineWidth: 2,
                                  size: 45,
                                ),
                              ),
                            );
                          }
                          if (state is LoggedInState) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("User logged in successfulluy")));
                          }

                          if (state is LoginErrorState) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${state.error}')));
                          }
                        },
                        builder: (context, state) {
                          return MaterialButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(LoginWithGoogleEvent());
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 32.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
