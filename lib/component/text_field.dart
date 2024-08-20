import 'package:flutter/cupertino.dart';

class ThemeTextField extends StatelessWidget {
  const ThemeTextField({super.key, required this.title, this.controller, this.obscureText, this.textInputType, this.textInputAction, this.isDisable = false, this.floatingTitle, this.autofillHints});

  final String title;
  final String? floatingTitle;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool isDisable;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? autofillHints;

  @override
  Column build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (floatingTitle != null) Padding(padding: const EdgeInsets.only(bottom: 6, left: 2), child: Text(floatingTitle!, style: const TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray))),
      CupertinoTextField(
          autofillHints: autofillHints != null ? [autofillHints!] : null,
          enabled: !isDisable,
          textInputAction: textInputAction ?? TextInputAction.none,
          obscureText: obscureText ?? false,
          keyboardType: textInputType,
          decoration: BoxDecoration(border: Border.all(color: const Color(0x60ffffff)), color: const Color(0x09ffffff), borderRadius: const BorderRadius.all(Radius.circular(6))),
          placeholder: title,
          controller: controller,
          padding: const EdgeInsets.all(14))
    ]);
  }
}
