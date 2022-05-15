import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
import 'package:flutter_grocery/view/screens/lab%20tests/all_test.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../base/custom_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LabTest extends StatefulWidget {
  @override
  State<LabTest> createState() => _LabTestState();
}

class _LabTestState extends State<LabTest> {
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

  Future<dynamic> getTest() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/lab/get-test'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      log(response1["test"].toString());
      return response1["test"];
    } else {
      log('error');
      throw Exception('error');
    }
  }

  //
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return _isLoggedIn
        ? Scaffold(
            appBar: CustomAppBar(
              title: "Lab Tests",
              isElevation: true,
              isBackButtonExist: false,
            ),
            backgroundColor: ColorResources.getCardBgColor(context),
            body: SafeArea(
                child: Scrollbar(
                    child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: FutureBuilder(
                future: getTest(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: size.height,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 15.0,
                                      mainAxisSpacing: 15.0),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Image(
                                      image: AssetImage(
                                          "assets/image/${index + 1}.png")),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    return showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]
                                                        ['name'],
                                                    style: poppinsSemiBold
                                                        .copyWith(
                                                            fontSize: 22,
                                                            color: ColorResources
                                                                .getPrimaryColor(
                                                                    context)),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(Icons.close)),
                                                ],
                                              ),
                                              content: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Price: Rs. " +
                                                              snapshot.data[
                                                                      index]
                                                                  ['price'],
                                                          style: poppinsSemiBold
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xFF8EBCF7),
                                                                  fontSize: 16),
                                                        ),
                                                        Text(
                                                          "Precautions: ",
                                                          style: poppinsSemiBold
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xFF8EBCF7),
                                                                  fontSize: 16),
                                                        ),
                                                        Text(
                                                          snapshot.data[index]
                                                              ['precautions'],
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Center(
                                                    child:
                                                        SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        controller: _name,
                                                      ),
                                                      TextFormField(
                                                        controller: _age,
                                                      ),
                                                      TextFormField(
                                                        controller: _address,
                                                      ),
                                                      IconButton(
                                                          onPressed: () async {
                                                            selectedTime =
                                                                await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        selectedTime);
                                                            setState(() {});
                                                          },
                                                          icon: Icon(Icons
                                                              .punch_clock_outlined)),
                                                      IconButton(
                                                          onPressed: () async {
                                                            selectedDate = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    selectedDate,
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate: DateTime(
                                                                    DateTime.now()
                                                                            .year +
                                                                        2));
                                                            setState(() {});
                                                          },
                                                          icon: Icon(Icons
                                                              .date_range)),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize:
                                                              Size(150, 30),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: ColorResources
                                                              .getPrimaryColor(
                                                                  context), // Background color
                                                        ),
                                                        onPressed: () async {
                                                          log('message');
                                                          setState(() {
                                                            test_id = snapshot
                                                                    .data[index]
                                                                ['test_id'];
                                                            cost = snapshot
                                                                    .data[index]
                                                                ['price'];
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
                                                        child:
                                                            Text('Take Test'),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ));
                                  },
                                  child: Image(
                                      image: AssetImage(
                                          "assets/image/labtest${index + 1}.png")),
                                );
                              },
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  primary: ColorResources.getPrimaryColor(
                                      context), // Background color
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => AllTests())));
                                },
                                child: Text('My Tests'),
                              ))
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Scaffold(
                        body: Text('Something went wrong, Please try again'),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          color: ColorResources.getPrimaryColor(context)),
                    );
                  }
                },
              ),
            ))))
        : NotLoggedInScreen();
  }
}
/*  Column(
                            children: [
                              Text(snapshot.data[index]['name']),
                              Text(snapshot.data[index]['test_id']),
                              Text(snapshot.data[index]['price']),
                              Text(snapshot.data[index]['precautions']),
                            ],
                          );*/