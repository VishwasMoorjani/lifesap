import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../provider/profile_provider.dart';
import 'package:table_calendar/table_calendar.dart';

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

  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

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
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(title: widget.docname),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          maxRadius: 60,
                          backgroundColor: Colors.transparent,
                          child:
                              Image(image: AssetImage("assets/image/doc.png")),
                        ),
                        DefaultTextStyle(
                          style: poppinsLight.copyWith(
                              color: ColorResources.getPrimaryColor(context)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Preferred time: ${widget.preftime} '),
                                Text('Expertise: ${widget.expertise}'),
                                Text(_datetime == null
                                    ? "Pick A Date"
                                    : _datetime.toString().substring(0, 10)),
                                Text(_time == null
                                    ? 'Pick time'
                                    : _time.format(context)),
                              ]),
                        ),
                      ]),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Schedule",
                      textAlign: TextAlign.left,
                      style: poppinsSemiBold.copyWith(fontSize: 16),
                    ),
                  ),
                  TableCalendar(
                    availableCalendarFormats: {CalendarFormat.week: 'Week'},
                    initialCalendarFormat: CalendarFormat.week,
                    calendarStyle: CalendarStyle(
                        todayColor: Colors.blue,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events, e) {
                      print(date.toUtc());
                      setState(() {
                        _datetime = date.toUtc();
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              border: Border.all(color: Colors.black)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Time",
                      textAlign: TextAlign.left,
                      style: poppinsSemiBold.copyWith(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: FaIcon(FontAwesomeIcons.clock),
                    onPressed: () {
                      showTimePicker(
                              context: context,
                              initialTime:
                                  _time == null ? TimeOfDay.now() : _time)
                          .then((value) {
                        setState(() {
                          _time = value;
                        });
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextFormField(
                    cursorColor: ColorResources.getPrimaryColor(context),
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: poppinsMedium.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      focusColor: ColorResources.getPrimaryColor(context),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorResources.getPrimaryColor(context))),
                    ),
                    controller: _name,
                  ),
                  TextFormField(
                    cursorColor: ColorResources.getPrimaryColor(context),
                    decoration: InputDecoration(
                      hintText: "Age",
                      hintStyle: poppinsMedium.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      focusColor: ColorResources.getPrimaryColor(context),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorResources.getPrimaryColor(context))),
                    ),
                    controller: _age,
                  ),
                  TextFormField(
                    cursorColor: ColorResources.getPrimaryColor(context),
                    decoration: InputDecoration(
                      hintText: "Problem",
                      hintStyle: poppinsMedium.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      focusColor: ColorResources.getPrimaryColor(context),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorResources.getPrimaryColor(context))),
                    ),
                    controller: _problem,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorResources.getPrimaryColor(context)),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            elevation: MaterialStateProperty.all(6),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ))),
                        onPressed: () async {
                          LoadingIndicatorDialog().show(context, 'Please wait');
                          await postAppointment(context, _name.text, _age.text,
                              _problem.text, _datetime, _time.format(context));
                          LoadingIndicatorDialog().dismiss();
                        },
                        child: Text(
                          'Book Appointment',
                          style: poppinsSemiBold.copyWith(fontSize: 16),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
