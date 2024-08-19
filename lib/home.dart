import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/chat_list_tile.dart';
import 'package:sl_chat/component/handle_snapshot_error.dart';
import 'package:sl_chat/component/list_section.dart';
import 'package:sl_chat/service/auth_service.dart';
import 'package:sl_chat/service/firestore_service.dart';

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
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              CupertinoButton(onPressed: () => AuthService().signOut(), child: const Icon(CupertinoIcons.person_alt_circle, size: 15)),
              CupertinoButton(onPressed: () => AuthService().signOut(), child: const Icon(CupertinoIcons.person_badge_minus, size: 15)),
            ])),
        child: ListView(children: [
          // Padding(padding: const EdgeInsets.all(24), child: Text('Logged in as\n${currentUser.email}', textAlign: TextAlign.center)),
          StreamBuilder(
              stream: FireStoreService().getUserStream(),
              builder: (context, snapshot) {
                return handleSnapShotError(snapshot) ??
                    ThemeListSection(
                      header: "Messages",
                      searchController: TextEditingController(),
                      footer: "Total ${snapshot.data!.length} people available",
                      children: snapshot.data!.map<Widget>((user) => ChatListTile(user: user)).toList(),
                    );
              })
        ]));
  }
}
