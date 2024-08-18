import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'auth/auth_service.dart';
import 'component/text_field.dart';
import 'component/button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(middle: Text("SL Chat")),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Icon(CupertinoIcons.chat_bubble_text, size: 48),
              const SizedBox(height: 24),
              const Text("Please Register an Account"),
              const SizedBox(height: 24),
              ThemeTextField(title: "Your Name", controller: nameController, textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              ThemeTextField(title: "Email", controller: emailController, textInputType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              ThemeTextField(title: "Password", controller: passwordController, obscureText: true, textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              ThemeTextField(title: "Confirm Password", controller: rePasswordController, obscureText: true, textInputAction: TextInputAction.done),
              const SizedBox(height: 24),
              ThemeButton(
                  title: "Sign Up",
                  onTap: () async {
                    try {
                      await AuthService().signUpWithEmailPassword(email: emailController.text, password: passwordController.text);
                    } on Exception catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  }),
              const SizedBox(height: 12),
              ThemeButton(title: "Go Back Sign In", onTap: routeBack(context), textOnly: true, textColor: CupertinoColors.activeBlue)
            ])));
  }
}
