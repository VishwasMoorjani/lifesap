import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
//import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointment extends StatefulWidget {
  final doc_name;
  Appointment(this.doc_name);
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  DateTime _datetime;
  String _time;
  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.doc_name),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(Images.doc),
                radius: 75,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Schedule",
                  textAlign: TextAlign.left,
                  style: poppinsSemiBold.copyWith(fontSize: 16),
                ),
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
            Text(
              _datetime == null
                  ? "nothing yet"
                  : _datetime.toString().substring(0, 10),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Time",
                  textAlign: TextAlign.left,
                  style: poppinsSemiBold.copyWith(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "10:00 am";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Text('10:00 am',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "12:00 pm";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Text('12:00 pm',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "2:00 pm";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Text('2:00 pm',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "4:00 pm";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 3),
                      child: Text('4:00 pm',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "6:00 pm";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 21, vertical: 3),
                      child: Text('6:00 pm',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _time = "8:00 pm";
                    });
                  },
                  child: Card(
                    color: Color(0xFFCDDEFF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Text('8:00 pm',
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ),
              ]),
            ),
            Text(_time == null ? 'no time picked' : _time),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ColorResources.getPrimaryColor(context)),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Text(
                    "Book Appointment",
                    style: poppinsSemiBold.copyWith(fontSize: 18),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
