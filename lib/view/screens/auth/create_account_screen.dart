import 'package:country_code_picker/country_code.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/signup_model.dart';
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
import 'package:flutter_grocery/view/screens/auth/login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountScreen extends StatelessWidget {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .country)
        .dialCode;
    double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => SafeArea(
            child: Scrollbar(
                child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.97,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.register_page_bg),
                      fit: BoxFit.fitHeight),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Center(
                        child: Text("Register",
                            style: poppinsBold.copyWith(
                              fontSize: 28,
                              color: Colors.white,
                            ))),
                    Center(
                      child: Text(getTranslated('create_account', context),
                          style: poppinsMedium.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),

                    // for first name section

                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          CustomTextField(
                            hintText: 'First Name',
                            isShowBorder: true,
                            // prefixIconUrl: Images.user,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          // for last name section

                          // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'Last Name',
                            // prefixIconUrl: Images.user,
                            isShowBorder: true,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _emailFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          // for email section

                          Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .emailVerification
                              ? Row(children: [
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
                                      controller: _numberController,
                                      focusNode: _numberFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.phone,
                                    ),
                                  ),
                                ])
                              : CustomTextField(
                                  //prefixIconUrl: Images.mail,
                                  hintText:
                                      getTranslated('demo_gmail', context),
                                  isShowBorder: true,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                ),

                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          // for password section

                          CustomTextField(
                            hintText: "Password",
                            // prefixIconUrl: Images.password,
                            isPassword: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          CustomTextField(
                            hintText: "Confirm Password",
                            // prefixIconUrl: Images.password,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),

                          SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.registrationErrorMessage.length > 0
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 5)
                                  : SizedBox.shrink(),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage ?? "",
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),

                          // for signup button
                          SizedBox(height: 70),
                          !authProvider.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: CustomButton(
                                    buttonText:
                                        getTranslated('signup', context),
                                    onPressed: () {
                                      String _firstName =
                                          _firstNameController.text.trim();
                                      String _lastName =
                                          _lastNameController.text.trim();
                                      String _number =
                                          _numberController.text.trim();
                                      String _email =
                                          _emailController.text.trim();
                                      String _password =
                                          _passwordController.text.trim();
                                      String _confirmPassword =
                                          _confirmPasswordController.text
                                              .trim();
                                      if (Provider.of<SplashProvider>(context,
                                              listen: false)
                                          .configModel
                                          .emailVerification) {
                                        if (_firstName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_first_name', context),
                                              context);
                                        } else if (_lastName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_last_name', context),
                                              context);
                                        } else if (_number.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_phone_number',
                                                  context),
                                              context);
                                        } else if (_password.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_password', context),
                                              context);
                                        } else if (_password.length < 6) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_should_be',
                                                  context),
                                              context);
                                        } else if (_confirmPassword.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_confirm_password',
                                                  context),
                                              context);
                                        } else if (_password !=
                                            _confirmPassword) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_did_not_match',
                                                  context),
                                              context);
                                        } else {
                                          SignUpModel signUpModel = SignUpModel(
                                            fName: _firstName,
                                            lName: _lastName,
                                            email: authProvider.email,
                                            password: _password,
                                            phone: _number,
                                          );
                                          authProvider
                                              .registration(signUpModel)
                                              .then((status) async {
                                            if (status.isSuccess) {
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
                                            }
                                          });
                                        }
                                      } else {
                                        if (_firstName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_first_name', context),
                                              context);
                                        } else if (_lastName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_last_name', context),
                                              context);
                                        } else if (_email.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_email_address',
                                                  context),
                                              context);
                                        } else if (EmailChecker.isNotValid(
                                            _email)) {
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
                                                  'password_should_be',
                                                  context),
                                              context);
                                        } else if (_confirmPassword.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_confirm_password',
                                                  context),
                                              context);
                                        } else if (_password !=
                                            _confirmPassword) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_did_not_match',
                                                  context),
                                              context);
                                        } else {
                                          SignUpModel signUpModel = SignUpModel(
                                            fName: _firstName,
                                            lName: _lastName,
                                            email: _email,
                                            password: _password,
                                            phone: authProvider.email.trim(),
                                          );
                                          authProvider
                                              .registration(signUpModel)
                                              .then((status) async {
                                            if (status.isSuccess) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NavigatorScreen()));
                                            }
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),

                          SizedBox(height: 30),
                          /* InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        RouteHelper.login,
                                        arguments: LoginScreen());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(
                                              'already_have_account', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                        ),
                                        SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Text(
                                          getTranslated('login', context),
                                          style: poppinsMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context)),
                                        ),*/
                          RichText(
                            text: TextSpan(
                                style: poppinsMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                      text: "By continuing, you agree to "),
                                  TextSpan(
                                      text: "The terms and conditions",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color:
                                            ColorResources.getYellow(context),
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
                                        color:
                                            ColorResources.getYellow(context),
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
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
