import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final userCollection = FirebaseFirestore.instance.collection("user");

  // Stream de MyUser para avisar quando o estado de autenticação mudar
  // vai emitir MyUser.empty caso não seja autenticado
  @override
  Stream<User?> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

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

  // alterar dados do usuário
  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await userCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // pegar dados do usuário
  @override
  Future<MyUser> getMyUser(String userId) async {
    try {
      return userCollection.doc(userId).get().then(
            (value) => MyUser.fromEntity(
              MyUserEntity.fromDocument(value.data()!),
            ),
          );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // adicionar foto
  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference ref =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await ref.putFile(imageFile);
      String url = await ref.getDownloadURL();
      await userCollection.doc(userId).update({"picture": url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
