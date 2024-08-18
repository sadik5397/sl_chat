import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sl_chat/auth/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("HomePage"),
          trailing: IconButton(onPressed: () => AuthService().signOut(), icon: const Icon(CupertinoIcons.person_badge_minus), iconSize: 20),
        ),
        child: const Center(child: Text("HomePage")));
  }
}
