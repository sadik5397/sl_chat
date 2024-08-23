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

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Try to sign in the user with Google
    try {
      // Sign in the user with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // If the user cancels the sign in process
      if (googleUser == null) throw Fluttertoast.showToast(msg: "Sign in aborted by user");
      // Get the Google authentication credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a credential with the Google authentication credentials
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      // Sign in the user with the Google credential
      UserCredential userCredential = await auth.signInWithCredential(credential);
      // Save the user to Firestore
      await FireStoreService().saveUserToFireStore(user: userCredential.user!);
      // Navigate to the Home screen and remove all previous screens
      routeNoBack(context, const Home());
      // Return the user credential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Throw an exception with the error message if there's an error
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<UserCredential> signInWithEmailPassword({required String email, required String password, required BuildContext context}) async {
    // Try to sign in the user with email and password
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      // Check if the user exists in Firestore
      if (await FireStoreService().getUserIdListStreamFromFireStore().contains(userCredential.user!.uid)) {
        // Save the user to Firestore if they don't exist
        await FireStoreService().saveUserToFireStore(user: userCredential.user!);
      }
      // Navigate to the Home screen and remove all previous screens
      routeNoBack(context, const Home());
      // Return the user credential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Throw an exception with the error message if there's an error
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  /// Updates the user's profile with the given name and photo URL.
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

  /// Changes the password of the current user.
  Future<void> changePassword({required String password, required String rePassword}) async {
    try {
      if (password == rePassword) {
        await auth.currentUser!.updatePassword(password);
        Fluttertoast.showToast(msg: "Password Changed Successfully");
      } else {
        throw Fluttertoast.showToast(msg: "Passwords are not same");
      }
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: "Something went wrong. Please check\n$e}");
    }
  }

  /// Sends a password reset email to the specified email address.
  Future<void> restPasswordRequest({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Please check your email inbox");
    } on FirebaseAuthException catch (e) {
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<UserCredential?> signUpWithEmailPassword({required String email, String? name, String? photoUrl, required String password, required String rePassword, required BuildContext context}) async {
    // Try to create a new user with email and password
    try {
      // Check if the passwords match
      if (password == rePassword) {
        // Create a new user with email and password
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        // Save the user to Firestore
        FireStoreService().saveUserToFireStore(user: userCredential.user!);
        // Update the user profile with name and photo URL
        updateProfile(name: name, photoUrl: photoUrl);
        // Navigate to the Home screen and remove all previous screens
        routeNoBack(context, const Home());
        // Return the user credential
        return userCredential;
      } else {
        // Throw an exception if the passwords do not match
        throw Fluttertoast.showToast(msg: "Passwords are not same");
      }
    } on FirebaseAuthException catch (e) {
      // Throw an exception with the error message if there's an error
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  void signOut(BuildContext context) {
    // Try to sign out the user from Firebase Authentication
    try {
      auth.signOut();
      // Show a toast message indicating successful sign out
      Fluttertoast.showToast(msg: "User signed out");
      // Navigate to the SignIn screen and remove all previous screens
      Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const SignIn()), (route) => false);
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException and show a toast message with the error message
      throw Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  User getCurrentUserInfo() {
    try {
      // Get the current user from Firebase Authentication
      User? user = auth.currentUser;
      // Return the user object if it's not null
      return user!;
    } on FirebaseAuthException catch (e) {
      // Throw an exception with the error code if there's an error
      throw Exception(e.code);
    }
  }

  Future<void> deleteUser({required BuildContext context}) async {
    // Show a Cupertino Dialog to confirm account deletion
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: const Text("Delete Your Account"),
              content: const Text("Are you sure you want to delete your account? Your profile information including all of your chat history will be destroyed permanently"),
              actions: <Widget>[
                // Cancel button to close the dialog
                CupertinoDialogAction(child: const Text("Cancel"), onPressed: () => routeBack(context)),
                // Delete button to confirm account deletion
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text("Delete"),
                    onPressed: () async {
                      try {
                        // Delete user data from Firestore
                        await FireStoreService().deleteUserFromFireStore(user: auth.currentUser!);
                        // Delete user account from Firebase Authentication
                        await auth.currentUser!.delete();
                        // Navigate back to the previous screen
                        routeBack(context);
                        // Show a toast message indicating successful account deletion
                        Fluttertoast.showToast(msg: "Account deleted successfully");
                        // Navigate to the SignIn screen and remove all previous screens
                        Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const SignIn()), (route) => false);
                      } on FirebaseAuthException catch (e) {
                        // Handle FirebaseAuthException
                        if (e.code == 'requires-recent-login') {
                          // Navigate back to the previous screen
                          routeBack(context);
                          // Show a toast message asking the user to re-authenticate
                          throw Fluttertoast.showToast(msg: "Please re-authenticate and try again.");
                        } else {
                          // Navigate back to the previous screen
                          routeBack(context);
                          // Show a toast message with the error message
                          throw Fluttertoast.showToast(msg: e.message.toString());
                        }
                      }
                    })
              ]);
        });
  }
}
