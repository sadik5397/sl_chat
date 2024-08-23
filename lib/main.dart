import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'firebase_options.dart';
import 'theme/dark_theme.dart';
import 'view/auth/sign_in.dart';
import 'view/inbox/home.dart';

/// Entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'SL Chat',
        theme: lightTheme,
        /// StreamBuilder to handle user authentication state.
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CupertinoActivityIndicator())
                : snapshot.hasData
                    ? const Home()
                    : const SignIn()));
  }
}
