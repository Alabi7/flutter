import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

enum RecordingState {
  idle,        // État 1 : Avant enregistrement
  recording,   // État 2 : En cours d'enregistrement
  paused       // État 3 : En pause avec options
}

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with TickerProviderStateMixin {
  RecordingState _currentState = RecordingState.idle;
  
  // Timer et durée
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  
  // Animation pour la forme d'onde
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  
  // Données de la forme d'onde (simulées)
  List<double> _waveformData = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_waveController);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  // Démarrer l'enregistrement
  void _startRecording() {
    setState(() {
      _currentState = RecordingState.recording;
      _recordingDuration = Duration.zero;
      _waveformData = [];
    });

    // Démarrer le timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration = Duration(seconds: timer.tick);
      });
      
      // Ajouter des données aléatoires à la forme d'onde
      _generateWaveformData();
    });

    // Démarrer l'animation de la forme d'onde
    _waveController.repeat();
  }

  // Mettre en pause
  void _pauseRecording() {
    setState(() {
      _currentState = RecordingState.paused;
    });
    
    _timer?.cancel();
    _waveController.stop();
  }

  // Continuer l'enregistrement
  void _continueRecording() {
    setState(() {
      _currentState = RecordingState.recording;
    });
    
    // Reprendre le timer à partir de la durée actuelle
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
      _generateWaveformData();
    });
    
    _waveController.repeat();
  }

  // Terminer l'enregistrement
  void _finishRecording() {
    _timer?.cancel();
    _waveController.stop();
    
    // Ici tu peux sauvegarder l'audio
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enregistrement terminé: ${_formatDuration(_recordingDuration)}'),
      ),
    );
    
    _resetRecording();
  }

  // Annuler l'enregistrement
  void _cancelRecording() {
    _timer?.cancel();
    _waveController.stop();
    _resetRecording();
  }

  // Reset à l'état initial
  void _resetRecording() {
    setState(() {
      _currentState = RecordingState.idle;
      _recordingDuration = Duration.zero;
      _waveformData = [];
    });
  }

  // Générer des données aléatoires pour la forme d'onde
  void _generateWaveformData() {
    if (_waveformData.length > 100) {
      _waveformData.removeAt(0);
    }
    _waveformData.add(_random.nextDouble());
  }

  // Formater la durée
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         // En-tête avec petite barre
    //         Padding(
    //           padding: const EdgeInsets.only(top: 16),
    //           child: Container(
    //             width: 60,
    //             height: 4,
    //             decoration: BoxDecoration(
    //               color: Colors.grey[400],
    //               borderRadius: BorderRadius.circular(2),
    //             ),
    //           ),
    //         ),
            
    //         const SizedBox(height: 32),
            
    //         // Titre
    //         const Text(
    //           'My Recording',
    //           style: TextStyle(
    //             fontSize: 28,
    //             fontWeight: FontWeight.w600,
    //             color: Colors.black,
    //           ),
    //         ),
            
    //         const SizedBox(height: 40),
            
    //         // Timer
    //         _buildTimer(),
            
    //         const SizedBox(height: 60),
            
    //         // Zone de la forme d'onde
    //         Expanded(child: _buildWaveformSection()),
            
    //         // Boutons en bas
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 40),
    //           child: _buildActionButtons(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 44, height: 5,
              decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
           
            const SizedBox(height: 32),
            
            // Titre
            const Text(
              'My Recording',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Timer
            _buildTimer(),
            
            const SizedBox(height: 60),
            
            // Zone de la forme d'onde
            Expanded(child: _buildWaveformSection()),
            
            // Boutons en bas
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _buildActionButtons(),
            ),

          ],
        ),
      ),
    );








  }

  Widget _buildTimer() {
    Color timerColor;
    switch (_currentState) {
      case RecordingState.idle:
        timerColor = Colors.grey[600]!;
        break;
      case RecordingState.recording:
        timerColor = Colors.red;
        break;
      case RecordingState.paused:
        timerColor = Colors.grey[600]!;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentState == RecordingState.recording) 
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        Text(
          _formatDuration(_recordingDuration),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: timerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveformSection() {
    if (_currentState == RecordingState.idle) {
      return Center(
        child: Text(
          'Tap to start recording',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: CustomPaint(
            painter: WaveformPainter(
              waveformData: _waveformData,
              isAnimating: _currentState == RecordingState.recording,
              animationValue: _waveAnimation.value,
            ),
            size: Size.infinite,
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    switch (_currentState) {
      case RecordingState.idle:
        return _buildRecordButton();
      case RecordingState.recording:
        return _buildPauseButton();
      case RecordingState.paused:
        return _buildPausedButtons();
    }
  }

  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: _startRecording,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseButton() {
    return GestureDetector(
      onTap: _pauseRecording,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.pause,
          size: 36,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildPausedButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Cancel
        _buildActionButton(
          icon: Icons.close,
          label: 'Cancel',
          onTap: _cancelRecording,
          backgroundColor: Colors.grey[200]!,
          iconColor: Colors.grey[600]!,
        ),
        
        // Done
        _buildActionButton(
          icon: Icons.check,
          label: 'Done',
          onTap: _finishRecording,
          backgroundColor: Colors.indigo,
          iconColor: Colors.white,
          isMain: true,
        ),
        
        // Continue
        _buildActionButton(
          icon: Icons.play_arrow,
          label: 'Continue',
          onTap: _continueRecording,
          backgroundColor: Colors.grey[200]!,
          iconColor: Colors.grey[600]!,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
    bool isMain = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: isMain ? 80 : 60,
            height: isMain ? 80 : 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: isMain ? [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              size: isMain ? 36 : 28,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Painter personnalisé pour la forme d'onde
class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final bool isAnimating;
  final double animationValue;

  WaveformPainter({
    required this.waveformData,
    required this.isAnimating,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final barWidth = 4.0;
    final spacing = 2.0;
    final totalBarWidth = barWidth + spacing;
    final maxBars = (width / totalBarWidth).floor();

    for (int i = 0; i < waveformData.length && i < maxBars; i++) {
      final x = i * totalBarWidth;
      final normalizedHeight = waveformData[i] * height * 0.8;
      final barHeight = math.max(4, normalizedHeight);
      
      final startY = (height - barHeight) / 2;
      final endY = startY + barHeight;

      // Animation pour les barres actives
      if (isAnimating && i >= waveformData.length - 10) {
        paint.color = Colors.indigo.withOpacity(0.5 + 0.5 * animationValue);
      } else {
        paint.color = Colors.indigo;
      }

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}