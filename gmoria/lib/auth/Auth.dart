import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> deleteAccount();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //MF
  //Use the firebaseAuth method to sign in with the email and password from FireBaseAuth
  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final User user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user?.uid;
  }

  //MF
  //Create the user with the Email and Password from FirebaseAuth
  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user?.uid;
  }

  final databaseReference = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  //MF
  //Add the user that has been created to the Database
  void createUserDatabase() async {
    databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("lists");
  }

  //MF
  //Return the currentUser that is connected to the App
  @override
  Future<String> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  //MF
  //Sign out the currentUser that is connected to the DB
  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  //MF
  //Delete the account of the user that is connected to the DB and sign him out
  @override
  Future<void> deleteAccount() async {
    _firebaseAuth.currentUser.delete();
    return _firebaseAuth.signOut();
  }
}
