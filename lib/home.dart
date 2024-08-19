import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/service/auth_service.dart';
import 'package:sl_chat/service/chat_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User currentUser = AuthService().getCurrentUserInfo();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("SL Chat"),
          trailing: CupertinoButton(
              onPressed: () => AuthService().signOut(),
              child: const Icon(CupertinoIcons.person_badge_minus, size: 20)),
        ),
        child: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Logged in as\n${currentUser.email}',
                  textAlign: TextAlign.center)),
          StreamBuilder(
              stream: ChatService().getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Text("Something Went Wrong");
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Text("Loading...");
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return const Text("No data available");
                return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!
                        .map<Widget>((user) => CupertinoListTile(
                            title: Text(user["displayName"].toString()),
                            subtitle: Text(user["email"].toString())))
                        .toList());
              })
        ]));
  }
}
