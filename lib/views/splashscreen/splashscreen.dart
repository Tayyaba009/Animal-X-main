import 'package:flutter/material.dart';
import 'package:janwar_x/views/mainscreen/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:janwar_x/views/splashscreen/welcome_page.dart';
import 'package:janwar_x/widgets/app_text.dart';

import '../onboard/onboard_screen.dart';
class SplashScreen extends StatefulWidget {
  @override

  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      // User is already logged in, check Firestore for user data
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot snapshot =
          await firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        // User data exists in Firestore, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
      } else {
        // User data does not exist in Firestore, navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEEDB), // Replace 0xFFFBEEDB with your desired color code
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
            ),
            const AppText(
              text: "PawfectCompanions",
              fontSize: 15,
              fontWeight: FontWeight.w700,
            )
          ],
        ),
      ),
    );
  }
}
