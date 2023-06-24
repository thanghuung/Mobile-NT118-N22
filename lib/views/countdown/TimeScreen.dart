import 'package:app/AppColors.dart';
import 'package:app/views/countdown/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import 'time_basic.dart';
import 'time_frame.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool isDatHen = false;

  final TextEditingController hoursC = TextEditingController(text: "0");
  final TextEditingController minuteC = TextEditingController(text: "0");
  final TextEditingController secondC = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text("Đồng hồ bấm giờ"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 50,
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                    controller: hoursC,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text("Giờ")
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 50,
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                    controller: minuteC,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Phút")
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 50,
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                    controller: secondC,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text("Giây")
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (int.parse(hoursC.text) != 0 ||
                              int.parse(minuteC.text) != 0 ||
                              int.parse(secondC.text) != 0) {
                            setState(() {
                              hours = int.parse(hoursC.text);
                              minutes = int.parse(minuteC.text);
                              seconds = int.parse(secondC.text);
                              isDatHen = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                        child: Text("Đặt hẹn".toUpperCase()),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TimerFrame(
                key: UniqueKey(),
                description: 'Thời gian còn lại',
                timer: TimerBasic(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                  format: CountDownTimerFormat.hoursMinutesSeconds,
                  onEnd: () {
                    if (isDatHen) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Thông báo"),
                                content: Text("Hết giờ"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"))
                                ],
                              ));
                      setState(() {
                        isDatHen = false;
                        hours = 0;
                        minutes = 0;
                        seconds = 0;
                      });
                    } else {}
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
