import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  String? _filePath;
  bool _isRecording = false;
  bool _isPaused = false;
  Duration _recordDuration = Duration.zero;

  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 44100, bitRate: 128000),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _isPaused = false;
        _filePath = path;
        _recordDuration = Duration.zero;
      });

      _startTicker();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isRecording && !_isPaused) {
        setState(() => _recordDuration += const Duration(seconds: 1));
      }
    });
  }

  Future<void> _pauseRecording() async {
    if (_isRecording && !_isPaused) {
      await _recorder.pause();
      setState(() => _isPaused = true);
    }
  }

  Future<void> _resumeRecording() async {
    if (_isRecording && _isPaused) {
      await _recorder.resume();
      setState(() => _isPaused = false);
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      _ticker?.cancel();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        _filePath = path;
      });
    }
  }

  Future<void> _playRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await _player.setFilePath(_filePath!);
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mm = _recordDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = _recordDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('My recording'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.graphic_eq, size: 100),
          const SizedBox(height: 20),
          Text('$mm:$ss', style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.close, size: 38), onPressed: _stopRecording),
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic, size: 62, color: Colors.red),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 38),
                onPressed: _isRecording ? (_isPaused ? _resumeRecording : _pauseRecording) : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _filePath != null ? _playRecording : null, child: const Text('▶️ Écouter')),
        ],
      ),
    );
  }
}
