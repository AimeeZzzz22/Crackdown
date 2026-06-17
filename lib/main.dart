import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const CrackdownApp());
}

class CrackdownApp extends StatelessWidget {
  const CrackdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If a user is already logged in (e.g. during hot-restart in dev),
    // skip straight to HomeScreen; otherwise show SignUpScreen.
    final Widget home = AuthService.instance.isLoggedIn
        ? const HomeScreen()
        : const SignUpScreen();

    return MaterialApp(
      title: 'Crackdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: home,
    );
  }
}
