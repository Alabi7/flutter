import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/notification_service.dart';
import 'services/alarm_service.dart';
import 'providers/alarm_provider.dart';
import 'models/alarm_model.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive pour le stockage local
  await Hive.initFlutter();
  
  // Enregistrer l'adaptateur - sera généré après build_runner
  Hive.registerAdapter(AlarmModelAdapter());
  Hive.registerAdapter(AlarmDismissModeAdapter());
  
  await Hive.openBox<AlarmModel>('alarms');
  
  // Initialiser les services
  await NotificationService.initialize();
  await AlarmService.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
      ],
      child: MaterialApp(
        title: 'Alarmy',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
