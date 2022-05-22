import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowHosp extends StatefulWidget {
  // const ShowHosp({ Key? key }) : super(key: key);
  final location;
  ShowHosp({this.location});
  @override
  State<ShowHosp> createState() => _ShowHospState();
}

class _ShowHospState extends State<ShowHosp> {
  Future<dynamic> getHospitals(String location) async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/hospital/search?q=${location}'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      log(response1.toString());
      return response1;
    } else {
      log('error');
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getHospitals(widget.location),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Scaffold(
                body: Text('Something went wrong, Please try again'),
              ),
            );
          } else if (snapshot.hasData) {
            return snapshot.data.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Text(snapshot.data[index]['name'].toString()),
                          Text(snapshot.data[index]['location'].toString()),
                          Text(snapshot.data[index]['rating'].toString()),
                          Text(snapshot.data[index]['discount'].toString()),
                        ],
                      );
                    },
                  )
                : Text('Nothing found in your area.');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
