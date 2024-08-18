import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth_service.dart';
import 'component/text_field.dart';
import 'component/button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(middle: Text("SL Chat")),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.chat_bubble_text, size: 48),
            const SizedBox(height: 24),
            const Text("Welcome to SL Chat"),
            const SizedBox(height: 24),
            ThemeTextField(title: "Email", controller: emailController, textInputType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
            const SizedBox(height: 12),
            ThemeTextField(title: "Password", controller: passwordController, obscureText: true, textInputAction: TextInputAction.done),
            const SizedBox(height: 24),
            ThemeButton(
                title: "Sign In",
                onTap: () async {
                  final authService = AuthService();
                  try {
                    await authService.signInWithEmailPassword(email: emailController.text, password: passwordController.text);
                  } on Exception catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                }),
            const SizedBox(height: 12),
            ThemeButton(title: "Sign Up", onTap: () {}, backgroundColor: CupertinoColors.extraLightBackgroundGray, textColor: CupertinoColors.systemCyan)
          ]
        )
      )
    );
  }
}
