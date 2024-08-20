import 'package:flutter/cupertino.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:sl_chat/model/message.dart';
import 'package:sl_chat/service/auth_service.dart';

class ChatListTile extends StatefulWidget {
  const ChatListTile({super.key, required this.message});

  final Message message;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  bool showTime = false;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = (widget.message.senderID == AuthService().getCurrentUserInfo().uid);
    return Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
            onTap: () => setState(() => showTime = !showTime),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isCurrentUser ? CupertinoColors.activeBlue : CupertinoColors.activeGreen,
                      borderRadius: BorderRadius.circular(12).copyWith(bottomRight: isCurrentUser ? const Radius.circular(0) : null, bottomLeft: isCurrentUser ? null : const Radius.circular(0))),
                  child: Text(widget.message.message)),
              if (showTime)
                Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                        widget.message.timestamp.toDate().isBefore(DateTime.now().subtract(const Duration(days: 1)))
                            ? Moment(widget.message.timestamp.toDate()).toString()
                            : Moment(widget.message.timestamp.toDate()).calendar(),
                        style: const TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12)))
            ])));
  }
}
