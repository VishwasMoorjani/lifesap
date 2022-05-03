import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';

class BlogShow extends StatefulWidget {
  final topic;
  final body;
  BlogShow(this.topic, this.body);
  @override
  State<BlogShow> createState() => _BlogShowState();
}

class _BlogShowState extends State<BlogShow> {
  // const BlogShow({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Fitness",
          isBackButtonExist: true,
          isTrailing: true,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: widget.topic ==
                          "Need a Get Back in Shape Workout Plan?"
                      ? AssetImage("assets/image/topic1.jpg")
                      : widget.topic ==
                              "Can you take too many supplements? Why you might need to ditch the multivitamin"
                          ? AssetImage("assets/image/topic2.jpg")
                          : AssetImage("assets/image/topic3.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.topic,
                  style: poppinsBold.copyWith(
                      fontSize: 24,
                      color: ColorResources.getPrimaryColor(context)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.body,
                  style: poppinsRegular.copyWith(fontSize: 16),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
