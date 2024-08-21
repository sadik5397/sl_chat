import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? documentID;
  final String senderID;
  final String receiverID;
  final String message;
  final Timestamp timestamp;
  final int? reactIndex;
  final bool? edited;
  final bool? deleted;

  Message({
    this.documentID,
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    this.reactIndex,
    this.edited,
    this.deleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
      if (reactIndex != null) 'reactIndex': reactIndex,
      if (edited != null) 'edited': edited,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Message(
      documentID: doc.id,
      senderID: data?['senderID'] as String,
      receiverID: data?['receiverID'] as String,
      message: data?['message'] as String,
      timestamp: data?['timestamp'] as Timestamp,
      reactIndex: data != null && data.containsKey('reactIndex') ? data['reactIndex'] as int : null,
      edited: data != null && data.containsKey('edited') ? data['edited'] as bool : null,
      deleted: data != null && data.containsKey('deleted') ? data['deleted'] as bool : null,
    );
  }
}
