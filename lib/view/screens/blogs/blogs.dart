import 'dart:convert';
import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/view/screens/blogs/bloshow.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import '../../../utill/color_resources.dart';

class Blogs extends StatefulWidget {
  // const Blogs({Key key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  Widget listItem(BuildContext context, int index, doc) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF898A8E)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Align(
          alignment: Alignment.center,
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              foregroundImage: AssetImage("assets/image/topic3.jpg"),
            ),
            title: Text(doc['title']),
            // subtitle: Text(doc['Topic']),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      BlogShow(doc['title'], doc['content'])));
            },
          ),
        ));
  }

  // Fetch content from the json file
  Future readJson() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/blog/get-all-blogs'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      print(response1['blogs']);
      return response1['blogs'];
    } else {
      log('error');
      throw ('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Health Tips",
          isElevation: true,
          isBackButtonExist: false,
        ),
        body: FutureBuilder<dynamic>(
          future: readJson(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
              return Center(
                child: Scaffold(
                  body: Text('Something went wrong, Please try again'),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
