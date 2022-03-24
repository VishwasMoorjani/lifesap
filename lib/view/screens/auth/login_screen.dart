import 'dart:developer';

import 'package:country_code_picker/country_code.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/email_checker.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/auth/otpVerification.dart';
import 'package:flutter_grocery/view/screens/auth/signup_screen.dart';
import 'package:flutter_grocery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_grocery/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _numberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;
  bool email = true;
  bool phone = false;
  String _countryDialCode = '+880';

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber() ??
            null;
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
            null;
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .country)
        .dialCode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: ColorResources.getPrimaryColor(context),
        appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.login_page_bg),
                    fit: BoxFit.fitHeight),
                // color: ColorResources.getPrimaryColor(context),
              ),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) => Form(
                  key: _formKeyLogin,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    //  physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35),

                      //SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Welcome Back !",
                          style: poppinsBold.copyWith(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        "Login to your account",
                        style: poppinsMedium.copyWith(
                            fontSize: 15, color: Colors.white),
                      )),
                      SizedBox(height: 20),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Provider.of<SplashProvider>(context, listen: false)
                              .configModel
                              .emailVerification
                          ? TextField(
                              style: poppinsMedium.copyWith(fontSize: 14),
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: poppinsMedium.copyWith(
                                      color: Colors.grey),
                                  prefixIcon: CodePickerWidget(
                                    onChanged: (CountryCode countryCode) {
                                      _countryDialCode = countryCode.dialCode;
                                    },
                                    initialSelection: _countryDialCode,
                                    favorite: [_countryDialCode],
                                    showDropDownButton: true,
                                    padding: EdgeInsets.zero,
                                    showFlagMain: false,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              cursorColor: Colors.white,
                              controller: _emailController,
                            )
                          : TextField(
                              style: poppinsMedium.copyWith(fontSize: 14),
                              decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  hintStyle: poppinsMedium.copyWith(
                                      color: Colors.grey),
                                  prefixIcon: CodePickerWidget(
                                    onChanged: (CountryCode countryCode) {
                                      _countryDialCode = countryCode.dialCode;
                                    },
                                    initialSelection: _countryDialCode,
                                    favorite: [_countryDialCode],
                                    showDropDownButton: true,
                                    padding: EdgeInsets.zero,
                                    showFlagMain: false,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              cursorColor: Colors.white,
                              controller: _emailController,
                            ),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        fillColor: Colors.transparent,
                        hintText: getTranslated('password_hint', context),
                        prefixIconUrl: Images.password,
                        isShowBorder: false,
                        isPassword: true,
                        isShowSuffixIcon: true,
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        inputAction: TextInputAction.none,
                      ),
                      /*  TextField(
                            obscureText: ,
                            style: poppinsMedium.copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              suffixIcon: true
                              
              ? _passwordController.text != null
                  ? IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Icon(widget.suffixIconUrl,
                              color: ColorResources.getHintColor(context)),
                        )
                      : null
              : null,
                                hintText: "Password",
                                hintStyle:
                                    poppinsMedium.copyWith(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            cursorColor: Colors.white,
                            controller: _passwordController,
                          ),*/
                      SizedBox(height: 20),

                      // for remember me section
                      /*  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  authProvider.toggleRememberMe();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: authProvider.isActiveRememberMe
                                              ? Theme.of(context).primaryColor
                                              : ColorResources.getCardBgColor(
                                                  context),
                                          border: Border.all(
                                              color: authProvider
                                                      .isActiveRememberMe
                                                  ? Colors.transparent
                                                  : Theme.of(context)
                                                      .primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: authProvider.isActiveRememberMe
                                            ? Icon(Icons.done,
                                                color: Colors.white, size: 17)
                                            : SizedBox.shrink(),
                                      ),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      /*  Text(
                                        getTranslated('remember_me', context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_SMALL,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                      )*/
                                    ],
                                  ),*/

<<<<<<< HEAD
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              RouteHelper.forgetPassword,
                              arguments: ForgotPasswordScreen());
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
=======
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RouteHelper.forgetPassword,
                                  arguments: ForgotPasswordScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  Text(
                                    getTranslated('forgot_password', context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getYellow(
                                                context)),
                                  ),
                                ],
                              ),
