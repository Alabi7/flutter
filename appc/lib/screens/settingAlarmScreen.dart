import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/alarmSetting/timePickerv1.dart';

class SettingAlarmScreen extends StatefulWidget {
  const SettingAlarmScreen({super.key});

  @override
  State<SettingAlarmScreen> createState() => _SettingAlarmScreenState();
}

class _SettingAlarmScreenState extends State<SettingAlarmScreen> {
  // --- données UI (front only)
  final List<int> hours = List.generate(12, (i) => i + 1); // 1..12
  final List<int> minutes = List.generate(60, (i) => i);   // 0..59
  final List<String> periods = const ['AM', 'PM'];

  int hourIndex = 5;       // => 6 (affiché)
  int minuteIndex = 0;     // => 00
  int periodIndex = 0;     // AM

  final TextEditingController _nameCtrl = TextEditingController();

  // jours sélectionnés (S M T W T F S)
  List<bool> days = List<bool>.filled(7, false);


  // --- state à ajouter dans _SettingAlarmScreenState ---
  bool soundOn = true;
  bool vibrationOn = true;
  bool snoozeOn = true;

  String soundName = 'Kindergarten';
  String vibrationName = 'Basic call';
  String snoozeName = '5 minutes, 3 times';


  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF1F2F4); // gris très clair comme sur le screen
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        elevation: 0,
        // backgroundColor: const Color(0xFF111315), // foncé pour icônes blanches
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Setting Alarm',
          style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ---------- picker "roulettes" ----------
            TimePickerV1(
              hourIndex: hourIndex,
              minuteIndex: minuteIndex,
              periodIndex: periodIndex,
              onHourChanged: (i) => setState(() => hourIndex = i),
              onMinuteChanged: (i) => setState(() => minuteIndex = i),
              onPeriodChanged: (i) => setState(() => periodIndex = i),
            ),


            // ---------- carte blanche arrondie ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ligne date + icône calendrier
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Tomorrow - Tue, Sep 16',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {},
                            icon: const Icon(Icons.check_box_outline_blank, color: Colors.black45, size: 22,),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {},
                            icon: const Icon(Icons.calendar_today_rounded, color: Colors.black45, size: 20),
                          ),
                        ],
                      ),
                    ),

                    // const Divider(height: 1),

                    // rangée S M T W T F S
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (i) {
                          final labels = ['S','M','T','W','T','F','S'];
                          final isSunday = i == 0 || i == 6;
                          final selected = days[i];
                          final ringColor = isSunday ? const Color(0xFFE57373) : Colors.black26;
                          final fill = selected
                              ? (isSunday ? const Color(0xFFE57373) : Colors.black87)
                              : Colors.transparent;
                          final textColor = selected
                              ? Colors.white
                              : (isSunday ? const Color(0xFFE57373) : Colors.black54);
                          return GestureDetector(
                            onTap: () => setState(() => days[i] = !days[i]),
                            child: Container(
                              width: 40, height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: fill,
                                shape: BoxShape.circle,
                                border: Border.all(color: ringColor),
                              ),
                              child: Text(labels[i],
                                  style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                            ),
                          );
                        }),
                      ),
                    ),

                    // const Divider(height: 1),

                    // champ Alarm name (underline)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Alarm name',
                          labelStyle: TextStyle(color: Colors.black45),
                          isDense: true,
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    const Divider(height: 1),
                    

                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ---- Partie gauche : titre + description
                          Expanded(
                            flex: 2,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,  
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Mission', style: TextStyle(fontSize: 16, color: Colors.black87)),
                                SizedBox(height: 4),
                                Text('0/5', style: TextStyle(fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),

                          const SizedBox(width: 5),

                          // ---- Partie droite : conteneur scrollable horizontal
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              // reverse: true, // décommente si tu veux que ça “parte” de la droite
                              child: Row(
                                children: List.generate(5, (i) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: i == 4 ? 0 : 12),
                                    child: _MissionBox(onTap: () {
                                      // TODO: action
                                    }),
                                  );
                                }),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),


                    const Divider(height: 1),

                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0,2))],
                        ),
                        child: Column(
                          children: [
                            _SettingRow(
                              title: 'Alarm sound',
                              subtitle: soundName,
                              value: soundOn,
                              onTap: _pickSound,                 // ouvre un selector (à implémenter)
                              onChanged: (v) => setState(() => soundOn = v),
                            ),
                            const Divider(height: 1),
                            _SettingRow(
                              title: 'Vibration',
                              subtitle: vibrationName,
                              value: vibrationOn,
                              onTap: _pickVibrationPattern,      // ouvre un picker (à implémenter)
                              onChanged: (v) => setState(() => vibrationOn = v),
                            ),
                            const Divider(height: 1),
                            _SettingRow(
                              title: 'Snooze',
                              subtitle: snoozeName,
                              value: snoozeOn,
                              onTap: _pickSnoozeOptions,         // ouvre un bottom sheet (à implémenter)
                              onChanged: (v) => setState(() => snoozeOn = v),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 1),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(
                                'Alarm background',
                                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                              ),
                            ),
                            // const Divider(height: 1),

                            // Aperçu + choix
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // --- aperçu type téléphone ---
                                  Container(
                                    width: 140,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: alarmBackgrounds[selectedBackground],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text("06", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                                        Text("00", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text("Mon, Sep 15", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                        Text("Alarm", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // --- boutons de sélection (petits ronds) ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(alarmBackgrounds.length, (i) {
                                      return GestureDetector(
                                        onTap: () => setState(() => selectedBackground = i),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 6),
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: alarmBackgrounds[i],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            border: Border.all(
                                              color: i == selectedBackground ? Colors.black : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // bouton Save (optionnel pour le front ; garde le look)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA4D5A), // rose/rouge
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }

  // ----- helpers UI -----

}




class _MissionBox extends StatelessWidget {
  final VoidCallback onTap;
  const _MissionBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
        child: const Icon(Icons.add, color: Colors.black45),
      ),
    );
  }
}



class _SettingRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final VoidCallback? onTap;                 // tap sur la ligne
  final ValueChanged<bool>? onChanged;       // switch

  const _SettingRow({
    required this.title,
    this.subtitle,
    required this.value,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600);
    final subStyle   = const TextStyle(fontSize: 13, color: Colors.black54);

    return InkWell(
      onTap: onTap,                          // permet d’ouvrir un picker en touchant la ligne
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // titre + sous-titre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle,),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: subStyle),
                  ],
                ],
              ),
            ),

            // petite barre verticale
            Container(
              width: 1, height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.black12,
            ),

            // switch (interactif sans déclencher le onTap de la ligne)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // bloque la propagation du tap vers InkWell
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF8FA6C8), // bleu gris comme sur le screen
                inactiveTrackColor: const Color(0xFFE0E3E7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _pickSound() {
  // TODO: ouvrir un bottom sheet / page de choix de son
  // setState(() => soundName = 'New sound');
}

void _pickVibrationPattern() {
  // TODO: ouvrir un picker de pattern (Android) ou haptics type (iOS)
  // setState(() => vibrationName = 'Strong buzz');
}

void _pickSnoozeOptions() {
  // TODO: ouvrir un bottom sheet (ex: intervalle 5/10/15 min, répétitions 1..5)
  // setState(() => snoozeName = '10 minutes, 2 times');
}


// liste de backgrounds disponibles (tu peux mettre des assets aussi)
final List<List<Color>> alarmBackgrounds = [
  [const Color(0xFF0D0B52), const Color(0xFFE9C4A5)], // violet -> beige
  [Colors.black, Colors.grey.shade800],                // noir -> gris
  [Colors.blue.shade900, Colors.blue.shade300],        // bleu foncé -> bleu clair
];

int selectedBackground = 0;
