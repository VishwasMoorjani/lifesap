import 'dart:convert';
import 'dart:developer';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/profile_provider.dart';
import '../../../utill/styles.dart';

class AllTests extends StatefulWidget {
  // const allTests({ Key? key }) : super(key: key);

  @override
  State<AllTests> createState() => _AllTestsState();
}

class _AllTestsState extends State<AllTests> {
  Future<dynamic> getTests() async {
    final uid = (await Provider.of<ProfileProvider>(context, listen: false)
            .getUserID(context))
        .toString();
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/get-patient/$uid'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      log(response1['patient']['tests'].toString());
      return response1['patient']['tests'];
    } else {
      log('error');
      throw Exception('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Tests", isElevation: true),

      body: FutureBuilder(
        future: getTests(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            color: Colors.transparent,
                            elevation: 5,
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 10, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              tileColor: Color(0xFF77B4FF),
                              title: Text(
                                snapshot.data[index]['name'],
                                style: poppinsSemiBold.copyWith(
                                    fontSize: 14, color: Colors.white),
                              ),
                              subtitle: DefaultTextStyle(
                                style: poppinsRegular.copyWith(
                                    color: Colors.white, fontSize: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data[index]['time']),
                                    Text(
                                        "Rs. " + snapshot.data[index]['price']),
                                    Text(snapshot.data[index]['precautions'])
                                  ],
                                ),
                              ),
                            ))),
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
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      //  ElevatedButton(
      //   onPressed: () async {
      //     await getTests();
      //   },
      //   child: Text('fetch'),
      // ),
    );
  }
}
