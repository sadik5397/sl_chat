import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
