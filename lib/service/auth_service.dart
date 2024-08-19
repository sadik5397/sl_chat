import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/home.dart';
import 'package:sl_chat/service/firestore_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (await FireStoreService().getUserIdListStream().contains(userCredential.user!.uid)) FireStoreService().saveUserToFireStore(userCredential: userCredential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<UserCredential?> signUpWithEmailPassword({required String email, String? name, String? photoUrl, required String password, required String rePassword, required BuildContext context}) async {
    try {
      if (password == rePassword) {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        if (name != null) userCredential.user!.updateDisplayName(name);
        if (photoUrl != null) userCredential.user!.updatePhotoURL(photoUrl);
        FireStoreService().saveUserToFireStore(userCredential: userCredential);
        FireStoreService().updateProfile(uid: userCredential.user!.uid, displayName: name, photoUrl: photoUrl);
        // ignore: use_build_context_synchronously
        routeNoBack(context, const Home());
        return userCredential;
      } else {
        Fluttertoast.showToast(msg: "Passwords are not same");
      }
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      return auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  User getCurrentUserInfo() {
    try {
      User? user = auth.currentUser;
      return user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
