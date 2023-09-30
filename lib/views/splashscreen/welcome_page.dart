import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/views/registeration/login_page.dart';
import 'package:janwar_x/views/registeration/signup_page.dart';
import 'package:janwar_x/widgets/app_text.dart';

import '../mainscreen/mainscreen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _authGoogle = FirebaseAuth.instance;
  bool isGoogleSignInInProgress = false;

  Future<void> _googleSignInn() async {
    try {
      setState(() {
        isGoogleSignInInProgress = true;
      });
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _authGoogle.signInWithCredential(credential);

      // Save user data to Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
        });

        // Redirect to HomeScreen or perform any other actions
        // Example: Navigating to LandingPage
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return const LandingPage();
            }));
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.$e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isGoogleSignInInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(              padding: EdgeInsets.only(bottom: 100), // Add bottom padding

        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Color(0xFFF6C08B),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 11,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16), // Add bottom padding
              child: Center(
                child: Image.asset(
                  "assets/logo.png", // Replace with your logo image asset
                  width: 150, // Set the desired width
                ),
              ),
            ),
            const SizedBox(
              height: 80 ,
            ),
            const Padding(
              padding: AppPadding.defaultPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "WELCOME!",
                    color: Color(0xFF4F3315),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4F3315),
                      text:
                      "Unleash Joy with PawfectCompanions Where Pets Find You and You Find Pets.")
                ],
              ),
            ),
            const Spacer(),
            Stack(
              children: [
                Padding(
                  padding: AppPadding.defaultPadding,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 22,
                      ),
                      GestureDetector(
                        onTap: () {
                          _googleSignInn();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                              borderRadius: BorderRadius.circular(33),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Set shadow color
                              spreadRadius: 2, // Set the spread radius of the shadow
                              blurRadius: 4, // Set the blur radius of the shadow
                              offset: Offset(0, 2), // Set the offset of the shadow
                            ),
                          ],
                        ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                              ),
                              Image.asset("assets/google.png",
                                height: 30, // Set the desired height
                                width: 30,),
                              const SizedBox(
                                width: 12,
                              ),
                              const AppText(
                                text: "Sign in with Google",
                                color: Colors.white,
                                fontSize: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return SignupPage();
                              }));
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(33),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Set shadow color
                                spreadRadius: 2, // Set the spread radius of the shadow
                                blurRadius: 4, // Set the blur radius of the shadow
                                offset: Offset(0, 2), // Set the offset of the shadow
                              ),
                            ],
                          ),
                          child: const Center(
                            child: AppText(
                              text: "Create an Account",
                              color: Color(0xFF4F3315),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            text: "Already have an account",
                            color: Color(0xFF4F3315),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                            },
                            child: const AppText(
                              text: " Signin?",
                              color: Color(0xFF4F3315),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
