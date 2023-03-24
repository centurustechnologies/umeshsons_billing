import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umeshsons_billing/helper/app_constant.dart';

class TimeDifferenceWidget extends StatefulWidget {
  final String orderPlacedTime;
  final String dateFormat;

  const TimeDifferenceWidget({
    Key? key,
    required this.orderPlacedTime,
    this.dateFormat = 'MMM d, y hh:mm a',
  }) : super(key: key);

  @override
  _TimeDifferenceWidgetState createState() => _TimeDifferenceWidgetState();
}

class _TimeDifferenceWidgetState extends State<TimeDifferenceWidget> {
  int _timeDifference = 00;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Set the initial time difference
    _updateTimeDifference();

    // Update the time difference every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeDifference();
    });
  }

  void _updateTimeDifference() {
    final orderDateTime =
        DateFormat('MMM d, y hh:mm a').parse(widget.orderPlacedTime);
    final currentDateTime = DateTime.now();
    _timeDifference = currentDateTime.difference(orderDateTime).inMinutes;
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$_timeDifference",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: whiteColor,
        fontSize: 13,
      ),
    );
  }
}
