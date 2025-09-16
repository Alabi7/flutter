import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSStyleTimePicker extends StatefulWidget {
  const IOSStyleTimePicker({super.key});

  @override
  State<IOSStyleTimePicker> createState() => _IOSStyleTimePickerState();
}

class _IOSStyleTimePickerState extends State<IOSStyleTimePicker> {
  int hour = 7;     // 1..12
  int minute = 30;  // 0..59
  int ampm = 0;     // 0 = AM, 1 = PM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // HOURS
              SizedBox(
                width: 80,
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: hour - 1),
                  itemExtent: 40,
                  looping: true,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      hour = index + 1;
                    });
                  },
                  children: List.generate(12, (i) {
                    return Center(
                      child: Text(
                        "${i + 1}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const Text(":", style: TextStyle(fontSize: 40, color: Colors.white)),

              // MINUTES
              SizedBox(
                width: 80,
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: minute),
                  itemExtent: 40,
                  looping: true,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      minute = index;
                    });
                  },
                  children: List.generate(60, (i) {
                    return Center(
                      child: Text(
                        i.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // AM/PM
              SizedBox(
                width: 80,
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: ampm),
                  itemExtent: 40,
                  looping: false,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      ampm = index;
                    });
                  },
                  children: const [
                    Center(
                      child: Text("AM",
                          style: TextStyle(fontSize: 26, color: Colors.white)),
                    ),
                    Center(
                      child: Text("PM",
                          style: TextStyle(fontSize: 26, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
