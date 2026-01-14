import 'package:http/http.dart' as http; //Dodato
import 'dart:convert'; //Dodato
import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/components/login_textfiled.dart';
import 'package:hzs_aplikacija/components/login_button.dart';
import 'package:hzs_aplikacija/pages/sign_up_page.dart';

// Import the LoginTextfiled widget - replace with your actual import path
// import 'path/to/login_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> loginUser() async {
    // 10.0.2.2 je adresa tvog kompjutera za Android emulator
    final url = Uri.parse('http://10.0.2.2:3000/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Povezano sa serverom! Odgovor: ${response.body}");
      } else {
        print("Server vratio grešku: ${response.statusCode}");
      }
    } catch (e) {
      print("Greška u povezivanju: $e");
    }
  } //Dodato sve ovo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 177, 243),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              //maskota-pingvin dodavanje slike i njeno pozicioniranje
              Image.asset('lib/imeges/Penguin_temp_img.png', height: 400),
              //welcome back
              const SizedBox(height: 10),
              Text(
                'Welcom back!',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //username textfield
              const SizedBox(height: 20),
              LoginTextfiled(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              //password textfield
              const SizedBox(height: 10),
              LoginTextfiled(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //forgot password
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              ),

              //sign in button
              const SizedBox(height: 10),
              LoginButton(onTap: loginUser),

              //don't have an account? sign up now
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignUpPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(
                                  1.0,
                                  0.0,
                                ); // Slide from right
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up Now',
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
    );
  }
}
