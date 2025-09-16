import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerV1 extends StatelessWidget {
  final int hourIndex;
  final int minuteIndex;
  final int periodIndex;

  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<int> onPeriodChanged;

  const TimePickerV1({
    super.key,
    required this.hourIndex,
    required this.minuteIndex,
    required this.periodIndex,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onPeriodChanged,
  });

  // --- Helper text style
  Widget _pickerText(String s) => Text(
        s,
        style: const TextStyle(
          fontSize: 34,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      );

  // --- Wheel générique
  Widget _wheel<T>({
    required List<T> items,
    required int index,
    required ValueChanged<int> onSelectedItemChanged,
    required Widget Function(T value) itemBuilder,
    double width = 90,
  }) {
    return SizedBox(
      width: width,
      child: CupertinoPicker(
        backgroundColor: Colors.transparent,
        itemExtent: 44,
        magnification: 1.1,
        squeeze: 1.2,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Color(0x11AAAAAA),
        ),
        scrollController: FixedExtentScrollController(initialItem: index),
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map(itemBuilder).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> hours = List.generate(12, (i) => i + 1);
    final List<int> minutes = List.generate(60, (i) => i);
    final List<String> periods = const ['AM', 'PM'];

    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wheel<int>(
            width: 90,
            items: hours,
            index: hourIndex,
            onSelectedItemChanged: onHourChanged,
            itemBuilder: (v) => _pickerText(v.toString()),
          ),
          const _Colon(),
          _wheel<int>(
            width: 90,
            items: minutes,
            index: minuteIndex,
            onSelectedItemChanged: onMinuteChanged,
            itemBuilder: (v) => _pickerText(v.toString().padLeft(2, '0')),
          ),
          const SizedBox(width: 8),
          _wheel<String>(
            width: 80,
            items: periods,
            index: periodIndex,
            onSelectedItemChanged: onPeriodChanged,
            itemBuilder: (v) => _pickerText(v),
          ),
        ],
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(':', style: TextStyle(fontSize: 34, color: Colors.black54)),
    );
  }
}
