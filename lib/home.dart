import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/auth/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User currentUser = AuthService().getUserInfo();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("SL Chat"),
          trailing: CupertinoButton(
              onPressed: () => AuthService().signOut(),
              child: const Icon(CupertinoIcons.person_badge_minus, size: 20)),
        ),
        child: Center(
            child: Text('Logged in as\n${currentUser.email}',
                textAlign: TextAlign.center)));
  }
}
