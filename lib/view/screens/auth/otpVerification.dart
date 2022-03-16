import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/email_checker.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code.dart';
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
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';
import 'package:flutter_grocery/view/screens/auth/otpVerification.dart';
import 'package:flutter_grocery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:universal_html/html.dart';

class otpVerification extends StatefulWidget {
  var verificationID;
  var countryCode;
  var phoneNumber;
  otpVerification(this.verificationID, this.countryCode, this.phoneNumber);
  @override
  State<otpVerification> createState() => _otpVerificationState();
}

class _otpVerificationState extends State<otpVerification> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: Text('yay!!' + widget.verificationID),
        body: Column(
          children: [
            Text('yay!!' + widget.verificationID),
            CustomTextField(
              controller: otpController,
            ),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationID,
                      smsCode: otpController.text);
                  auth.signInWithCredential(credential).then((value) {
                    Navigator.of(context).pushNamed(RouteHelper.createAccount,
                        arguments: CreateAccountScreen());
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (contex) => NavigatorScreen()));
                    // accountScreen(widget.countryCode, widget.phoneNumber);
                    // authProvider.checkPhone(widget.countryCode + widget.phoneNumber).then(
                    //   (value) async {
                    //     if (value.isSuccess) {
                    //       authProvider.updateEmail(widget.countryCode + widget.phoneNumber);
                    //       if (value.message == 'active') {
                    //         Navigator.of(context).pushNamed(
                    //           RouteHelper.getVerifyRoute(
                    //               'sign-up', widget.countryCode + widget.phoneNumber),
                    //           arguments: VerificationScreen(
                    //               emailAddress: widget.countryCode + widget.phoneNumber,
                    //               fromSignUp: true),
                    //         );
                    //       } else {
                    //         Navigator.of(context).pushNamed(
                    //             RouteHelper.createAccount,
                    //             arguments: CreateAccountScreen());
                    //       }
                    //     }
                    //   },
                    // );
                  });
                },
                child: Text('VErify'))
          ],
        ),
      ),
    );
  }
}

class accountScreen extends StatefulWidget {
  var countryCode;
  var phoneNumber;
  accountScreen(this.countryCode, this.phoneNumber);
  @override
  State<accountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<accountScreen> {
  TextEditingController _emailController;
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

    return Scaffold(
        body: Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Container(
                  width: _width > 700 ? 700 : _width,
                  padding: _width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : null,
                  decoration: _width > 700
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        )
                      : null,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              Images.app_logo,
                              height: MediaQuery.of(context).size.height / 4.5,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                            child: Text(
                          getTranslated('signup', context),
                          style: poppinsMedium.copyWith(
                              fontSize: 24,
                              color: ColorResources.getTextColor(context)),
                        )),
                        SizedBox(height: 35),
                        Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .emailVerification
                            ? Text(
                                getTranslated('email', context),
                                style: poppinsRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                              )
                            : Text(
                                getTranslated('mobile_number', context),
                                style: poppinsRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                              ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Provider.of<SplashProvider>(context, listen: false)
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
                            : Row(children: [
                                CodePickerWidget(
                                  onChanged: (CountryCode countryCode) {
                                    _countryDialCode = countryCode.dialCode;
                                  },
                                  initialSelection: _countryDialCode,
                                  favorite: [_countryDialCode],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .color),
                                ),
                                Expanded(
                                    child: CustomTextField(
                                  hintText:
                                      getTranslated('number_hint', context),
                                  isShowBorder: true,
                                  controller: _emailController,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                )),
                              ]),
                        SizedBox(height: 6),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Divider(height: 1)),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authProvider.verificationMessage.length > 0
                                ? CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 5)
                                : SizedBox.shrink(),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.verificationMessage ?? "",
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

                        // for continue button
                        SizedBox(height: 12),
                        !authProvider.isPhoneNumberVerificationButtonLoading
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
                                                arguments:
                                                    CreateAccountScreen());
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
                                                        _countryDialCode +
                                                            _email,
                                                    fromSignUp: true),
                                              );
                                            } else {
                                              Navigator.of(context).pushNamed(
                                                  RouteHelper.createAccount,
                                                  arguments:
                                                      CreateAccountScreen());
                                            }
                                          }
                                        },
                                      );
                                      // phoneVerification(
                                      //     _countryDialCode, _email, context);
                                    }
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor))),

                        // for create an account
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(
                                      'already_have_account', context),
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color:
                                          ColorResources.getHintColor(context)),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                  getTranslated('login', context),
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color:
                                          ColorResources.getTextColor(context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
