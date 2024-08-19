import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  saveUserToFireStore({required UserCredential userCredential}) {
    fireStore.collection("Users").doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': userCredential.user!.email,
      'displayName': userCredential.user!.displayName
    });
  }

  updateDisplayName({required String uid, required String displayName}) {
    fireStore.collection("Users").doc(uid).update({'displayName': displayName});
  }
}
