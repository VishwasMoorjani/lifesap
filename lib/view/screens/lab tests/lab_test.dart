import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:http/http.dart' as http;
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../base/custom_app_bar.dart';

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
      throw ('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Lab Tests",
        isElevation: true,
        isBackButtonExist: false,
      ),
      backgroundColor: ColorResources.getCardBgColor(context),
      body: FutureBuilder(
        future: getTest(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Text(snapshot.data[index]['name']),
                    Text(snapshot.data[index]['test_id']),
                    Text(snapshot.data[index]['price']),
                    Text(snapshot.data[index]['precautions']),
                  ],
                );
              },
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Scaffold(
                body: Text('Something went wrong, Please try again'),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      //  Center(
      //     child: Column(
      //   children: [
      //     ElevatedButton(
      //         onPressed: () async {
      //           final v = await getTest();
      //         },
      //         child: Text('okay')),
      //     Image(
      //       image: AssetImage("assets/image/lab1.png"),
      //     ),
      //     SizedBox(
      //       height: MediaQuery.of(context).size.height * 0.06,
      //     ),
      //     Image(image: AssetImage(Images.lab_2)),
      //   ],
      // )),
    );
    /*Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 20.0),
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 150,
                        width: 70,
                        child: Image(
                            image: AssetImage(
                              Images.vitd,
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  /*  Positioned(
                                    top: 65,
                                    left: 8,
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        text[index],
                                        textAlign: TextAlign.center,
                                        style: poppinsSemiBold.copyWith(
                                            fontSize: 10),
                                      ),
                                    ),
                                  ),*/
                ]);*
              })),
    );*/
  }
}
