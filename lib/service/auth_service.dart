import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/home.dart';
import 'package:sl_chat/service/firestore_service.dart';

import '../sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (await FireStoreService().getUserIdListStream().contains(userCredential.user!.uid)) FireStoreService().saveUserToFireStore(user: userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      if (name != null) await getCurrentUserInfo().updateDisplayName(name);
      if (photoUrl != null) await getCurrentUserInfo().updatePhotoURL(photoUrl);
      await FireStoreService().updateProfile(uid: getCurrentUserInfo().uid, displayName: name, photoUrl: photoUrl);
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<void> changePassword({required String password, required String rePassword}) async {
    try {
      if (password == rePassword) {
        await auth.currentUser!.updatePassword(password);
        Fluttertoast.showToast(msg: "Password Changed Successfully");
      } else {
        Fluttertoast.showToast(msg: "Passwords are not same");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong. Please check");
      throw Exception(e);
    }
  }

  Future<UserCredential?> signUpWithEmailPassword({required String email, String? name, String? photoUrl, required String password, required String rePassword, required BuildContext context}) async {
    try {
      if (password == rePassword) {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        FireStoreService().saveUserToFireStore(user: userCredential.user!);
        updateProfile(name: name, photoUrl: photoUrl);
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

  void signOut(BuildContext context) {
    try {
      auth.signOut();
      Fluttertoast.showToast(msg: "User signed out");
      Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const SignIn()), (route) => false);
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
