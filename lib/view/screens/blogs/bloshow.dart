import 'package:flutter/material.dart';
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
          title: widget.topic,
          isBackButtonExist: true,
          isTrailing: true,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image(
                  image: AssetImage("assets/image/sample1.png"),
                  fit: BoxFit.fill,
                ),
              ),
              Text(widget.body),
            ],
          ),
        )),
      ),
    );
  }
}
