import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';

import '../home/widget/bottom_navigation.dart';
// import 'package:universal_html/html.dart';

class otpVerification extends StatefulWidget {
  var verificationID;
  var countryCode;
  var phoneNumber;
  var islogin;
  otpVerification(
      this.verificationID, this.countryCode, this.phoneNumber, this.islogin);
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
                    if (widget.islogin) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => NavigatorScreen()));
                    } else {
                      Navigator.of(context).pushNamed(RouteHelper.createAccount,
                          arguments: CreateAccountScreen());
                    }

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
                child: Text('Verify'))
          ],
        ),
      ),
    );
  }
}
