import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  saveUserToFireStore({required User user}) {
    fireStore.collection("Users").doc(user.uid).set({'uid': user.uid, 'email': user.email});
  }

  updateProfile({required String uid, String? displayName, String? photoUrl}) {
    if (displayName != null) fireStore.collection("Users").doc(uid).update({'displayName': displayName});
    if (photoUrl != null) fireStore.collection("Users").doc(uid).update({'photoUrl': photoUrl});
  }

  Stream<List<Map<String, dynamic>>> getUserStream() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<String>> getUserIdListStream() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
}
