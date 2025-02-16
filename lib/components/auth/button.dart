import 'package:flutter/material.dart';

class ButtonAuthComponent extends StatelessWidget {

  final Function()? onTap;
  final String? label;

  const ButtonAuthComponent({super.key, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(15),
        
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label ?? 'Sign In',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}