import 'package:flutter/cupertino.dart';

class ThemeTextField extends StatelessWidget {
  const ThemeTextField({super.key, required this.title, this.controller, this.obscureText, this.textInputType, this.textInputAction});

  final String title;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  @override
  CupertinoTextField build(BuildContext context) {
    return CupertinoTextField(
        textInputAction: textInputAction ?? TextInputAction.none,
        obscureText: obscureText ?? false,
        keyboardType: textInputType,
        decoration: const BoxDecoration(color: Color(0x44000000), borderRadius: BorderRadius.all(Radius.circular(6))),
        placeholder: title,
        controller: controller,
        padding: const EdgeInsets.all(14));
  }
}
