import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/model/message.dart';
import 'package:sl_chat/service/auth_service.dart';
import 'package:sl_chat/service/firestore_service.dart';

class ChatListTile extends StatefulWidget {
  const ChatListTile({super.key, required this.message, required this.context, required this.recipient});

  final Message message;
  final BuildContext context;
  final Map recipient;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

List<IconData> enabledIcons = [CupertinoIcons.hand_thumbsup_fill, CupertinoIcons.heart_fill, CupertinoIcons.hand_thumbsdown_fill, CupertinoIcons.smiley_fill, CupertinoIcons.xmark_circle_fill];
List<IconData> disabledIcons = [CupertinoIcons.hand_thumbsup, CupertinoIcons.heart, CupertinoIcons.hand_thumbsdown, CupertinoIcons.smiley, CupertinoIcons.xmark_circle];

class _ChatListTileState extends State<ChatListTile> {
  bool showTime = false;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = (widget.message.senderID == AuthService().getCurrentUserInfo().uid);
    return Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (widget.message.reactIndex != null && widget.message.reactIndex != 0 && isCurrentUser && widget.message.deleted == null)
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Icon(disabledIcons[widget.message.reactIndex! - 1], size: 18, color: CupertinoColors.inactiveGray)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isCurrentUser)
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 4, right: 8),
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.recipient["photoURL"] == null ? const Color(0x15ffffff) : CupertinoColors.white,
                            image: widget.recipient["photoURL"] == null ? null : DecorationImage(image: NetworkImage(widget.recipient["photoURL"]))),
                        child: widget.recipient["photoURL"] == null ? Text(widget.recipient["displayName"].toString().toUpperCase()[0]) : null),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: widget.message.deleted != null ? const Color(0x10ffffff) : (isCurrentUser ? CupertinoColors.activeBlue : CupertinoColors.activeGreen),
                          border: widget.message.deleted != null ? Border.all(color: const Color(0x20ffffff)) : null,
                          borderRadius: BorderRadius.circular(12).copyWith(bottomRight: isCurrentUser ? const Radius.circular(0) : null, bottomLeft: isCurrentUser ? null : const Radius.circular(0))),
                      child: Text(widget.message.deleted == null ? widget.message.message : "(Message deleted)",
                          style: TextStyle(color: widget.message.deleted != null ? const Color(0x80ffffff) : null, fontStyle: widget.message.deleted != null ? FontStyle.italic : null))),
                ],
              ),
              if (widget.message.reactIndex != null && widget.message.reactIndex != 0 && !isCurrentUser)
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Icon(disabledIcons[widget.message.reactIndex! - 1], size: 18, color: CupertinoColors.inactiveGray)),
            ]),
            if (widget.message.edited != null && widget.message.deleted == null)
              Padding(
                  padding: EdgeInsets.only(top: 2, bottom: showTime ? 0 : 8, left: isCurrentUser ? 0 : 46),
                  child: const Text("(Edited)", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12, fontStyle: FontStyle.italic))),
            if (showTime)
              Padding(
                  padding: EdgeInsets.only(top: 2, bottom: 8, left: isCurrentUser ? 0 : 46),
                  child: Text(
                      widget.message.timestamp.toDate().isBefore(DateTime.now().subtract(const Duration(days: 1)))
                          ? Moment(widget.message.timestamp.toDate()).toString()
                          : Moment(widget.message.timestamp.toDate()).calendar(),
                      style: const TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12))),
          ]),
          onTap: () => setState(() => showTime = !showTime),
          onLongPress: () => showBottomActionSheet(context: context),
        ));
  }

  void showBottomActionSheet({required BuildContext context}) {
    bool isCurrentUser = (widget.message.senderID == AuthService().getCurrentUserInfo().uid);
    if (widget.message.deleted == null) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: CupertinoActionSheet(
                  message: reactButtons(context: context, reactIndex: widget.message.reactIndex),
                  actions: isCurrentUser
                      ? [
                          CupertinoActionSheetAction(onPressed: () => showReplyDialog(context), child: const Text('Edit Message')),
                          CupertinoActionSheetAction(isDestructiveAction: true, onPressed: () => showDeleteConfirmation(context), child: const Text('Delete Message'))
                        ]
                      : null,
                  cancelButton: CupertinoActionSheetAction(onPressed: () => routeBack(context), child: const Text('Close'))),
            );
          });
    }
  }

  Row reactButtons({required BuildContext context, int? reactIndex}) {
    List<Widget> iconButtons = List.generate(
        enabledIcons.length,
        (index) => CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              routeBack(context);
              await FireStoreService().setReactToFireStore(message: widget.message, reactIndex: index + 1);
            },
            child: Icon(disabledIcons[index], size: 20, color: CupertinoColors.inactiveGray)));
    if (reactIndex != null && reactIndex != 0) {
      iconButtons[reactIndex - 1] = CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            routeBack(context);
            await FireStoreService().setReactToFireStore(message: widget.message, reactIndex: 0);
          },
          child: Icon(enabledIcons[reactIndex - 1], size: 26));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: iconButtons);
  }

  void showReplyDialog(BuildContext context) {
    routeBack(context);
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController reply = TextEditingController(text: widget.message.message);
          return CupertinoAlertDialog(
              title: const Padding(padding: EdgeInsets.only(bottom: 10), child: Text('Edit Message')),
              content: CupertinoTextField(
                  controller: reply,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  placeholder: 'Enter updated message...',
                  autofocus: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(color: const Color(0x99000000), borderRadius: BorderRadius.circular(4))),
              actions: <Widget>[
                CupertinoDialogAction(isDestructiveAction: true, child: const Text('Cancel'), onPressed: () => routeBack(context)),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      routeBack(context);
                      await FireStoreService().editMessageFromFireStore(message: widget.message, newMessage: reply.text);
                      await Fluttertoast.showToast(msg: "Message Edited");
                    },
                    child: const Text('Update'))
              ]);
        });
  }

  void showDeleteConfirmation(BuildContext context) {
    routeBack(context);
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(title: const Text('Are you sure?'), actions: <Widget>[
            CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => routeBack(context)),
            CupertinoDialogAction(
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () async {
                  routeBack(context);
                  await FireStoreService().deleteMessageFromFireStore(message: widget.message);
                  await Fluttertoast.showToast(msg: "Message Deleted");
                },
                child: const Text('Delete'))
          ]);
        });
  }
}
