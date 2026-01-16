import 'package:flutter/material.dart';
import 'package:hzs_aplikacija/components/login_textfield.dart';
import 'package:hzs_aplikacija/components/login_button.dart';
import 'package:hzs_aplikacija/pages/sign_up_page.dart';
import 'package:hzs_aplikacija/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Za loading indikator

  @override
  void dispose() {
    // Obavezno čišćenje kontrolera
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    // Validacija praznih polja
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.loginUser(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));

        // Očisti kontrolere
        usernameController.clear();
        passwordController.clear();

        // Naviguj na home stranicu (zameni sa svojom home stranicom)
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 177, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                //maskota-pingvin dodavanje slike i njeno pozicioniranje
                Image.asset('lib/imeges/Penguin_temp_img.png', height: 400),
                //welcome back
                const SizedBox(height: 10),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //username textfield
                const SizedBox(height: 20),
                LoginTextField(
                  // ✅ ISPRAVLJEN NAZIV KLASE
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                //password textfield
                const SizedBox(height: 10),
                LoginTextField(
                  // ✅ ISPRAVLJEN NAZIV KLASE
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
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : LoginButton(onTap: loginUser),

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
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
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
      ),
    );
  }
}
