import 'package:flutter/cupertino.dart';

import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../component/text_field.dart';
import '../../service/auth_service.dart';

///  Forgot Password Screen
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ///  Controller for the email text field
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///  State variable to track the button loading state

    return CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(middle: Text("SL Chat")),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Icon(CupertinoIcons.chat_bubble_text, size: 48),
              const SizedBox(height: 24),
              const Text("Forgot Password?"),
              const SizedBox(height: 24),
              ThemeTextField(
                  autofillHints: AutofillHints.email,
                  title: "Email",
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (p0) async => await AuthService().restPasswordRequest(email: emailController.text).then((value) => emailController.clear())),
              const SizedBox(height: 24),
              ThemeButton(title: "Reset Password", onTap: () async => await AuthService().restPasswordRequest(email: emailController.text).then((value) => emailController.clear())),
              const SizedBox(height: 12),
              ThemeButton(title: "Go Back Sign In", onTap: () => routeBack(context), textOnly: true, textColor: CupertinoColors.activeBlue)
            ])));
  }
}
