import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({required this.senderID, required this.senderEmail, required this.receiverID, required this.message, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      senderID: doc['senderID'],
      senderEmail: doc['senderEmail'],
      receiverID: doc['receiverID'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
}
