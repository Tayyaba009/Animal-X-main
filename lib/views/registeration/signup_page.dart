import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/widgets/app_input_field.dart';
import '../../services/signup_services.dart';
import '../../widgets/button2.dart';
import '../mainscreen/mainscreen.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  bool _isLoading = false; // Add isLoading state

  String _emptyFieldsMessage = ''; // Store the empty fields message

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String name = _nameController.text.trim();
      String phone = _phoneController.text.trim();

      setState(() {
        _isLoading = true; // Update isLoading to true
      });

      String uid = await _firebaseService.signUpWithEmailAndPassword(email, password);

      if (uid.isNotEmpty) {
        await _firebaseService.createFirestoreDocument(uid, name, email, phone);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LandingPage();
        }));
      } else {
        setState(() {
          _isLoading = false; // Update isLoading to false if signup fails
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6C08B),
        ),
        child: Padding(
          padding: AppPadding.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 130.0),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Image.asset(
                        "assets/logo.png",
                        height: 77,
                      ),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildUnderlinedTextField(
                              controller: _nameController,
                              hintText: 'Name',
                              prefixIcon: Icons.person,
                            ),
                            _buildUnderlinedTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              prefixIcon: Icons.email,
                            ),
                            _buildUnderlinedTextField(
                              controller: _phoneController,
                              hintText: 'Phone',
                              prefixIcon: Icons.phone, ),
                            _buildUnderlinedTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              obscureText: true,
                            ),
                            SizedBox(height: 10),
                            Text(
                              _emptyFieldsMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                bool fieldsEmpty = false;
                                String emptyFieldsMessage = '';

                                if (_nameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _phoneController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  fieldsEmpty = true;

                                  if (_nameController.text.isEmpty) {
                                    emptyFieldsMessage += 'Name, ';
                                  }

                                  if (_emailController.text.isEmpty) {
                                    emptyFieldsMessage += 'Email, ';
                                  }

                                  if (_phoneController.text.isEmpty) {
                                    emptyFieldsMessage += 'Phone, ';
                                  }

                                  if (_passwordController.text.isEmpty) {
                                    emptyFieldsMessage += 'Password, ';
                                  }

                                  emptyFieldsMessage =
                                      emptyFieldsMessage.substring(0, emptyFieldsMessage.length - 2);

                                  setState(() {
                                    _emptyFieldsMessage = 'Please fill in the following fields: $emptyFieldsMessage';
                                    _isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = true; // Update isLoading to true
                                    _emptyFieldsMessage = ''; // Clear the empty fields message
                                  });
                                  _signUp();
                                }
                              },
                              child: Text('Sign Up'),
                            ),
                          ],
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

  Widget _buildUnderlinedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: controller,
          obscureText: obscureText,
            decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            prefixIcon: Icon(prefixIcon),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
