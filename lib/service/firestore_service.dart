import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sl_chat/model/message.dart';
import 'package:sl_chat/service/auth_service.dart';

class FireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> saveUserToFireStore({required User user}) async {
    await fireStore.collection("Users").doc(user.uid).set({'uid': user.uid, 'email': user.email});
  }

  Future<void> updateUserToFireStore({required String uid, String? displayName, String? photoUrl}) async {
    if (displayName != null) await fireStore.collection("Users").doc(uid).update({'displayName': displayName});
    if (photoUrl != null) await fireStore.collection("Users").doc(uid).update({'photoUrl': photoUrl});
  }

  Stream<List<Map<String, dynamic>>> getUserStreamFromFireStore() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List<String>> getUserIdListStreamFromFireStore() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  Future<void> deleteUserFromFireStore({required User user}) async => await fireStore.collection("Users").doc(user.uid).delete();

  Future<void> sendMessageToFireStore({required String receiverID, required String message}) async {
    String currentUserID = AuthService().getCurrentUserInfo().uid;
    Timestamp currentTime = Timestamp.now();
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    Message newMessage = Message(senderID: currentUserID, receiverID: receiverID, message: message, timestamp: currentTime);
    final docRef = await fireStore.collection("Chats").doc(chatroomID).collection("Messages").add(newMessage.toMap());
    await docRef.update({'documentID': docRef.id});
  }

  Future<void> setReactToFireStore({required Message message, required int reactIndex}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'reactIndex': reactIndex});
  }

  Future<void> deleteMessageFromFireStore({required Message message}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'deleted': true});
  }

  Future<void> editMessageFromFireStore({required Message message, required String newMessage}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'message': newMessage, 'edited': true});
  }

  Stream<List<Message>> getMessageStreamFromFireStore({required String receiverID}) {
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
