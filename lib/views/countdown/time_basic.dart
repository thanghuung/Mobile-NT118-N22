import 'dart:ui';

import 'package:app/views/countdown/time_frame.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class TimerBasic extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;
  final CountDownTimerFormat format;
  final bool inverted;
  final Function onEnd;

  TimerBasic({
    required this.format,
    this.inverted = false,
    Key? key, required this.hours, required this.minutes, required this.seconds, required this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      format: format,
      endTime: DateTime.now().add(
        Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        ),
      ),
      onEnd: () {
        onEnd();
      },

      timeTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      colonsTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      descriptionTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontSize: 10,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      spacerWidth: 0,
      daysDescription: "days",
      hoursDescription: "hours",
      minutesDescription: "minutes",
      secondsDescription: "seconds",
    );
  }
}