import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// remplace au besoin par tes couleurs
class SettingAlarmScreen extends StatefulWidget {
  const SettingAlarmScreen({super.key});

  @override
  State<SettingAlarmScreen> createState() => _SettingAlarmScreenState();
}

class _SettingAlarmScreenState extends State<SettingAlarmScreen> {
  // ---- Time pickers (style roulettes)
  final List<int> hours = List.generate(12, (i) => i + 1);      // 1..12
  final List<int> minutes = List.generate(60, (i) => i);        // 0..59
  final List<String> periods = const ['AM', 'PM'];

  int hourIndex = 7;    // 8 by default
  int minuteIndex = 0;  // 00
  int periodIndex = 1;  // PM

  // ---- Options
  bool daily = true;
  final List<bool> days = List.filled(7, true); // S M T W T F S

  double volume = 0.7;
  bool vibrate = true;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Colors.grey.shade800, thickness: 1);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left, 
            color: Colors.white, 
            // size: 20
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Setting Alarm', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto'
          )
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // pour ne pas passer sous le bouton Save
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // -------- Time "wheel" pickers
            _section(
              child: SizedBox(
                height: 210,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _wheel<int>(
                      items: hours,
                      index: hourIndex,
                      itemBuilder: (v) => _wheelText(v.toString()),
                      onSelectedItemChanged: (i) => setState(() => hourIndex = i),
                    ),
                    const _Colon(),
                    _wheel<int>(
                      items: minutes,
                      index: minuteIndex,
                      itemBuilder: (v) => _wheelText(v.toString().padLeft(2, '0')),
                      onSelectedItemChanged: (i) => setState(() => minuteIndex = i),
                    ),
                    _wheel<String>(
                      items: periods,
                      index: periodIndex,
                      width: 80,
                      itemBuilder: (v) => _wheelText(v),
                      onSelectedItemChanged: (i) => setState(() => periodIndex = i),
                    ),
                  ],
                ),
              ),
            ),

            divider,

            // -------- Daily + jours
            _section(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Daily', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Checkbox(
                        value: daily,
                        onChanged: (v) => setState(() => daily = v ?? false),
                        fillColor: WidgetStateProperty.all(Colors.teal),
                        checkColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (int i = 0; i < 7; i++)
                        ChoiceChip(
                          label: Text(['S','M','T','W','T','F','S'][i]),
                          selected: days[i],
                          onSelected: (sel) => setState(() => days[i] = sel),
                          selectedColor: Colors.teal,
                          labelStyle: TextStyle(
                            color: days[i] ? Colors.white : Colors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.teal.withOpacity(0.7)),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),

            divider,

            // -------- Missions
            _section(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mission', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('0/5', style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, mainAxisExtent: 64, crossAxisSpacing: 12,
                    ),
                    itemBuilder: (_, i) => DottedAddBox(onTap: () {}),
                  ),
                ],
              ),
            ),

            divider,

            // -------- Volume + vibration
            _section(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volume_mute, color: Colors.white70),
                      Expanded(
                        child: Slider(
                          value: volume,
                          onChanged: (v) => setState(() => volume = v),
                          min: 0, max: 1,
                          activeColor: Colors.teal,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white70),
                      const SizedBox(width: 16),
                      const Icon(Icons.vibration, color: Colors.white70),
                      Switch(
                        value: vibrate,
                        onChanged: (v) => setState(() => vibrate = v),
                        activeColor: Colors.white,
                        activeTrackColor: Colors.teal,
                        inactiveTrackColor: Colors.white24,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            divider,

            // -------- Sound selector
            _section(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sound', style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Orkney', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white54),
                ],
              ),
            ),
          ],
        ),
      ),

      // bouton Save fixe en bas
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A63), // rose/rouge comme sur le screen
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveAlarm,
              child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }

  void _saveAlarm() {
    final h = hours[hourIndex];
    final m = minutes[minuteIndex].toString().padLeft(2, '0');
    final p = periods[periodIndex];
    // TODO: persister/planifier l’alarme
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm set at $h:$m $p')),
    );
  }

  // ---------- helpers UI ----------

  Widget _section({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF1E1E1E),
      child: child,
    );
  }

  Widget _wheelText(String s) => Text(
        s,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      );

  Widget _wheel<T>({
    required List<T> items,
    required int index,
    required ValueChanged<int> onSelectedItemChanged,
    required Widget Function(T value) itemBuilder,
    double width = 64,
  }) {
    return SizedBox(
      width: width,
      child: CupertinoPicker(
        squeeze: 1.2,
        magnification: 1.08,
        itemExtent: 40,
        scrollController: FixedExtentScrollController(initialItem: index),
        onSelectedItemChanged: onSelectedItemChanged,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(background: Color(0x1122FFFF)),
        children: items.map(itemBuilder).toList(),
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
      child: Text(':', style: TextStyle(color: Colors.white54, fontSize: 28)),
    );
  }
}

/// Petit carré pointillé “+” pour les missions
class DottedAddBox extends StatelessWidget {
  final VoidCallback onTap;
  const DottedAddBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white38,
            style: BorderStyle.solid, // (si tu veux vrai pointillé: utilise a package comme dotted_border)
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white70),
        ),
      ),
    );
  }
}
