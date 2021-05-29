import 'dart:async';
import 'dart:convert';

import 'package:cie_photo_clash/src/blocs/data/api_response.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Stream<CIEUser?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? firebaseUser.toUser : null;
    });
  }

  // Future<void> signInGoogle(bool login) async {
  //   if (login) {
  //     await logInWithGoogle();
  //   } else {
  //     final googleUser = await _googleSignIn.signIn();
  //     await signupWithGoogle(googleUser!);
  //   }
  // }

  /// Starts the Sign In with Google Flow.
  ///
  Future<ApiResponse> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      List<String> list =
          await _firebaseAuth.fetchSignInMethodsForEmail(googleUser!.email);
      // print('PROVIDERS:$list');
      if (list.isNotEmpty) {
        if (list.contains('google.com')) {
          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          return ApiResponse(data: userCredential.user!.toUser, error: false);
        } else {
          _googleSignIn.signOut();
          return ApiResponse(
              data:
                  "Sorry, please login with the account provider associated with this email",
              error: true);
        }
      } else {
        // await _googleSignIn.signOut();
        return await signupWithGoogle(googleUser);
      }
    } on FirebaseException catch (e) {
      _googleSignIn.signOut();
      return ApiResponse(data: e.message, error: true);
    } on Exception catch (ex) {
      _googleSignIn.signOut();
      return ApiResponse(data: ex.toString(), error: true);
    }
  }

  Future<ApiResponse> signupUserWithFBCredentials() async {
    try {
      final result =
          await _facebookLogin.logIn(permissions: [FacebookPermission.email]);
      // print('Result:${result.errorMessage}');
      switch (result.status) {
        case FacebookLoginStatus.success:
          var credential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final graphResponse = await http.get(Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken!.token}'));
          final profile = json.decode(graphResponse.body);

          List<String> list =
              await _firebaseAuth.fetchSignInMethodsForEmail(profile['email']);
          if (list.isNotEmpty) {
            var userCredential =
                await _firebaseAuth.signInWithCredential(credential);
            return ApiResponse(data: userCredential.user!.toUser, error: false);
          } else {
            var userCredential =
                await _firebaseAuth.signInWithCredential(credential);
            return await DataRepository()
                .addUserToB(userCredential.user!.toUser);
          }
        case FacebookLoginStatus.cancel:
          return ApiResponse(data: 'Action was canceled', error: true);
        case FacebookLoginStatus.error:
          print(result.error!);
          return ApiResponse(
              data: "esult.error!.localizedDescription", error: true);
        default:
          return ApiResponse(data: "Unknown error", error: true);
      }
    } on FirebaseException catch (error) {
      print(error.message);
      return ApiResponse(data: error.message, error: true);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookLogin.logOut()
      ]);
    } on Exception {}
  }

  Future<ApiResponse> signupWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      // final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;

      // List<String> list =
      //     await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      var addUserRes =
          await DataRepository().addUserToB(userCredential.user!.toUser);
      if (addUserRes.error) {
        return ApiResponse(data: null, error: true);
      } else {
        return ApiResponse(data: addUserRes.data, error: false);
      }
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }
}

extension on User {
  CIEUser get toUser {
    return CIEUser(
        id: uid, email: email!, name: displayName!, photo: photoURL!);
  }
}
