import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/cupertino_header.dart';
import 'package:sl_chat/component/text_field.dart';
import 'package:sl_chat/service/auth_service.dart';
import 'component/button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  User currentUser = AuthService().getCurrentUserInfo();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(previousPageTitle: "My Profile"),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(children: [
              const CupertinoHeader(header: "Change Password"),
              const SizedBox(height: 12),
              ThemeTextField(title: "New Password", floatingTitle: "New Password", controller: passwordController, textInputAction: TextInputAction.next, obscureText: true),
              const SizedBox(height: 12),
              ThemeTextField(title: "Confirm Password", floatingTitle: "Confirm Password", controller: rePasswordController, textInputAction: TextInputAction.next, obscureText: true),
              const SizedBox(height: 24),
              ThemeButton(title: "Update Password", onTap: () async => await AuthService().changePassword(password: passwordController.text, rePassword: rePasswordController.text))
            ])));
  }
}
