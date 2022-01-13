import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qchat/core/components/alert/alert_dialog.dart';
import 'package:qchat/core/init/services/storage_service.dart';
import 'package:qchat/core/provider/app_state/app_state_provider.dart';
import 'package:qchat/locator.dart';

class FBAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppStateProvider? _appStateProvider = locator<AppStateProvider>();
  StorageService? _storageService = locator<StorageService>();

  Future<User?> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _appStateProvider!.setToken(await userCredential.user!.getIdToken());
      await _storageService!
          .setTokenAsync(await userCredential.user!.getIdToken());
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      showAlertDialog(context, e.code);
    }
  }

  Future resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      return true;
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context, e.code);
// show the snackbar here
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User?> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      var fbUid = userCredential.user!.uid;
      _appStateProvider!.setToken(await userCredential.user!.getIdToken());
      await _firestore.collection('users').doc(fbUid).set({
        'email': email,
        'name': name,
        'fbUid': fbUid,
        "status": "Unavailable",
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showAlertDialog(context, e.code);
    }
  }
}
