import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hzs_aplikacija/components/login_textfiled.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

@override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Kontroleri unutar State-a
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isLoading = false;

  @override
  void dispose() {
    // Čišćenje resursa
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    // 1. Osnovna provera na klijentu
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('http://10.0.2.2:3000/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (mounted) {
        final data = jsonDecode(response.body);
        
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful! Please sign in.")),
          );
          Navigator.pop(context); // Vrati ga na Login ekran
        } else {
          // Prikaz greške sa servera (npr. "Email već postoji")
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Registration failed")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 177, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          // Dodato da bi moglo da se skroluje kad izađe tastatura
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Mascot - penguin image
                Image.asset('lib/imeges/Penguin_temp_img.png', height: 300),
                // Sign Up title
                const SizedBox(height: 10),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // NOVO: Username polje
                const SizedBox(height: 20),
                LoginTextfiled(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                // Email textfield
                const SizedBox(height: 20),
                LoginTextfiled(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                // Password textfield
                const SizedBox(height: 10),
                LoginTextfiled(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                // Confirm password textfield
                const SizedBox(height: 10),
                LoginTextfiled(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                // Sign up button
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 10.0,
                  ),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.black)
                  : ElevatedButton(
                    onPressed: registerUser,
                    // Handle sign up logic here
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Already have an account? Sign In
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to login page
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
