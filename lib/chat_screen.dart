import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/conversation_list_tile.dart';
import 'package:sl_chat/component/handle_snapshot_error.dart';
import 'package:sl_chat/component/list_section.dart';
import 'package:sl_chat/component/text_field.dart';
import 'package:sl_chat/profile.dart';
import 'package:sl_chat/service/firestore_service.dart';

import 'component/chat_list_tile.dart';
import 'component/page_navigation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.recipient});

  final Map recipient;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController reply = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(end: 8),
          middle: Text(widget.recipient["displayName"] ?? "<Unknown User>"),
          previousPageTitle: "Inbox",
        ),
        child: Column(children: [
          Expanded(
              child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), reverse: true, children: [
            StreamBuilder(
                stream: FireStoreService().getMessageStreamFromFireStore(receiverID: widget.recipient["uid"]),
                builder: (context, snapshot) {
                  return handleSnapShotError(snapshot) ??
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: snapshot.data!.map<Widget>((message) {
                            return ChatListTile(message: message, context: context);
                          }).toList());
                })
          ])),
          Padding(
              padding: const EdgeInsets.all(20),
              child: ThemeTextField(
                  controller: reply,
                  textInputType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  title: "Reply Here",
                  autoFocus: true,
                  endChild: CupertinoButton(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Icon(CupertinoIcons.arrow_up_circle_fill, size: 28),
                      onPressed: () async {
                        await FireStoreService().sendMessageToFireStore(receiverID: widget.recipient["uid"], message: reply.text);
                        reply.clear();
                      })))
        ]));
  }
}
