import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janwar_x/widgets/appbottom.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart'; // Import the Eva Icons package
import '../../controllers/mainController.dart';
import '../Homescreen/homescreen.dart';
import '../ProfileScreen/profile.dart';
import '../favourite/favourite_page.dart';
import '../sell/sell.dart';

import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  final int currentIndex = 0;
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainPageController mainPageController = Get.put(MainPageController());
    mainPageController.currentIndex = currentIndex;
    return SafeArea(
      child: GetBuilder<MainPageController>(
        init: MainPageController(),
        builder: (_) {
          return Scaffold(
            body: _.mainScreens[_.currentIndex],
            bottomNavigationBar: AppBottomSheetBusiness(
              currentIndex: _.currentIndex,
              onIndexChanged: (index) {
                _.changeScreen(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class BottomNavBar2 extends StatefulWidget {
  const BottomNavBar2({super.key});

  @override
  State<BottomNavBar2> createState() => _BottomNavBar2State();
}

class _BottomNavBar2State extends State<BottomNavBar2> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const HomePage(),
    const SellPage(),
    const FavoritesPage(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GoogleFonts.aBeeZee(color: Colors.black),
        unselectedLabelStyle: GoogleFonts.aBeeZee(color: Colors.grey),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.homeOutline, // Use Eva Icons for home
              color: Colors.white,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.shoppingBagOutline, // Use Eva Icons for shopping bag
              color: Colors.white,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.heartOutline, // Use Eva Icons for heart (favorite)
              color: Colors.white,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.personOutline, // Use Eva Icons for person (profile)
              color: Colors.white,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
