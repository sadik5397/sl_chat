import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/change_password.dart';
import 'package:sl_chat/component/cupertino_header.dart';
import 'package:sl_chat/component/text_field.dart';
import 'package:sl_chat/service/auth_service.dart';

import 'component/button.dart';
import 'component/page_navigation.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User currentUser = AuthService().getCurrentUserInfo();
  late TextEditingController nameController = TextEditingController(text: currentUser.displayName);
  late TextEditingController emailController = TextEditingController(text: currentUser.email);
  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            previousPageTitle: "Inbox",
            trailing: CupertinoButton(padding: EdgeInsets.zero, onPressed: () async => await AuthService().deleteUser(context: context), child: const Icon(CupertinoIcons.delete_solid, size: 24))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(children: [
              const CupertinoHeader(header: "My Profile"),
              const SizedBox(height: 12),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      alignment: Alignment.center,
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0x15ffffff), image: currentUser.photoURL == null ? null : DecorationImage(image: NetworkImage(currentUser.photoURL!))),
                      child: const Icon(CupertinoIcons.camera))),
              const SizedBox(height: 24),
              ThemeTextField(title: "Display Name", floatingTitle: "Display Name", controller: nameController, textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              ThemeTextField(title: "Email Address", floatingTitle: "Email Address (Not Editable)", controller: emailController, textInputAction: TextInputAction.next, isDisable: true),
              const SizedBox(height: 24),
              ThemeButton(
                  title: "Update Profile",
                  isLoading: buttonLoading,
                  onTap: () async {
                    setState(() => buttonLoading = true);
                    await AuthService().updateProfile(name: nameController.text);
                    setState(() => buttonLoading = false);
                  }),
              const SizedBox(height: 12),
              ThemeButton(title: "Change Password", onTap: () => route(context, const ChangePassword()), backgroundColor: CupertinoColors.extraLightBackgroundGray, textColor: CupertinoColors.systemCyan),
              const SizedBox(height: 12),
              ThemeButton(title: "Sign Out", onTap: () => AuthService().signOut(context), backgroundColor: CupertinoColors.destructiveRed, textColor: CupertinoColors.white),
              const SizedBox(height: 24),
              const Text("Created with ♥ by S.a. Sadik", style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12), textAlign: TextAlign.center)
            ])));
  }
}
