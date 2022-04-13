import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';

class Appointment extends StatefulWidget {
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Dr. Sky"),
      body: Container(),
    );
  }
}
