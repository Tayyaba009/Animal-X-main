import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class AppBottomSheetBusiness extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onIndexChanged;
  const AppBottomSheetBusiness({
    Key? key,
    this.currentIndex = 0,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: Container(
        height: 80, // Adjust the height of the navigation bar
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: currentIndex * (MediaQuery.of(context).size.width / 4),
              child: Container(
                color: Colors.white,
                height: 3,
                width: MediaQuery.of(context).size.width / 4, // Adjust the width of the highlight line
              ),
            ),
            BottomNavigationBar(
              backgroundColor: Color(0xFFF6C08B),
              currentIndex: currentIndex,
              useLegacyColorScheme: false,
              onTap: onIndexChanged,
              showSelectedLabels: false,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              selectedIconTheme: IconThemeData(color: Colors.white, size: 28),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min, // Add this line
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        EvaIcons.homeOutline,
                        color: currentIndex == 0
                            ? Colors.white
                            : Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: currentIndex == 0
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min, // Add this line
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        EvaIcons.shoppingBagOutline,
                        color: currentIndex == 1
                            ? Colors.white
                            : Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sell',
                        style: TextStyle(
                          color: currentIndex == 1
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        EvaIcons.heartOutline,
                        color: currentIndex == 2
                            ? Colors.white
                            : Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Favorites',
                        style: TextStyle(
                          color: currentIndex == 2
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        EvaIcons.personOutline,
                        color: currentIndex == 3
                            ? Colors.white
                            : Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: currentIndex == 3
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
