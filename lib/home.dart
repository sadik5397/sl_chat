import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/conversation_list_tile.dart';
import 'package:sl_chat/component/handle_snapshot_error.dart';
import 'package:sl_chat/component/list_section.dart';
import 'package:sl_chat/profile.dart';
import 'package:sl_chat/service/firestore_service.dart';

import 'component/page_navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            padding: const EdgeInsetsDirectional.only(end: 8),
            middle: const Text("SL Chat"),
            automaticallyImplyLeading: false,
            trailing: CupertinoButton(padding: EdgeInsets.zero, onPressed: () => route(context, const MyProfile()), child: const Icon(CupertinoIcons.person_alt_circle, size: 24))),
        child: ListView(children: [
          StreamBuilder(
              stream: FireStoreService().getUserStreamFromFireStore(),
              builder: (context, snapshot) {
                return handleSnapShotError(snapshot) ??
                    ThemeListSection(
                        header: "Messages",
                        searchController: TextEditingController(),
                        footer: "Total ${snapshot.data!.length} people available",
                        children: snapshot.data!.map<Widget>((user) => ConversationListTile(user: user)).toList());
              })
        ]));
  }
}