>>>>>>> 3b57e1712f6f667858a8cf26aa2ec38753618586
                            ),
                            Text(
                              getTranslated('forgot_password', context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.getYellow(context)),
                            ),
                          ],
                        ),
                      ),

                      // SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.loginErrorMessage.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.loginErrorMessage ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        ],
                      ),

                      // for login button
                      // SizedBox(height: 10),
                      !authProvider.isLoading
                          ? CustomButton(
                              margin: 10,
                              buttonText: getTranslated('login', context),
                              onPressed: () async {
                                String _email = _emailController.text.trim();
                                if (!Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel
                                    .emailVerification) {
                                  _email = _countryDialCode +
                                      _emailController.text.trim();
                                }
                                String _password =
                                    _passwordController.text.trim();
                                if (_email.isEmpty) {
                                  if (Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel
                                      .emailVerification) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_email_address', context),
                                        context);
                                  } else {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_phone_number', context),
                                        context);
                                  }
                                } else if (Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel
                                        .emailVerification &&
                                    EmailChecker.isNotValid(_email)) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_valid_email', context),
                                      context);
                                } else if (_password.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated('enter_password', context),
                                      context);
                                } else if (_password.length < 6) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'password_should_be', context),
                                      context);
                                } else {
                                  authProvider
                                      .login(_email, _password)
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      if (authProvider.isActiveRememberMe) {
                                        authProvider.saveUserNumberAndPassword(
                                            _emailController.text, _password);
                                      } else {
                                        authProvider
                                            .clearUserNumberAndPassword();
                                      }
<<<<<<< HEAD
                                      // Navigator.pushNamedAndRemoveUntil(
                                      //     context,
                                      //     RouteHelper.menu,
                                      //     (route) => false,
                                      //     arguments: MenuScreen());
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NavigatorScreen()));
=======
                                    } else if (Provider.of<SplashProvider>(
                                                context,
                                                listen: false)
                                            .configModel
                                            .emailVerification &&
                                        EmailChecker.isNotValid(_email)) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_valid_email', context),
                                          context);
                                    } else if (_password.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_password', context),
                                          context);
                                    } else if (_password.length < 6) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_should_be', context),
                                          context);
                                    } else {
                                      authProvider
                                          .login(_email, _password)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          if (authProvider.isActiveRememberMe) {
                                            authProvider
                                                .saveUserNumberAndPassword(
                                                    _emailController.text,
                                                    _password);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NavigatorScreen()));
                                          } else {
                                            authProvider
                                                .clearUserNumberAndPassword();
                                          }
                                          // Navigator.pushNamedAndRemoveUntil(
                                          //     context,
                                          //     RouteHelper.menu,
                                          //     (route) => false,
                                          //     arguments: MenuScreen());
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             NavigatorScreen()));
                                        }
                                      });
>>>>>>> 3b57e1712f6f667858a8cf26aa2ec38753618586
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),

<<<<<<< HEAD
                      // for create an account
                      // SizedBox(height: 20),
=======
                          // for create an account
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    String _email =
                                        _emailController.text.trim();
                                    log(_email);
                                    phoneVerification(_countryDialCode, _email,
                                        context, true, true);
                                  },
                                  child: Text(
                                    'Login with OTP',
                                    style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: ColorResources.getHintColor(
                                            context)),
                                  ),
                                ),
                              ],
                            ),
                          ),
>>>>>>> 3b57e1712f6f667858a8cf26aa2ec38753618586

                      InkWell(
                        onTap: () {
                          String _email = _emailController.text.trim();
                          phoneVerification(_countryDialCode, _email, context,
                              true, true, false);
                        },
                        child: Text(
                          'Login with OTP',
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: ColorResources.getYellow(context)),
                        ),
                      ),

                      Text(getTranslated('OR', context),
                          style: poppinsRegular.copyWith(
                              fontSize: 15,
                              color: ColorResources.getYellow(context))),

                      InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavigatorScreen()));
                            // Navigator.pushReplacementNamed(context, RouteHelper.menu, arguments: MenuScreen());
                          },
                          child: Text(
                            '${getTranslated('login_as_a', context)} ' +
                                '${getTranslated('guest', context)}',
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: ColorResources.getYellow(context)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            style: poppinsSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: "By continuing, you agree to "),
                              TextSpan(
                                  text: "The terms and conditions",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ColorResources.getYellow(context),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch('');
                                    }),
                              TextSpan(text: " and "),
                              TextSpan(
                                  text: " Privacy Policy",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ColorResources.getYellow(context),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch('');
                                    }),
                              TextSpan(text: " of Lifesap."),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
