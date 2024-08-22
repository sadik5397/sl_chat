// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/page_navigation.dart';
import '../view/auth/sign_in.dart';
import '../view/inbox/home.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Sign in aborted by user");
        return Future.error("Sign in aborted by user");
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential = await auth.signInWithCredential(credential); //sign in with google
      await FireStoreService().saveUserToFireStore(user: userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (await FireStoreService().getUserIdListStreamFromFireStore().contains(userCredential.user!.uid)) FireStoreService().saveUserToFireStore(user: userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      if (name != null) await getCurrentUserInfo().updateDisplayName(name);
      if (photoUrl != null) await getCurrentUserInfo().updatePhotoURL(photoUrl);
      await FireStoreService().updateUserToFireStore(uid: getCurrentUserInfo().uid, displayName: name, photoUrl: photoUrl);
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

  Future<void> restPasswordRequest({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Please check your email inbox");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      throw Exception(e);
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(
      {required String email, String? name, String? photoUrl, required String password, required String rePassword, required BuildContext context}) async {
    try {
      if (password == rePassword) {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        FireStoreService().saveUserToFireStore(user: userCredential.user!);
        updateProfile(name: name, photoUrl: photoUrl);
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

  Future<void> deleteUser({required BuildContext context}) async {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: const Text("Delete Your Account"),
              content: const Text("Are you sure you want to delete your account? Your profile information including all of your chat history will be destroyed permanently"),
              actions: <Widget>[
                CupertinoDialogAction(child: const Text("Cancel"), onPressed: () => routeBack(context)),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text("Delete"),
                    onPressed: () async {
                      try {
                        await FireStoreService().deleteUserFromFireStore(user: auth.currentUser!);
                        await auth.currentUser!.delete();
                        routeBack(context);
                        Fluttertoast.showToast(msg: "Account deleted successfully");
                        Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const SignIn()), (route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'requires-recent-login') {
                          Fluttertoast.showToast(msg: "Please re-authenticate and try again.");
                          routeBack(context);
                        } else {
                          Fluttertoast.showToast(msg: e.message.toString());
                          routeBack(context);
                        }
                      }
                    })
              ]);
        });
  }
}
