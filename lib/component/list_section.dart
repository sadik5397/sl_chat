import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/cupertino_header.dart';

class ThemeListSection extends StatelessWidget {
  const ThemeListSection({super.key, required this.children, this.header, this.footer, this.searchController, this.onSearchEntrySubmitted, this.topMargin = 0});

  final List<Widget> children;
  final double? topMargin;
  final String? header;
  final String? footer;
  final TextEditingController? searchController;
  final void Function(String)? onSearchEntrySubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: topMargin),
          if (header != null) CupertinoHeader(header: header!),
          if (searchController != null)
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CupertinoSearchTextField(
                    onSubmitted: onSearchEntrySubmitted,
                    controller: searchController,
                    padding: const EdgeInsets.all(5),
                    prefixIcon: const Padding(padding: EdgeInsets.only(top: 2, right: 2), child: Icon(CupertinoIcons.search, size: 18)))),
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff1c1c1e)), child: Column(children: children)),
          if (footer != null) Padding(padding: const EdgeInsets.only(left: 2, top: 10), child: Text(footer!, style: const TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray))),
          const SizedBox(height: 20)
        ]));
  }
}
