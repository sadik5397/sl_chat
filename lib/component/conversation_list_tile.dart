import 'package:flutter/cupertino.dart';
import 'package:sl_chat/chat_screen.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/service/auth_service.dart';

class ConversationListTile extends StatelessWidget {
  const ConversationListTile({super.key, required this.user});

  final Map user;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: user["uid"] != AuthService().getCurrentUserInfo().uid,
      child: CupertinoListTile(
          onTap: () => route(context, ChatScreen(recipient: user)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
              alignment: Alignment.center,
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user["photoURL"] == null ? const Color(0x15ffffff) : CupertinoColors.white,
                  image: user["photoURL"] == null ? null : DecorationImage(image: NetworkImage(user["photoURL"]))),
              child: user["photoURL"] == null ? Text(user["displayName"].toString().toUpperCase()[0]) : null),
          trailing: const CupertinoListTileChevron(),
          title: Text(user["displayName"].toString()),
          subtitle: Text(user["email"].toString())),
    );
  }
}
