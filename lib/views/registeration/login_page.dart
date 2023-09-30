import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:janwar_x/widgets/app_input_field.dart';
import 'package:janwar_x/widgets/button2.dart';
import 'package:janwar_x/widgets/app_text.dart';
import 'package:janwar_x/views/registeration/forgot_password.dart';
import 'package:janwar_x/views/mainscreen/mainscreen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _emptyFieldsMessage = ''; // Store the empty fields message

  Future<void> _login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _emptyFieldsMessage = 'Please fill in all fields.';
        });
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Login successful
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return const LandingPage();
            }));
      } else {
        // Login failed
        setState(() {
          _emptyFieldsMessage = 'Invalid email or password.';
        });
      }
    } catch (e) {
      print('Login error: $e');
      setState(() {
        _emptyFieldsMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF6C08B),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 170.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 22.0),
                        Image.asset(
                          "assets/logo.png",
                          height: 77,
                        ),
                        const SizedBox(height: 28.0),
                        _buildUnderlinedTextFieldWithIcon(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.mail,
                        ),
                        const SizedBox(height: 20.0),
                        _buildUnderlinedTextFieldWithIcon(
                          controller: _passwordController,
                          hintText: 'Enter your Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          icon: Icons.lock,
                        ),
                        const SizedBox(height: 15.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const ForgotPassword();
                                }));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              decoration: TextDecoration.underline, // Underline applied
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 25.0), // Increased space
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                        Text(
                          _emptyFieldsMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlinedTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                keyboardType: keyboardType,
                controller: controller,
                obscureText: obscureText,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
