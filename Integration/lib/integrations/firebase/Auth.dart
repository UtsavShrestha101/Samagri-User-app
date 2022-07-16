/*
*  (I am already added dummy google-services file but if you use in production
*  than create your project in firebase and get it from there.
* */

/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for firebase
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/* For Android
 * Reference : https://firebase.google.com/docs/flutter/setup?platform=android
 * Add google-services.json
 */

/* For iOS
 * Reference : https://firebase.google.com/docs/flutter/setup?platform=ios
 * Add GoogleService-Info.plist
 */

/*
* Make sure all steps you follow as references
* Then enable email/password authentication in your project at https://console.firebase.google.com/
* */


import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<AuthResult> signIn(String email, String password);

  Future<AuthResult> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {

  // ignore: non_constant_identifier_names
  static final String ERROR_EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";
  static final String ERROR_WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static final String ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
  static final String ERROR_USER_NOT_FOUND = "ERROR_USER_NOT_FOUND";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return result;

  }

  Future<AuthResult> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  static bool validateEmail(String value) {
    if (value.isEmpty) return false;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return false;
    }
    return true;
  }
}