import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:janwar_x/widgets/button2.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_field.dart';
import '../../widgets/app_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    final String email = emailController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });

      await auth.sendPasswordResetEmail(email: email);

      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Successfully sent email to $email');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error sending password reset email: $e');
      // You can show an error message to the user here if needed
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        color: Color(0xFFF6C08B),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
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
                      const Row(
                        children: [
                          AppText(
                            text: "Forgot Password?",
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppInputField(
                        hintText: "Type Email here",
                        controller: emailController,
                        prefixIcon: const Icon(Icons.email, color: Colors.black,),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _sendPasswordResetEmail,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Resend Email'),
                      ),
                      const SizedBox(
                        height: 27,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Go Back',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
