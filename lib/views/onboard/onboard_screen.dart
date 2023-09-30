import 'package:flutter/material.dart';

import '../splashscreen/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBB37D),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFBEEDB), // Background color
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 2.3, // 1/3 of the screen
                  width: double.infinity,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      Image.asset('assets/dogonbrd.png'),
                      Image.asset('assets/catonbrd.png'),
                      Image.asset('assets/parrotonbrd.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3, // Total number of pages
                  (index) => Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align text to center
              children: [
                Text(
                  "Welcome to Your App",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Center align the text
                ),
                SizedBox(height: 10),
                Text(
                  "Your one-stop destination for everything amazing.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center, // Center align the text
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(bottom: 30), // Add bottom padding
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
                // Action when Get Started button is pressed
              },
              child: Text("Get Started"),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFBEEDB), // Use the same background color as the container
              ),
            ),
          ),
        ],
      ),
    );
  }
}
