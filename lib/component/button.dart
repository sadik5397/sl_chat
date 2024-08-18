import 'package:flutter/cupertino.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key, required this.title, this.backgroundColor, this.textColor, this.bold, this.onTap});

  final String title;
  final Color? backgroundColor, textColor;
  final bool? bold;
  final void Function()? onTap;

  @override
  Row build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: CupertinoButton(
              onPressed: onTap,
              color: backgroundColor ?? CupertinoColors.activeBlue,
              child: Text(title, style: TextStyle(color: textColor ?? CupertinoColors.white, fontWeight: bold == true ? FontWeight.bold : FontWeight.normal))))
    ]);
  }
}
