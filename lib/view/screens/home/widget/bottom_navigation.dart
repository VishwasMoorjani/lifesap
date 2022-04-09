import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/notification_provider.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/healthcare/doc_consult.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/notification/notification_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

import '../../../../helper/route_helper.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/location_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';
import '../../menu/widget/custom_drawer.dart';

class NavigatorScreen extends StatefulWidget {
  final CustomDrawerController drawerController;
  NavigatorScreen({@required this.drawerController});
  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  //CustomDrawerController c = newObject();

  final screens = [
    HomeScreen(),
    AllCategoryScreen(),
    DoctorConsult(),
    NotificationScreen(),
    ProfileScreen()
  ];
  @override
  var current_index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        current_index == 0
            ? Container(
                height: 300,
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      child: Image(
                        image: AssetImage(Images.app_logo),
                      ),
                    ),
                    Text(
                      AppConstants.APP_NAME,
                      style: poppinsBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        color: ColorResources.getTitleColor(context),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.drawerController.toggle();
                        },
                        icon: Icon(Icons.arrow_back))
                  ],
                ),
              )
            : SizedBox.shrink(),
        Positioned(
          top: 150,
          bottom: 0,
          // alignment: Alignment.center,
          child: screens[current_index],
        )
      ]),
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
