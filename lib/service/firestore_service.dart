import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sl_chat/model/message.dart';
import 'package:sl_chat/service/auth_service.dart';

class FireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> saveUserToFireStore({required User user}) async {
    await fireStore.collection("Users").doc(user.uid).set({'uid': user.uid, 'email': user.email});
  }

  Future<void> updateProfile({required String uid, String? displayName, String? photoUrl}) async {
    if (displayName != null) await fireStore.collection("Users").doc(uid).update({'displayName': displayName});
    if (photoUrl != null) await fireStore.collection("Users").doc(uid).update({'photoUrl': photoUrl});
  }

  Stream<List<Map<String, dynamic>>> getUserStream() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<String>> getUserIdListStream() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  Future<void> sendMessage({required String receiverID, required String message}) async {
    String currentUserID = AuthService().getCurrentUserInfo().uid;
    String currentUserEmail = AuthService().getCurrentUserInfo().email!;
    Timestamp currentTime = Timestamp.now();
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    Message newMessage = Message(senderID: currentUserID, senderEmail: currentUserEmail, receiverID: receiverID, message: message, timestamp: currentTime);
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").add(newMessage.toMap());
  }

  Stream<List<Message>> getMessageStream({required String receiverID}) {
    String currentUserID = AuthService().getCurrentUserInfo().uid;
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    return fireStore
        .collection("Chats")
        .doc(chatroomID)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }
}
