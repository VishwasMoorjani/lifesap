import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/view/screens/blogs/bloshow.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';

import '../../../utill/color_resources.dart';

class Blogs extends StatefulWidget {
  // const Blogs({Key key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  Widget listItem(BuildContext context, int index, doc) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF898A8E)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          leading: CircleAvatar(
              foregroundImage: AssetImage("assets/image/sample.png")),
          title: Text(doc['Topic']),
          subtitle: Text(doc['Topic']),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlogShow(doc['Topic'], doc['Body'])));
          },
        ));
  }

  // Fetch content from the json file
  Future<List> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await jsonDecode(response);
    return data["BLOGS"] as List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Health Tips",
          isElevation: true,
          isBackButtonExist: false,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: readJson(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  /* Image(
                    image: AssetImage(
                      "assets/image/blog_bg.png",
                    ),
                  ),*/

                  // fit: BoxFit.fitWidth,

                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.separated(
                        padding: EdgeInsets.all(15),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshot.data.length,
                        itemBuilder: ((context, index) {
                          final doc = snapshot.data[index];
                          return listItem(context, index, doc);
                        })),
                  ),
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
