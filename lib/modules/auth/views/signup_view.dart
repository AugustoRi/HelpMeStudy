import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/components/auth/button.dart';
import 'package:helpmestudy/components/auth/textfield.dart';
import 'package:helpmestudy/modules/auth/controllers/signup_controller.dart';
import 'package:helpmestudy/routes/app_pages.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.account_box_rounded, size: 100),
                const SizedBox(height: 50),
                Text(
                  'Join us and start your journey!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                AuthTextFieldComponent(
                  controller: controller.usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                AuthTextFieldComponent(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                AuthTextFieldComponent(
                  controller: controller.confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                ButtonAuthComponent(onTap: controller.register),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.login),
                      child: const Text(
                        'Login!',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
