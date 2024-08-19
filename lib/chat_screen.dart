import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/chat_list_tile.dart';
import 'package:sl_chat/component/handle_snapshot_error.dart';
import 'package:sl_chat/component/list_section.dart';
import 'package:sl_chat/profile.dart';
import 'package:sl_chat/service/firestore_service.dart';

import 'component/page_navigation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.recipientName});

  final String recipientName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(end: 8),
          middle: Text(widget.recipientName),
          previousPageTitle: "Inbox",
        ),
        child: const Text("Chat Screen"));
  }
}
