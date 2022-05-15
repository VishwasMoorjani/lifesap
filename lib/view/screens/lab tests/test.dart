import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../provider/auth_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/styles.dart';
import '../auth/widget/loading.dart';

class Test extends StatefulWidget {
  final name;
  final precautions;
  final price;
  final testid;

  Test({this.name, this.price, this.precautions, this.testid});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _address = TextEditingController();

  Future<dynamic> addTest(BuildContext context, String testid, date, time, name,
      age, adress) async {
    final uid = (await Provider.of<ProfileProvider>(context, listen: false)
            .getUserID(context))
        .toString();
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/add-patient'));
    request.bodyFields = {'name': name, 'age': age, 'id': uid};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
    } else {
      log(response.reasonPhrase);
    }
//
    var headers1 = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request1 = http.Request(
        'PUT',
        Uri.parse(
            'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/test/$uid/$testid'));
    request1.bodyFields = {'date': date, 'time': time, 'address': adress};
    request1.headers.addAll(headers1);

    http.StreamedResponse response1 = await request1.send();
    log(response1.statusCode.toString());
    if (response1.statusCode == 200) {
      log(await response1.stream.bytesToString());
    } else {
      log(response1.reasonPhrase);
    }
  }

  var _isLoggedIn;
  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  var cost;
  Future<void> openCheckout1() async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': num.parse(cost.toString()) * 100,
      'name': 'LAB TEST',
      'description': 'Payment',
      'prefill': {'contact': "", 'email': ""},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  var test_id;
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    LoadingIndicatorDialog().show(context, 'Please wait');
    String name = 'name';
    String age = '10';
    await addTest(context, test_id, selectedDate.toString().substring(0, 11),
        selectedTime.format(context), _name.text, _age.text, _address.text);
    LoadingIndicatorDialog().dismiss();
    Fluttertoast.showToast(msg: "SUCCESS: ");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: ");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ");
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        // selectedTime = picked_s.format(context);
      });
  }

  DateTime _datetime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: ColorResources.getCardBgColor(context),
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: "Lab Test",
              isElevation: true,
            ),
            body: SafeArea(
                child: Scrollbar(
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    widget.name,
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.getPrimaryColor(
                                            context),
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    "Price: Rs. " + widget.price,
                                    style:
                                        poppinsSemiBold.copyWith(fontSize: 14),
                                  ),
                                  trailing: Image(
                                    image: AssetImage("assets/image/7.png"),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 5,
                                    color: Color(0xFF77B4FF),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Precautions:",
                                              style: poppinsSemiBold.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              widget.precautions,
                                              style: poppinsRegular.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                Center(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        cursorColor:
                                            ColorResources.getPrimaryColor(
                                                context),
                                        decoration: InputDecoration(
                                          hintText: "Name",
                                          hintStyle: poppinsMedium.copyWith(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          focusColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context))),
                                        ),
                                        controller: _name,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        cursorColor:
                                            ColorResources.getPrimaryColor(
                                                context),
                                        decoration: InputDecoration(
                                          hintText: "Age",
                                          hintStyle: poppinsMedium.copyWith(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          focusColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context))),
                                        ),
                                        controller: _age,
                                      ),
                                      TextFormField(
                                        cursorColor:
                                            ColorResources.getPrimaryColor(
                                                context),
                                        decoration: InputDecoration(
                                          hintText: "Address",
                                          hintStyle: poppinsMedium.copyWith(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          focusColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context))),
                                        ),
                                        controller: _address,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            selectedTime = await showTimePicker(
                                                context: context,
                                                initialTime: selectedTime);
                                            setState(() {});
                                          },
                                          icon: FaIcon(FontAwesomeIcons.clock)),
                                      IconButton(
                                          onPressed: () async {
                                            selectedDate = await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 2));
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.date_range)),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color:
                                                ColorResources.getPrimaryColor(
                                                    context)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shadowColor: MaterialStateProperty
                                                  .all<Color>(
                                                      Colors.transparent),
                                              elevation:
                                                  MaterialStateProperty.all(6),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ))),
                                          onPressed: () async {
                                            log('message');
                                            setState(() {
                                              test_id = widget.testid;
                                              cost = widget.price;
                                            });
                                            await openCheckout1();
                                            // await addTest(
                                            //     context,
                                            //     test_id,
                                            //     selectedDate
                                            //         .toString()
                                            //         .substring(
                                            //             0, 11),
                                            //     selectedTime
                                            //         .format(
                                            //             context),
                                            //     _name.text,
                                            //     _age.text,
                                            //     _address.text);
                                          },
                                          child: Text(
                                            'Proceed for Payment',
                                            style: poppinsSemiBold.copyWith(
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            )))))));
  }
}
