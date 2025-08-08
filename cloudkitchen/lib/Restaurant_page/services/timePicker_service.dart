import 'package:flutter/material.dart';

class TimePickerService {
  static Future<TimeOfDay?> selectTime({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF45C3FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dialHandColor: Color(0xFF45C3FF),
              dialBackgroundColor: Colors.deepPurple.shade50,
              entryModeIconColor: Color(0xFF45C3FF),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}