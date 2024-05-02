import 'package:flutter/material.dart';

extension MyDateTime on DateTime {
  /// returns Datetime to String without time.
  String get format => _toString(this);

  String _toString(DateTime date) {
    String day = date.day > 10 ? '0${date.day}' : date.day.toString();
    String month = date.month > 10 ? '0${date.month}' : date.month.toString();
    int year = date.year;
    return '$day$month$year';
  }
}

extension MyTimeOfDay on TimeOfDay {
  /// returns TimeOfDay to String in 24hr format.
  String get formatTime24H => _formatTime24H(this);

  String _formatTime24H(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

extension MyString on String {
  /// converts TimeOfDay string to DateTime object
  TimeOfDay get toTimeOfDay => _timeofDayFromString(this);

  TimeOfDay _timeofDayFromString(String timeString) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);

    return timeOfDay;
  }
}
