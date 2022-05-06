import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
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
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _problem = TextEditingController();
  Future postAppointment(context, name, age, problem, date, time) async {
    final uid = (await Provider.of<ProfileProvider>(context, listen: false)
            .getUserID(context))
        .toString();
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/add-patient'));
    request.bodyFields = {
      'name': name.toString(),
      'age': age.toString(),
      'id': uid
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
    } else {
      log(response.reasonPhrase);
    }

    var headers1 = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request1 = http.Request(
        'PUT',
        Uri.parse(
            'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/patient/appointment/$uid/${widget.id.toString()}'));
    request1.bodyFields = {
      'date': date.toString().substring(0, 10),
      'time': time.toString(),
      'information': problem.toString(),
    };
    request1.headers.addAll(headers1);

    http.StreamedResponse response1 = await request1.send();
    if (response1.statusCode == 200) {
      log(await response1.stream.bytesToString());
    } else {
      log(response1.reasonPhrase);
    }
    return null;
  }

  DateTime _datetime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2))
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
            TextFormField(
              controller: _name,
            ),
            TextFormField(
              controller: _age,
            ),
            TextFormField(
              controller: _problem,
            ),
            ElevatedButton(
                onPressed: () async {
                  LoadingIndicatorDialog().show(context, 'Please wait');
                  await postAppointment(context, _name.text, _age.text,
                      _problem.text, _datetime, _time.format(context));
                  LoadingIndicatorDialog().dismiss();
                },
                child: Text('post')),
          ],
        ),
      ),
    );
  }
}
