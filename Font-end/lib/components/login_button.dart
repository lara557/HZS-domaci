import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap; // Dodato
  const LoginButton({super.key, required this.onTap}); //Izmenjeno

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: ElevatedButton(
        onPressed: onTap, //Izmenjeno
        // Handle button press
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded edges
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
