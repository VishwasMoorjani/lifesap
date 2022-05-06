import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
        appBar: AppBar(
          title: Text('Appointments'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getAppointments(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(snapshot.data[index]['doc_name']),
                        subtitle: Column(
                          children: [
                            Text(snapshot.data[index]['date'] +
                                snapshot.data[index]['time']),
                            Text(snapshot.data[index]['meet_link']),
                            Text(snapshot.data[index]['information'])
                          ],
                        ));
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
