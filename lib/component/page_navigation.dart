import 'package:flutter/cupertino.dart';

Future<dynamic> route(BuildContext context, Widget widget) => Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));

Future<dynamic> routeNoAnimation(BuildContext context, Widget widget) =>
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => widget, transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));

Future<dynamic> routeNoBackNoAnimation(BuildContext context, Widget widget) =>
    Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => widget, transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));

dynamic routeBack(BuildContext context) => Navigator.pop(context);

Future<dynamic> routeNoBack(BuildContext context, Widget widget) => Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => widget));
