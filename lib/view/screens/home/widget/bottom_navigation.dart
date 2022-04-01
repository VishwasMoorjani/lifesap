import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/notification_provider.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/notification/notification_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/location_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../menu/widget/custom_drawer.dart';

class NavigatorScreen extends StatefulWidget {
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  //CustomDrawerController c = newObject();

  final screens = [
    HomeScreen(),
    AllCategoryScreen(),
    AllCategoryScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];
  @override
  var current_index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 9,
        unselectedFontSize: 9,
        // type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(118, 149, 216, 1),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        elevation: 5,
        currentIndex: current_index,
        onTap: (index) {
          setState(() {
            current_index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.flask),
            label: "Lab Tests",
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 26,
              width: 32,
              child: Image.asset(
                'assets/bottomnavicons/pulse-rate.png',
                fit: BoxFit.cover,
                color: current_index == 2
                    ? Color.fromRGBO(118, 149, 216, 1)
                    : Colors.black,
              ),
            ),
            label: "Healthcare",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bell),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
