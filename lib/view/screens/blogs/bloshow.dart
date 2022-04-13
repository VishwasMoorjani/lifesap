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
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Center(child: Text(widget.topic)),
            Text(widget.body),
          ],
        )),
      ),
    );
  }
}
