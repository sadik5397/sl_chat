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
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  FocusNode focusNode = FocusNode();

  Future<void> updateSearchQuery(String query) async => setState(() => searchQuery = searchController.text.toLowerCase());

  Future<void> refresh() async {
    setState(() {});
  }

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
                final data = snapshot.data?.where((user) => user["displayName"].toLowerCase().contains(searchQuery)).toList() ?? [];
                return handleSnapShotError(snapshot) ??
                    ThemeListSection(
                        header: "Messages",
                        onSearchEntrySubmitted: (value) async => await updateSearchQuery(searchQuery),
                        searchController: searchController,
                        footer: "Total ${data.length - 1} people available",
                        children: data.map<Widget>((user) => ConversationListTile(user: user)).toList());
              })
        ]));
  }
}
