import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int hour = 5;          // 1..12
  int minute = 0;        // 0..59
  int ampm = 0;          // 0 = AM, 1 = PM
  int ampmIndex = 0; // 0..3 (pair = AM, impair = PM)

  String get timeFormat => ampm == 0 ? "AM" : "PM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Text(
              "Pick Your Time! ${hour.toString()}:${minute.toString().padLeft(2, '0')} $timeFormat",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // HOURS (1..12)
                  NumberPicker(
                    minValue: 1,
                    maxValue: 12,
                    value: hour,
                    zeroPad: false,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (value) => setState(() => hour = value),
                    textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Roboto'),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                  Text(
                    ":",
                    style: TextStyle(
                      fontSize: 40
                    ),
                  ),

                  // MINUTES (0..59)
                  NumberPicker(
                    minValue: 0,
                    maxValue: 59,
                    value: minute,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (value) => setState(() => minute = value),
                    textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 28),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                  // AM/PM SCROLLER (0=AM, 1=PM) avec mapping de texte
                  

                  NumberPicker(
                    minValue: 0,
                    maxValue: 1,                 // 4 items au lieu de 2
                    value: ampm,
                    infiniteLoop: false,
                    itemWidth: 80,
                    itemHeight: 60,
                    onChanged: (v) => setState(() => ampm = v),
                    textMapper: (raw) => (int.parse(raw) % 2 == 0) ? "AM" : "PM",
                    textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                    selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
