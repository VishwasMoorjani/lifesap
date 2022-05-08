import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/color_resources.dart';

class AllAppointments extends StatefulWidget {
  @override
  State<AllAppointments> createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments> {
  // const AllAppointments({ Key? key }) : super(key: key);
  Future<dynamic> getAppointments() async {
    final uid = (await Provider.of<ProfileProvider>(context, listen: false)
            .getUserID(context))
        .toString();
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/get-patient/$uid'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      log(response1['patient']['appointments'].length.toString());
      return response1['patient']['appointments'];
    } else {
      log('error');
      throw Exception('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getCardBgColor(context),
        appBar: CustomAppBar(
          title: "Appointments",
        ),
        body: FutureBuilder(
          future: getAppointments(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.transparent,
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            tileColor: Color(0xFF77B4FF),
                            leading: CircleAvatar(
                                maxRadius: 30,
                                backgroundImage: AssetImage(
                                    "assets/image/doc_default.jpeg")),
                            title: Text(
                              snapshot.data[index]['doc_name'],
                              style: poppinsSemiBold.copyWith(
                                  fontSize: 14, color: Colors.white),
                            ),
                            subtitle: DefaultTextStyle(
                              style: poppinsRegular.copyWith(
                                  color: Colors.white, fontSize: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data[index]['date'] +
                                      " " +
                                      snapshot.data[index]['time']),
                                  InkWell(
                                      onTap: () => launch(
                                          snapshot.data[index]['meet_link']),
                                      child: Text("Join Meeting")),
                                  Text(snapshot.data[index]['information'])
                                ],
                              ),
                            ),
                          )),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Scaffold(
                  body: Text('Something went wrong, Please try again'),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorResources.getPrimaryColor(context),
                ),
              );
            }
          },
        ));
  }
}
