import 'package:flutter/cupertino.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key, required this.title, this.backgroundColor, this.textColor, this.bold, this.onTap, this.textOnly, this.isLoading});

  final String title;
  final Color? backgroundColor, textColor;
  final bool? bold, textOnly, isLoading;
  final void Function()? onTap;

  @override
  Row build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: CupertinoButton(
              onPressed: onTap,
              color: textOnly == true ? null : (backgroundColor ?? CupertinoColors.activeBlue),
              child: isLoading == true ? const CupertinoActivityIndicator() : Text(title, style: TextStyle(color: textColor ?? CupertinoColors.white, fontWeight: bold == true ? FontWeight.bold : FontWeight.normal))))
    ]);
  }
}
