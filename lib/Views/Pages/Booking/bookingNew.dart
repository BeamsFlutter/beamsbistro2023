

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingV1 extends StatefulWidget {
  const BookingV1({Key? key}) : super(key: key);

  @override
  _BookingV1State createState() => _BookingV1State();
}

class _BookingV1State extends State<BookingV1> {
  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: SfCalendar(
          view: CalendarView.schedule,
          scheduleViewSettings: ScheduleViewSettings(
            appointmentItemHeight: 60,
          ),
        ),
      ),
    );
  }
}
