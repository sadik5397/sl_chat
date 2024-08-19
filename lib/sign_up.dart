import 'package:flutter/cupertino.dart';
import 'service/auth_service.dart';
import 'component/button.dart';
import 'component/page_navigation.dart';
import 'component/text_field.dart';

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
        child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: ListView(shrinkWrap: true, children: [
              const Icon(CupertinoIcons.chat_bubble_text, size: 48),
              const SizedBox(height: 24),
              const Text("Please Register an Account", textAlign: TextAlign.center),
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
                  onTap: () async => await AuthService()
                      .signUpWithEmailPassword(name: nameController.text, email: emailController.text, password: passwordController.text, rePassword: rePasswordController.text, context: context)),
              const SizedBox(height: 12),
              ThemeButton(title: "Go Back Sign In", onTap: () => routeBack(context), textOnly: true, textColor: CupertinoColors.activeBlue)
            ])));
  }
}
