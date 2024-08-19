import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/home.dart';

class ChatService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    try {
      return fireStore
          .collection("Users")
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } on FirebaseFirestore catch (e) {
      throw Fluttertoast.showToast(msg: e.toString());
    }
  }
}
