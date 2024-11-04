import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
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

              const SizedBox(height: 50),

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
              ),

              const SizedBox(height: 50),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                }, 
                child: const Text(
                'Register!',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
                  ),
                )
              )
            ]
          )
        ),
      )
    );
  }
}