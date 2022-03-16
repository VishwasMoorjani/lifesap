import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_screen.dart';

class NavigatorScreen extends StatefulWidget {
  //const NavigatorScreen({ Key? key }) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int current_index = 0;
  final screens = [
    HomeScreen(),
    AllCategoryScreen(),
    AllCategoryScreen(),
    AllCategoryScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(118, 149, 216, 1),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: current_index,
        onTap: (index) {
          setState(() {
            current_index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bottomnavicons/Vector.png',
              color: current_index == 1
                  ? Color.fromRGBO(118, 149, 216, 1)
                  : Colors.black,
            ),
            label: "Lab Tests",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bottomnavicons/Vector (1).png',
              color: current_index == 2
                  ? Color.fromRGBO(118, 149, 216, 1)
                  : Colors.black,
            ),
            label: "Healthcare",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
