import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/components/login_textfiled.dart';
import 'package:hzs_aplikacija/pages/home_page.dart';
import 'package:hzs_aplikacija/models/user_profile.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  // Text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _handleSignUp(BuildContext context) {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Initialize user profile with the provided name and email
    final userProfile = UserProfile();
    userProfile.initializeProfile(
      name: nameController.text,
      email: emailController.text,
    );

    // Navigate to home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 177, 243),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Mascot - penguin image
                Image.asset('lib/imeges/Penguin_temp_img.png', height: 250),
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
                // Name textfield
                const SizedBox(height: 20),
                LoginTextfiled(
                  controller: nameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),
                // Email textfield
                const SizedBox(height: 10),
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
                child: ElevatedButton(
                  onPressed: () {
                    _handleSignUp(context);
                  },
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
