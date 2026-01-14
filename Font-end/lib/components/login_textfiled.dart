import 'package:flutter/material.dart';

class LoginTextfiled extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  const LoginTextfiled({
    super.key,
    this.controller,
    this.hintText = '',
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 119, 201, 226),
            ),
            borderRadius: BorderRadius.circular(20), //  Rounded edges
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 253, 253, 253),
            ),
            borderRadius: BorderRadius.circular(20), //  Rounded edges
          ),
          fillColor: const Color.fromARGB(255, 136, 207, 255),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
