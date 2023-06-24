// import 'package:flutter/cupertino.dart';
//
// import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
//
// import 'time_basic.dart';
// import 'time_frame.dart';
//
//
// class CountDownTimer extends StatelessWidget {
//   const CountDownTimer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       debugShowCheckedModeBanner: false,
//       theme: CupertinoThemeData(
//         brightness: Brightness.light,
//       ),
//       home: CupertinoPageScaffold(
//         child: SafeArea(
//           minimum: EdgeInsets.all(20),
//           child: ListView(
//             children: [
//               TimerFrame(
//                 description: 'Customized Timer Countdown',
//                 timer: TimerBasic(
//                   hours: 10,
//                   minutes: 10,
//                   seconds: 20,
//                   format: CountDownTimerFormat.hoursMinutesSeconds,
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }