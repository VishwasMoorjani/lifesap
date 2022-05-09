import 'dart:convert';
import 'dart:developer';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/screens/healthcare/all_appoinments.dart';
import 'package:flutter_grocery/view/screens/healthcare/appointment.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';
import 'package:http/http.dart' as http;

class DoctorConsult extends StatefulWidget {
  @override
  State<DoctorConsult> createState() => _DoctorConsultState();
}

class _DoctorConsultState extends State<DoctorConsult> {
  Future<dynamic> getDocs() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/doc/get-all-doc'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      print(response1['doc']);
      return response1;
    } else {
      log('error');
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getCardBgColor(context),
        appBar: CustomAppBar(
          title: "Doctor's Consultation",
          isElevation: true,
          isBackButtonExist: false,
        ),
        body: SafeArea(
          child: Scrollbar(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  child: FutureBuilder(
                      future: getDocs(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data['doc'].length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20.0,
                                                mainAxisSpacing: 20.0),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Appointment(
                                                            snapshot.data['doc']
                                                                [index]['name'],
                                                            snapshot.data['doc']
                                                                    [index][
                                                                'preferred_time'],
                                                            snapshot.data['doc']
                                                                    [index][
                                                                'qualifications'],
                                                            snapshot.data['doc']
                                                                [index]['id'],
                                                          )));
                                            },
                                            child: Stack(children: [
                                              Container(
                                                // padding: EdgeInsets.all(10),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                //width: 150,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/image/doc_default.jpeg"),
                                                      fit: BoxFit.fitWidth),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: ColorResources
                                                        .getPrimaryColor(
                                                            context),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.007,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .getPrimaryColor(
                                                            context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: ColorResources
                                                          .getPrimaryColor(
                                                              context),
                                                    ),
                                                  ),
                                                  // color: ColorResources.getPrimaryColor(context),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.055,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.421,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      snapshot.data['doc']
                                                          [index]['name'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: poppinsRegular
                                                          .copyWith(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          );
                                        })),
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
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    AllAppointments())));
                                      },
                                      child: Text('My Appointments'),
                                    ))
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Scaffold(
                              body: Text(
                                  'Something went wrong, Please try again'),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorResources.getPrimaryColor(context),
                            ),
                          );
                        }
                      }))),
        ));
  }
}
