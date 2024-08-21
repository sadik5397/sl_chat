import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/page_navigation.dart';
import 'package:sl_chat/forgot_password.dart';
import 'package:sl_chat/sign_up.dart';
import 'service/auth_service.dart';
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
  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(middle: Text("SL Chat")),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Icon(CupertinoIcons.chat_bubble_text, size: 48),
              const SizedBox(height: 24),
              const Text("Welcome to SL Chat"),
              const SizedBox(height: 24),
              ThemeTextField(autofillHints: AutofillHints.email, title: "Email", controller: emailController, textInputType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              ThemeTextField(autofillHints: AutofillHints.password, title: "Password", controller: passwordController, obscureText: true, textInputAction: TextInputAction.done),
              const SizedBox(height: 24),
              ThemeButton(title: "Sign In", onTap: () async => await AuthService().signInWithEmailPassword(email: emailController.text, password: passwordController.text)),
              const SizedBox(height: 12),
              ThemeButton(title: "Sign Up", onTap: () => route(context, const SignUp()), backgroundColor: CupertinoColors.extraLightBackgroundGray, textColor: CupertinoColors.systemCyan),
              const SizedBox(height: 12),
              ThemeButton(title: "Forgot Password?", onTap: () => route(context, const ForgotPassword()), textOnly: true, textColor: CupertinoColors.activeBlue)
            ])));
  }
}
