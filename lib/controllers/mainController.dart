import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:janwar_x/views/Homescreen/homescreen.dart';
import 'package:janwar_x/views/favourite/favourite_page.dart';
import 'package:janwar_x/views/sell/sell.dart';

import '../views/ProfileScreen/profile.dart';


class MainPageController extends GetxController {
  int currentIndex = 0;
  List<Widget> mainScreens = [
     const HomePage(),
     const SellPage(),
     const FavoritesPage(),
    const Profile(),
  ];

  changeScreen(int index) {
    currentIndex = index;
    update();
  }
}
