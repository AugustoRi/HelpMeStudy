import 'package:flutter/material.dart';
import 'package:helpmestudy/components/api/routes.dart';
import 'package:helpmestudy/components/auth/button.dart';
import 'package:helpmestudy/components/auth/textfield.dart';

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match${passwordController.text}${confirmPasswordController.text}'),
        ),
      );
      return;
    }

    final response = await register(usernameController.text, passwordController.text);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful'),
        ),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed'),
        ),
      );
    }
  }
  
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
          
                const Icon(
                  Icons.account_box_rounded,
                  size: 100,
                ),
          
                const SizedBox(height: 50),
                
                Text(
                  'Join us and start your journey!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                const SizedBox(height: 25),
              
                AuthTextFieldComponent(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
          
                const SizedBox(height: 15),
              
                AuthTextFieldComponent(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 15),
              
                AuthTextFieldComponent(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 15),
          
                ButtonAuthComponent(onTap: () {
                  _register();
                }),
          
                const SizedBox(height: 100),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
          
                    const SizedBox(width: 4),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      }, 
                      child: const Text(
                      'Login!',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                        ),
                      )
                    )
                  ],
                )
            ],),
          ),
        ),
      )
    );
  }
}