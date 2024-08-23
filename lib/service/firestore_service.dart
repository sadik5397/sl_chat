import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sl_chat/model/message.dart';
import 'package:sl_chat/service/auth_service.dart';

class FireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> saveUserToFireStore({required User user}) async {
    // Save user data to Firestore
    await fireStore
        .collection("Users")
        .doc(user.uid)
        .set({'uid': user.uid, 'email': user.email, if (user.displayName != null) 'displayName': user.displayName, if (user.photoURL != null) 'photoURL': user.photoURL});
  }


  Future<void> updateUserToFireStore({required String uid, String? displayName, String? photoUrl}) async {
    // Update displayName if provided
    if (displayName != null) await fireStore.collection("Users").doc(uid).update({'displayName': displayName});
    // Update photoUrl if provided
    if (photoUrl != null) await fireStore.collection("Users").doc(uid).update({'photoURL': photoUrl});
  }


  /// Stream of all users data from Firestore
  Stream<List<Map<String, dynamic>>> getUserStreamFromFireStore() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  /// Stream of all user IDs from Firestore
  Stream<List<String>> getUserIdListStreamFromFireStore() => fireStore.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  /// Delete a user from Firestore
  Future<void> deleteUserFromFireStore({required User user}) async => await fireStore.collection("Users").doc(user.uid).delete();


  Future<void> sendMessageToFireStore({required String receiverID, required String message}) async {
    // Get the current user ID
    String currentUserID = AuthService().getCurrentUserInfo().uid;
    // Get the current timestamp
    Timestamp currentTime = Timestamp.now();
    // Create a list of user IDs and sort them alphabetically
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort();
    // Create the chatroom ID by joining the sorted user IDs with "_"
    String chatroomID = userIDs.join("_");
    // Create a new message object
    Message newMessage = Message(senderID: currentUserID, receiverID: receiverID, message: message, timestamp: currentTime);
    // Add the new message to the Firestore collection
    final docRef = await fireStore.collection("Chats").doc(chatroomID).collection("Messages").add(newMessage.toMap());
    // Update the document with the document ID
    await docRef.update({'documentID': docRef.id});
  }


  /// Set the react index of a message in Firestore
  Future<void> setReactToFireStore({required Message message, required int reactIndex}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'reactIndex': reactIndex});
  }

  /// Delete a message from Firestore
  Future<void> deleteMessageFromFireStore({required Message message}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'deleted': true});
  }

  /// Edit a message in Firestore
  Future<void> editMessageFromFireStore({required Message message, required String newMessage}) async {
    List<String> userIDs = [message.senderID, message.receiverID];
    userIDs.sort();
    String chatroomID = userIDs.join("_");
    await fireStore.collection("Chats").doc(chatroomID).collection("Messages").doc(message.documentID).update({'message': newMessage, 'edited': true});
  }


  Stream<List<Message>> getMessageStreamFromFireStore({required String receiverID}) {
    // Get the current user ID
    String currentUserID = AuthService().getCurrentUserInfo().uid;
    // Create a list of user IDs and sort them alphabetically
    List<String> userIDs = [currentUserID, receiverID];
    userIDs.sort();
    // Create the chatroom ID by joining the sorted user IDs with "_"
    String chatroomID = userIDs.join("_");
    // Return a stream of messages from Firestore, ordered by timestamp in descending order
    return fireStore
        .collection("Chats")
        .doc(chatroomID)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }

}
