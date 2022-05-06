import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../provider/profile_provider.dart';

class Appointment extends StatefulWidget {
  final docname;
  final preftime;
  final expertise;
  final id;
  Appointment(this.docname, this.preftime, this.expertise, this.id);
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  Future postAppointment() async {
    final uid = (await Provider.of<ProfileProvider>(context, listen: false)
            .getUserID(context))
        .toString();
    final url = Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/appointment/$uid/${widget.id.toString()}');
    var response = await http.put(url,
        body: jsonEncode(
            {'date': 'doodle', 'time': 'blue', 'information': 'info1'}));
    log(response.body);
  }

  DateTime _datetime;
  TimeOfDay _time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.docname),
      body: Center(
        child: Column(
          children: [
            Text('Preferred time: ${widget.preftime} '),
            Text('Expertise: ${widget.expertise}'),
            Text(_datetime == null
                ? "Pick A Date"
                : _datetime.toString().substring(0, 10)),
            Text(_time == null ? 'Pick time' : _time.format(context)),
            ElevatedButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate:
                              _datetime == null ? DateTime.now() : _datetime,
                          firstDate: DateTime(_datetime.year),
                          lastDate: DateTime(_datetime.year + 2))
                      .then((value) {
                    setState(() {
                      _datetime = value;
                    });
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(
                      width: 3,
                    ),
                    Text('Select Date')
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  showTimePicker(
                          context: context,
                          initialTime: _time == null ? TimeOfDay.now() : _time)
                      .then((value) {
                    setState(() {
                      _time = value;
                    });
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timelapse),
                    SizedBox(
                      width: 3,
                    ),
                    Text('Select Time')
                  ],
                )),
            ElevatedButton(
                onPressed: () async {
                  await postAppointment();
                },
                child: Text('post')),
          ],
        ),
      ),
    );
  }
}
