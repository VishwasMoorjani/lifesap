import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/blogs/bloshow.dart';

class Blogs extends StatefulWidget {
  // const Blogs({Key key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  // Fetch content from the json file
  Future<List> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await jsonDecode(response);
    return data["BLOGS"] as List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
      future: readJson(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: ((context, index) {
                        final doc = snapshot.data[index];
                        return ListTile(
                          title: Text(doc['Topic']),
                          subtitle: Text(doc['Topic']),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BlogShow(doc['Topic'], doc['Body'])));
                          },
                        );
                      })))
            ],
          );
        } else if (snapshot.hasError) {
          return Text('/');
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }
}
