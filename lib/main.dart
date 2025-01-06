import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/pages/home_page.dart';
import 'package:helpmestudy/pages/signup_page.dart';
import 'package:helpmestudy/routes/app_pages.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Application",
      home: Text(AppPages.initial),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => const SignupFormScreen(),
        '/login': (context) => const LoginFormScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}