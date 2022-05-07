import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/profile_provider.dart';

class allTests extends StatefulWidget {
  // const allTests({ Key? key }) : super(key: key);

  @override
  State<allTests> createState() => _allTestsState();
}

class _allTestsState extends State<allTests> {
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
      appBar: AppBar(
        title: Text('Tests'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getTests(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: ListTile(
                        title: Text(snapshot.data[index]['name']),
                        subtitle: Column(
                          children: [
                            Text(snapshot.data[index]['time']),
                            Text(snapshot.data[index]['price']),
                            Text(snapshot.data[index]['precautions']),
                          ],
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
