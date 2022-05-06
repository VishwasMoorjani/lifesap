import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/screens/healthcare/appointment.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';
import 'package:http/http.dart' as http;

class DoctorConsult extends StatefulWidget {
  @override
  State<DoctorConsult> createState() => _DoctorConsultState();
}

class _DoctorConsultState extends State<DoctorConsult> {
  getDocs() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/doc/get-all-doc'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      print(response1);
    } else {
      log('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Doctor's Consultation",
        isElevation: true,
        isBackButtonExist: false,
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(8, 25, 8, 0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await getDocs();
                  },
                  child: Text('doc')),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),

              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.all(15),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //        Appointment(
                            //         snapshot.data['doc'][index]['name'],
                            //         snapshot.data['doc'][index]
                            //             ['preferred_time'],
                            //         snapshot.data['doc'][index]
                            //             ['qualifications'])));
                          },
                          child: Stack(children: [
                            Container(
                              // padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * 0.2,
                              //width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(Images.doc),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.005,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorResources.getPrimaryColor(
                                          context),
                                    ),
                                  ),
                                  // color: ColorResources.getPrimaryColor(context),
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.415,
                                )),
                            Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.02,
                              // left: 8,
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.415,
                                child: Text(
                                  "Dr. Sky$index",
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            )
                          ]),
                        );
                      })),
            ],
          )),
    );
  }
}