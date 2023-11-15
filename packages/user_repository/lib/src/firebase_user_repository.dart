import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  // cadastro
  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      myUser = myUser.copyWith(
        id: user.user!.uid,
      );

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // entrar
  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // sair
  @override
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // alterar senha
  @override
  Future<void> resetPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
