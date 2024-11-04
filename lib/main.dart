import 'package:flutter/material.dart';
import 'package:helpmestudy/pages/home_page.dart';
import 'package:helpmestudy/pages/signup_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginFormScreen(),
      routes: {
        '/signup': (context) => const SignupFormScreen(),
        '/login': (context) => const LoginFormScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}