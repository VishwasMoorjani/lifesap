import 'package:country_code_picker/country_code.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/email_checker.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';
import 'package:flutter_grocery/view/screens/auth/otpVerification.dart';
import 'package:flutter_grocery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController;
  bool isChecked = false;
  final FocusNode _emailFocus = FocusNode();
  bool email = true;
  bool phone = false;
  String _countryDialCode = '+880';
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    // Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              Images.app_logo,
                              height: MediaQuery.of(context).size.height / 9,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            AppConstants.APP_NAME,
                            style: poppinsBold.copyWith(
                                fontSize: 16,
                                color: ColorResources.getPrimaryColor(context)),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(children: [
                              Positioned(
                                  top: 1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.903,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.getPrimaryColor(
                                          context),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),

                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    height: 66,
                                    //color: ColorResources.getPrimaryColor(context),
                                    // width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "Please enter your phone number to get access\nto Lifesap Doctors and Lifesap pharmacy",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              /* Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .emailVerification
                              ? Text(
                                  getTranslated('email', context),
                                  style: poppinsRegular.copyWith(
                                      color: ColorResources.getHintColor(context)),
                                )
                              : Text(
                                  getTranslated('mobile_number', context),
                                  style: poppinsRegular.copyWith(
                                      color: ColorResources.getHintColor(context)),
                                ),*/
                              SizedBox(height: 30),
                              /*Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel
                                    .emailVerification
                                ? CustomTextField(
                                    hintText: getTranslated('demo_gmail', context),
                                    isShowBorder: true,
                                    inputAction: TextInputAction.done,
                                    inputType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                  )
                                :*/
                              Positioned(
                                left: 30,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  prefixIcon: CodePickerWidget(
                                                    onChanged: (CountryCode
                                                        countryCode) {
                                                      _countryDialCode =
                                                          countryCode.dialCode;
                                                    },
                                                    initialSelection:
                                                        _countryDialCode,
                                                    favorite: [
                                                      _countryDialCode
                                                    ],
                                                    showDropDownButton: true,
                                                    padding: EdgeInsets.zero,
                                                    showFlagMain: false,
                                                    textStyle: TextStyle(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: ColorResources
                                                            .getPrimaryColor(
                                                                context)),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey))),
                                              cursorColor: ColorResources
                                                  .getPrimaryColor(context),
                                              controller: _emailController,
                                            )),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        !authProvider
                                                .isPhoneNumberVerificationButtonLoading
                                            ? MaterialButton(
                                                elevation: 6,
                                                onPressed: () {
                                                  String _email =
                                                      _emailController.text
                                                          .trim();
                                                  if (_email.isEmpty) {
                                                    if (Provider.of<
                                                                SplashProvider>(
                                                            context,
                                                            listen: false)
                                                        .configModel
                                                        .emailVerification) {
                                                      showCustomSnackBar(
                                                          getTranslated(
                                                              'enter_email_address',
                                                              context),
                                                          context);
                                                    } else {
                                                      showCustomSnackBar(
                                                          getTranslated(
                                                              'enter_phone_number',
                                                              context),
                                                          context);
                                                    }
                                                  } else if (Provider.of<
                                                                  SplashProvider>(
                                                              context,
                                                              listen: false)
                                                          .configModel
                                                          .emailVerification &&
                                                      EmailChecker.isNotValid(
                                                          _email)) {
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'enter_valid_email',
                                                            context),
                                                        context);
                                                  } else {
                                                    if (Provider.of<
                                                                SplashProvider>(
                                                            context,
                                                            listen: false)
                                                        .configModel
                                                        .emailVerification) {
                                                      authProvider
                                                          .checkEmail(_email)
                                                          .then((value) async {
                                                        if (value.isSuccess) {
                                                          authProvider
                                                              .updateEmail(
                                                                  _email);
                                                          if (value.message ==
                                                              'active') {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                              RouteHelper
                                                                  .getVerifyRoute(
                                                                      'sign-up',
                                                                      _email),
                                                              arguments:
                                                                  VerificationScreen(
                                                                      emailAddress:
                                                                          _email,
                                                                      fromSignUp:
                                                                          true),
                                                            );
                                                          } else {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    RouteHelper
                                                                        .createAccount,
                                                                    arguments:
                                                                        CreateAccountScreen());
                                                          }
                                                        }
                                                      });
                                                    } else {
                                                      if (isChecked) {
                                                        authProvider
                                                            .checkPhone(
                                                                _countryDialCode +
                                                                    _email)
                                                            .then(
                                                          (value) async {
                                                            if (value
                                                                .isSuccess) {
                                                              authProvider
                                                                  .updateEmail(
                                                                      _countryDialCode +
                                                                          _email);
                                                              if (value
                                                                      .message ==
                                                                  'active') {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                  RouteHelper.getVerifyRoute(
                                                                      'sign-up',
                                                                      _countryDialCode +
                                                                          _email),
                                                                  arguments: VerificationScreen(
                                                                      emailAddress:
                                                                          _countryDialCode +
                                                                              _email,
                                                                      fromSignUp:
                                                                          true),
                                                                );
                                                              } else {
                                                                // Navigator.of(context).pushNamed(
                                                                //     RouteHelper.createAccount,
                                                                //     arguments:
                                                                //         CreateAccountScreen());
                                                                if (isChecked) {
                                                                  phoneVerification(
                                                                      _countryDialCode,
                                                                      _email,
                                                                      context,
                                                                      false);
                                                                }
                                                              }
                                                            }
                                                          },
                                                        );
                                                        // phoneVerification(
                                                        //     _countryDialCode,
                                                        //     _email,
                                                        //     context,
                                                        //     false);
                                                      }
                                                    }
                                                  }
                                                },
                                                color: ColorResources
                                                    .getPrimaryColor(context),
                                                textColor: Colors.white,
                                                child: Icon(
                                                  Icons.arrow_right_alt,
                                                  size: 26,
                                                ),
                                                padding: EdgeInsets.all(15),
                                                shape: CircleBorder(),
                                              )
                                            : Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(Theme.of(
                                                                context)
                                                            .primaryColor))),
                                      ]),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_LARGE),
                                  child: Divider(height: 1)),
                              Positioned(
                                  top: 130,
                                  left: 30,
                                  child: Text(
                                    'An otp will be sent to this number',
                                    style: poppinsSemiBold.copyWith(
                                        fontSize: 10,
                                        color: ColorResources.getPrimaryColor(
                                            context)),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Positioned(
                                left: 14,
                                top: MediaQuery.of(context).size.height * 0.19,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    authProvider.verificationMessage.length > 0
                                        ? CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            radius: 5)
                                        : SizedBox.shrink(),
                                    Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 14,
                                top: MediaQuery.of(context).size.height * 0.21,
                                child: Row(
                                  children: [
                                    Checkbox(
                                        activeColor:
                                            ColorResources.getPrimaryColor(
                                                context),
                                        value: isChecked,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isChecked = value;
                                          });
                                        }),
                                    RichText(
                                      text: TextSpan(
                                          style: poppinsSemiBold.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color: ColorResources
                                                  .getPrimaryColor(context)),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "By signing up, I agree to "),
                                            TextSpan(
                                                text:
                                                    "The terms and\nconditions",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.grey,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        launch('');
                                                      }),
                                            TextSpan(text: " and"),
                                            TextSpan(
                                                text: " Privacy Policy",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.grey,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        launch('');
                                                      }),
                                            TextSpan(text: " of Lifesap."),
                                          ]),
                                    )
                                  ],
                                ),
                              )
                            ])),
                      ),
                      SizedBox(
                        height: 61,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Why choose Lifesap?",
                            style: poppinsBold.copyWith(
                                fontSize: 18,
                                color: ColorResources.getPrimaryColor(context)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              "Express Medicine Delivery",
                              style: poppinsBold.copyWith(
                                  fontSize: 12,
                                  color:
                                      ColorResources.getPrimaryColor(context)),
                            ),
                            subtitle: Text(
                              "5 Lakh happy customers every day",
                              style: poppinsBold.copyWith(
                                  fontSize: 10, color: Colors.grey),
                            ),
                            leading: Image(
                              image: AssetImage(Images.delivery_truck),
                            ),
                          ),
                          ListTile(
                            leading: Image(
                              image: AssetImage(Images.male_doctor),
                            ),
                            title: Text(
                              "Consult with Lifesap Doctors",
                              style: poppinsBold.copyWith(
                                  fontSize: 12,
                                  color:
                                      ColorResources.getPrimaryColor(context)),
                            ),
                            subtitle: Text(
                              "7000+ doctors available online in 15 min",
                              style: poppinsBold.copyWith(
                                  fontSize: 10, color: Colors.grey),
                            ),
                            /* leading: Image(
                              image: AssetImage(Images.delivery_truck),
                            ),*/
                          ),
                        ],
                      ),
                      // for continue button
                      SizedBox(height: 12),
                      /* !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              buttonText: getTranslated('continue', context),
                              onPressed: () {
                                String _email = _emailController.text.trim();
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
                                      getTranslated('enter_valid_email', context),
                                      context);
                                } else {
                                  if (Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel
                                      .emailVerification) {
                                    authProvider
                                        .checkEmail(_email)
                                        .then((value) async {
                                      if (value.isSuccess) {
                                        authProvider.updateEmail(_email);
                                        if (value.message == 'active') {
                                          Navigator.of(context).pushNamed(
                                            RouteHelper.getVerifyRoute(
                                                'sign-up', _email),
                                            arguments: VerificationScreen(
                                                emailAddress: _email,
                                                fromSignUp: true),
                                          );
                                        } else {
                                          Navigator.of(context).pushNamed(
                                              RouteHelper.createAccount,
                                              arguments: CreateAccountScreen());
                                        }
                                      }
                                    });
                                  } else {
                                    authProvider
                                        .checkPhone(_countryDialCode + _email)
                                        .then(
                                      (value) async {
                                        if (value.isSuccess) {
                                          authProvider.updateEmail(
                                              _countryDialCode + _email);
                                          if (value.message == 'active') {
                                            Navigator.of(context).pushNamed(
                                              RouteHelper.getVerifyRoute(
                                                  'sign-up',
                                                  _countryDialCode + _email),
                                              arguments: VerificationScreen(
                                                  emailAddress:
                                                      _countryDialCode + _email,
                                                  fromSignUp: true),
                                            );
                                          }
                                          // else {
                                          //   Navigator.of(context).pushNamed(
                                          //       RouteHelper.createAccount,
                                          //       arguments:
                                          //           CreateAccountScreen());
                                          // }
                                        }
                                      },
                                    );
                                    phoneVerification(
                                        _countryDialCode, _email, context);
                                  }
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),
    */
                      // for create an account
                      SizedBox(height: 10),
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

void phoneVerification(String countryCode, String phoneNumber,
    BuildContext context, bool isLogin) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
      phoneNumber: countryCode + phoneNumber,
      // forceResendingToken: forceResendToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.signInWithCredential(credential).then((result) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigatorScreen()));
        }).catchError((onError) {
          log(onError);
        });
      },
      verificationFailed: (FirebaseAuthException exception) {
        log(exception.message);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerification(exception.message,
                    exception.message, exception.message, isLogin)));
      },
      codeSent: (String verificationID, var forceResendingToken) {
        log(forceResendingToken.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerification(
                    verificationID, countryCode, phoneNumber, isLogin)));
      },
      codeAutoRetrievalTimeout: (String s) {});
}
