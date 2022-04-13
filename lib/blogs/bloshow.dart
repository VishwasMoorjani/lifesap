import 'package:flutter/material.dart';

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
