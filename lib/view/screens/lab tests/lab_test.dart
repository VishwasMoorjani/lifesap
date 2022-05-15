import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
import 'package:flutter_grocery/view/screens/lab%20tests/all_test.dart';
import 'package:flutter_grocery/view/screens/lab%20tests/test.dart';
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

  var _isLoggedIn;
  //
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
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
                              itemCount: 9,
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
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              Test(
                                                name: snapshot.data[index]
                                                    ['name'],
                                                price: snapshot.data[index]
                                                    ['price'],
                                                precautions: snapshot
                                                    .data[index]['precautions'],
                                                testid: snapshot.data[index]
                                                    ["test_id"],
                                              )),
                                    );
                                  },
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