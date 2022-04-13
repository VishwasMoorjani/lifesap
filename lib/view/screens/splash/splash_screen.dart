import 'dart:async';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';
import 'package:flutter_grocery/view/screens/auth/login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/signup_screen.dart';
import 'package:flutter_grocery/view/screens/menu/main_screen.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:flutter_grocery/view/screens/onboarding/on_boarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  String _countryDialCode;
  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        print('-----------------${isNotConnected ? 'Not' : 'Yes'}');
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)
                : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .maintenanceMode) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteHelper.getMaintenanceRoute(), (route) => false);
        } else {
          Timer(Duration(seconds: 0), () async {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteHelper.menu, (route) => false,
                  arguments: MenuScreen());
            } else {}
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _globalKey,
        body: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => Column(
                  children: [
                    /* ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteHelper.createAccount,
                      arguments: CreateAccountScreen());
                },
                child: Text("nnedd")),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Svg(Images.get_started_bg),
                        fit: BoxFit.fitHeight,
                      )),
                      child: Center(
                        child: Column(children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(Images.app_logo),
                                  ),
                                ),
                                Text(AppConstants.APP_NAME,
                                    style: poppinsBold.copyWith(
                                        fontSize: 40,
                                        color: ColorResources.getTitleColor(
                                            context)))
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.58),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: ColorResources.getPrimaryColor(context)),
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: !((Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel) ==
                                    null)
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation: MaterialStateProperty.all(6),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ))),
                                    onPressed: () {
                                      _countryDialCode =
                                          CountryCode.fromCountryCode(
                                                  Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .configModel
                                                      .country)
                                              .dialCode;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen(
                                                      _countryDialCode)));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15),
                                        Text(
                                          getTranslated('get_started', context),
                                          style: poppinsSemiBold.copyWith(
                                              fontSize: 22),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08),
                                        Icon(Icons.login),
                                      ],
                                    ))
                                : Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  )),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.008,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => LoginScreen()));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => LoginScreen())));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('already_a_member', context),
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color:
                                          ColorResources.getHintColor(context)),
                                ),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  getTranslated('login', context),
                                  style: poppinsMedium.copyWith(
                                      decoration: TextDecoration.underline,
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.getPrimaryColor(
                                          context)),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ],
                )));
  }
}
