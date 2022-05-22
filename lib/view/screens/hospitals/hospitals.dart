import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/screens/hospitals/showhospitals.dart';
import 'package:http/http.dart' as http;

class SearchHospitals extends StatefulWidget {
  // const SearchHospitals({ Key? key }) : super(key: key);

  @override
  State<SearchHospitals> createState() => _SearchHospitalsState();
}

class _SearchHospitalsState extends State<SearchHospitals> {
  TextEditingController _location = TextEditingController();
  List<dynamic> hospitals = [];
  Future<dynamic> getHospitals(String location) async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/hospital/search?q=${location}'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      // log(response1.length.toString());
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _location,
          ),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => ShowHosp(
                        location: _location.text.trim(),
                      ))));
              hospitals = await getHospitals(_location.text.trim());
              setState(() {});
            },
          ),
          // hospitals.length != 0
          //     ? SingleChildScrollView(
          //         child: Column(
          //           children: [
          //             Expanded(
          //               child: SizedBox(

          //                 child: ListView.builder(
          //                   shrinkWrap: true,
          //                   itemCount: hospitals.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     return ListView(
          //                       children: [
          //                         Text(hospitals[index]['name']),
          //                         Text(hospitals[index]['location']),
          //                         Text(hospitals[index]['rating']),
          //                         Text(hospitals[index]['discount']),
          //                       ],
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     : Text('Nothing Found'),
        ],
      ),
    );
  }
}
