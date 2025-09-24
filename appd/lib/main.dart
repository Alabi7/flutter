import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:appd/configs/supabaseConfig.dart';
import 'package:appd/screens/auth/authScreen.dart';
import 'package:appd/screens/mainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Affiche les erreurs de build dans l’UI (au lieu du gros écran rouge)
  ErrorWidget.builder = (details) => Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(
              'Flutter error:\n${details.exceptionAsString()}\n\n${details.stack}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );

  // Log Flutter errors
  FlutterError.onError = (d) => FlutterError.dumpErrorToConsole(d);

  // Ignore les erreurs réseau transitoires Supabase (DNS / offline)
  PlatformDispatcher.instance.onError = (error, stack) {
    final s = error.toString();
    final transient = s.contains('AuthRetryableFetchException') ||
        (s.contains('SocketException') && s.contains('supabase.co'));
    if (transient) {
      debugPrint('Supabase transient (ignored): $error');
      return true;
    }
    return false; // autres : laisser Flutter logger
  };

  await runZonedGuarded(() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl.trim(),
      anonKey: SupabaseConfig.supabaseAnonKey.trim(),
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
        detectSessionInUri: true,
      ),
    );
    runApp(const MyApp());
  }, (error, stack) {
    final s = error.toString();
    final transient = s.contains('AuthRetryableFetchException') ||
        (s.contains('SocketException') && s.contains('supabase.co'));
    if (transient) {
      debugPrint('Supabase transient (zone, ignored): $error');
      return; // ne remplace pas l’app pour ça
    }

    // ⬇️ Affiche un écran simple avec le message d’erreur
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(
                'Erreur : $error\n\n$stack',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Smart Noter',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _auth = Supabase.instance.client.auth;
  Session? _session;
  StreamSubscription<AuthState>? _sub;
  bool _booting = true;

  @override
  void initState() {
    super.initState();

    _session = _auth.currentSession;

    _sub = _auth.onAuthStateChange.listen((e) {
      if (!mounted) return;
      final newSession = e.session;
      // évite de rebuild sur un simple refresh du même user
      if (newSession?.user.id == _session?.user.id) return;
      setState(() => _session = newSession);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _booting = false);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_booting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _session != null ? const MainScreen() : const AuthScreen();
  }
}
