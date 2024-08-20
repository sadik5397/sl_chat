import 'package:flutter/cupertino.dart';

class ThemeTextField extends StatelessWidget {
  const ThemeTextField(
      {super.key,
      required this.title,
      this.controller,
      this.obscureText = false,
      this.textInputType,
      this.textInputAction,
      this.isDisable = false,
      this.floatingTitle,
      this.autofillHints,
      this.endChild,
      this.autoFocus = false});

  final String title;
  final String? floatingTitle, autofillHints;
  final TextEditingController? controller;
  final bool obscureText, isDisable, autoFocus;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Widget? endChild;

  @override
  Column build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (floatingTitle != null) Padding(padding: const EdgeInsets.only(bottom: 6, left: 2), child: Text(floatingTitle!, style: const TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray))),
      CupertinoTextField(
          autofocus: autoFocus,
          autofillHints: autofillHints != null ? [autofillHints!] : null,
          enabled: !isDisable,
          textInputAction: textInputAction ?? TextInputAction.none,
          obscureText: obscureText,
          keyboardType: textInputType,
          suffix: endChild,
          decoration: BoxDecoration(border: Border.all(color: const Color(0x60ffffff)), color: const Color(0x09ffffff), borderRadius: const BorderRadius.all(Radius.circular(6))),
          placeholder: title,
          controller: controller,
          padding: const EdgeInsets.all(14))
    ]);
  }
}
