import 'package:flutter/cupertino.dart';

class ThemeTextField extends StatelessWidget {
  const ThemeTextField({super.key, required this.title, this.controller, this.obscureText, this.textInputType, this.textInputAction, this.isDisable = false, this.floatingTitle});

  final String title;
  final String? floatingTitle;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool isDisable;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  @override
  Column build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (floatingTitle != null) Padding(padding: const EdgeInsets.only(bottom: 6, left: 2), child: Text(floatingTitle!, style: const TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray))),
      CupertinoTextField(
          enabled: !isDisable,
          textInputAction: textInputAction ?? TextInputAction.none,
          obscureText: obscureText ?? false,
          keyboardType: textInputType,
          decoration: BoxDecoration(border: Border.all(color: const Color(0x22ffffff)), color: const Color(0x44000000), borderRadius: const BorderRadius.all(Radius.circular(6))),
          placeholder: title,
          controller: controller,
          padding: const EdgeInsets.all(14))
    ]);
  }
}
