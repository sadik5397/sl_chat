import 'package:flutter/cupertino.dart';

class CupertinoHeader extends StatelessWidget {
  const CupertinoHeader({super.key, required this.header, this.topMargin = 12, this.horizontalMargin = 0});

  final String header;
  final double topMargin;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8, top: topMargin, left: horizontalMargin, right: horizontalMargin),
        child: Text(header, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(fontSize: 24.0)));
  }
}
