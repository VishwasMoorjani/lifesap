import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/html_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/screens/address/address_screen.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/chat/chat_screen.dart';
import 'package:flutter_grocery/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:flutter_grocery/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_grocery/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter_grocery/view/screens/order/my_order_screen.dart';
import 'package:flutter_grocery/view/screens/settings/setting_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

import '../../../utill/color_resources.dart';
import '../healthcare/doc_consult.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final CustomDrawerController drawerController;
  MainScreen({@required this.drawerController});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final screens = [
    HomeScreen(),
    AllCategoryScreen(),
    DoctorConsult(),
    NotificationScreen(),
    ProfileScreen()
  ];
  List<String> _keys = [];

  @override
  void initState() {
    super.initState();

    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);
    } else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
    //ResponsiveHelper.isWeb() ? SizedBox() : NetworkInfo.checkConnectivity(context);

    /*  _screens = [
      HomeScreen(),
      AllCategoryScreen(),
      CartScreen(),
      MyOrderScreen(),
      AddressScreen(),
      CouponScreen(),
      ChatScreen(),
      SettingsScreen(),
      HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION),
      HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY),
      HtmlViewerScreen(htmlType: HtmlType.ABOUT_US),
    ];*/
    _keys = [
      'home',
      'all_categories',
      'shopping_bag',
      'my_order',
      'address',
      'coupon',
      'live_chat',
      'settings',
      'terms_and_condition',
      'privacy_policy',
      'about_us',
    ];
  }

  var current_index = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (current_index != 0) {
            setState(() {
              current_index = 0;
            });

            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
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
          body: Stack(children: [
            current_index == 0
                ? Container(
                    margin: EdgeInsets.only(top: 30),
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
                        SizedBox(
                          width: 170,
                        ),
                        IconButton(
                          onPressed: () {
                            widget.drawerController.toggle();
                          },
                          icon: Image.asset(Images.more_icon,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: current_index == 0
                      ? MediaQuery.of(context).size.height * 0.8
                      : MediaQuery.of(context).size.height,
                  child: screens[current_index]),
            )
          ]),
        ));
  }
}
