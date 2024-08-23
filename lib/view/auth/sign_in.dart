import 'package:flutter/cupertino.dart';
import 'package:sl_chat/component/page_navigation.dart';

import '../../component/button.dart';
import '../../component/text_field.dart';
import '../../service/auth_service.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

// Class for the Sign In screen
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// State for the Sign In screen
class _SignInState extends State<SignIn> {
  // TextEditingController for email input
  TextEditingController emailController = TextEditingController();
  // TextEditingController for password input
  TextEditingController passwordController = TextEditingController();
  // Boolean to track button loading state
  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Icon for the Sign In screen
              const Icon(CupertinoIcons.chat_bubble_text, size: 48),
              const SizedBox(height: 24),
              // Text for the Sign In screen
              const Text("Welcome to SL Chat"),
              const SizedBox(height: 24),
              // ThemeTextField for email input
              ThemeTextField(
                  autofillHints: AutofillHints.email,
                  title: "Email",
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              // ThemeTextField for password input
              ThemeTextField(autofillHints: AutofillHints.password, title: "Password", controller: passwordController, obscureText: true, textInputAction: TextInputAction.done),
              const SizedBox(height: 24),
              // ThemeButton for Sign In
              ThemeButton(title: "Sign In", onTap: () async => await AuthService().signInWithEmailPassword(email: emailController.text, password: passwordController.text)),
              const SizedBox(height: 12),
              // ThemeButton for Sign Up
              ThemeButton(
                  title: "Sign Up", onTap: () => route(context, const SignUp()), backgroundColor: CupertinoColors.extraLightBackgroundGray, textColor: CupertinoColors.systemCyan),
              const SizedBox(height: 12),
              // ThemeButton for Sign In with Google
              ThemeButton(
                  title: "Continue with Google", onTap: () async => await AuthService().signInWithGoogle(), backgroundColor: CupertinoColors.activeGreen),
              const SizedBox(height: 12),
              // ThemeButton for Forgot Password
              ThemeButton(title: "Forgot Password?", onTap: () => route(context, const ForgotPassword()), textOnly: true, textColor: CupertinoColors.activeBlue)
            ])));
  }
}
