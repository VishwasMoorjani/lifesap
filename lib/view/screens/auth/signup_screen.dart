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
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

import '../menu/menu_screen.dart';

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
  int counter = 0;
  String _countryDialCode = '+880';
  @override
  void initState() async {
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
    // double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                            width: 70,
                            height: 70,
                            child: Image.asset(
                              Images.app_logo,
                              height: MediaQuery.of(context).size.height / 9,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(AppConstants.APP_NAME,
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                  color:
                                      ColorResources.getTitleColor(context))),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.085,
                                    //color: ColorResources.getPrimaryColor(context),
                                    // width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      getTranslated('message', context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                      ),
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
                                left: MediaQuery.of(context).size.width * 0.08,
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
                                              onChanged: (value) {
                                                setState(() {
                                                  //authProvider = null;
                                                });
                                              },
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                        !authProvider
                                                .isPhoneNumberVerificationButtonLoading
                                            ? MaterialButton(
                                                elevation: 6,
                                                onPressed: () {
                                                  setState(() {
                                                    counter = 1;
                                                  });

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
                                                                  phoneVerificationSingUp(
                                                                    _countryDialCode,
                                                                    _email,
                                                                    context,
                                                                    false,
                                                                    true,
                                                                  );
                                                                }
                                                              }
                                                            }
                                                          },
                                                        );
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
                              Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.16,
                                  left:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    getTranslated('otp_sent', context),
                                    style: poppinsSemiBold.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getPrimaryColor(
                                            context)),
                                  )),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.05,
                                top: MediaQuery.of(context).size.height * 0.19,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    authProvider.verificationMessage.length > 0
                                        ? CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 5)
                                        : SizedBox.shrink(),
                                    Text(
                                      authProvider.verificationMessage,
                                      style: poppinsMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.08,
                                top: MediaQuery.of(context).size.height * 0.3,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    !isChecked && (counter == 1)
                                        ? Text(
                                            getTranslated('checkbox', context),
                                            style: poppinsMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.red,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.04,
                                top: MediaQuery.of(context).size.height * 0.24,
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
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            getTranslated('why_choose', context) +
                                AppConstants.APP_NAME +
                                " ?",
                            style: poppinsBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                color: ColorResources.getPrimaryColor(context)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                getTranslated(
                                    'express_medicine_delivery', context),
                                style: poppinsBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.getPrimaryColor(
                                        context)),
                              ),
                              subtitle: Text(
                                getTranslated('5_lakh_happy_customer', context),
                                style: poppinsBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                    color: Colors.grey),
                              ),
                              leading: Image(
                                image: AssetImage(Images.delivery_truck),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Image(
                              image: AssetImage(Images.male_doctor),
                            ),
                            title: Text(
                              getTranslated(
                                  'consult_with_Lifesap_doctors', context),
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color:
                                      ColorResources.getPrimaryColor(context)),
                            ),
                            subtitle: Text(
                              getTranslated(
                                  '7000+_doctors_available_online_in_15_min',
                                  context),
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                  color: Colors.grey),
                            ),
                            /* leading: Image(
                              image: AssetImage(Images.delivery_truck),
                            ),*/
                          ),
                        ],
                      ),
                      // for continue button

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
                      // SizedBox(height: 10),
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

  void phoneVerificationSingUp(
    String countryCode,
    String phoneNumber,
    BuildContext context,
    bool isLogin,
    bool doNavigate,
  ) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    LoadingIndicatorDialog().show(context, 'Verifying PhoneNumber');
    await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phoneNumber,
        // forceResendingToken: forceResendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((result) {
            LoadingIndicatorDialog().dismiss();
            if (doNavigate) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteHelper.menu, (route) => false,
                  arguments: MenuScreen());
            }
          }).catchError((onError) {
            log(onError);
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.message);
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(exception.message)));
          LoadingIndicatorDialog().dismiss();
          showCustomSnackBar(exception.message, context);
        },
        codeSent: (String verificationID, var forceResendingToken) {
          log(forceResendingToken.toString());
          LoadingIndicatorDialog().dismiss();
          if (doNavigate) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpVerification(
                        verificationID, countryCode, phoneNumber, isLogin)));
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          LoadingIndicatorDialog().dismiss();
        });
  }
}

// void phoneVerification(
//   String countryCode,
//   String phoneNumber,
//   BuildContext context,
//   bool isLogin,
//   bool doNavigate,
// ) {
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   _auth.verifyPhoneNumber(
//       phoneNumber: countryCode + phoneNumber,
//       // forceResendingToken: forceResendToken,
//       verificationCompleted: (PhoneAuthCredential credential) {
//         _auth.signInWithCredential(credential).then((result) {
//           if (doNavigate) {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => NavigatorScreen()));
//           }
//         }).catchError((onError) {
//           log(onError);
//         });
//       },
//       verificationFailed: (FirebaseAuthException exception) {
//         log(exception.message);
//         // ScaffoldMessenger.of(context)
//         //     .showSnackBar(SnackBar(content: Text(exception.message)));
//         showCustomSnackBar(exception.message, context);
//       },
//       codeSent: (String verificationID, var forceResendingToken) {
//         log(forceResendingToken.toString());
        
//         if (doNavigate) {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => OtpVerification(
//                       verificationID, countryCode, phoneNumber, isLogin)));
//         }
//       },
//       codeAutoRetrievalTimeout: (String verificationID) {});
// }
