import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';

class RecordingsListScreen extends StatefulWidget {
  const RecordingsListScreen({super.key});

  @override
  State<RecordingsListScreen> createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  final _player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerSub;

  List<File> _files = [];
  bool _loading = true;

  String? _currentPath;
  PlayerState _playerState = PlayerState(false, ProcessingState.idle);

  @override
  void initState() {
    super.initState();
    _initAudioSession();
    _loadFiles();

    _playerSub = _player.playerStateStream.listen((s) {
      setState(() => _playerState = s);
    });
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    // "speech" est safe; tu peux mettre "music" si c'est uniquement de l'écoute
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> _loadFiles() async {
    setState(() => _loading = true);
    final dir = await getApplicationDocumentsDirectory();
    final all = await dir.list(recursive: false).toList();

    final files = all
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.m4a'))
        .toList();

    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    setState(() {
      _files = files;
      _loading = false;
    });
  }

  bool _isThisPlaying(String path) {
    if (_currentPath != path) return false;
    if (!_playerState.playing) return false;
    final ps = _playerState.processingState;
    return ps != ProcessingState.completed && ps != ProcessingState.idle;
  }

  Future<void> _togglePlay(File file) async {
    try {
      // Si on clique sur l’élément déjà en lecture => pause/reprise
      if (_currentPath == file.path) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      // Nouveau fichier
      _currentPath = file.path;
      await _player.stop(); // stoppe proprement l'ancien
      await _player.setFilePath(file.path); // prépare
      await _player.play();                  // lance

      // Quand la lecture se termine, on rafraîchit l'UI
      _player.processingStateStream.firstWhere((s) => s == ProcessingState.completed).then((_) {
        if (!mounted) return;
        setState(() {}); // force le rebuild d'icône
      });
    } catch (e) {
      // Tips de debug utiles
      final exists = await file.exists();
      debugPrint('PLAY ERROR on ${file.path} exists=$exists : $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lecture: $e')),
        );
      }
    }
  }

  Future<void> _delete(File file) async {
    try {
      if (_currentPath == file.path) {
        await _player.stop();
        _currentPath = null;
      }
      if (await file.exists()) await file.delete();
      _loadFiles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suppression impossible: $e')),
        );
      }
    }
  }

  String _fname(File f) => f.uri.pathSegments.last;
  String _fsize(File f) {
    final kb = f.lengthSync() / 1024.0;
    return '${kb.toStringAsFixed(1)} KB';
  }

  IconData _playIconFor(String path) =>
      _isThisPlaying(path) ? Icons.pause : Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes enregistrements')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(child: Text('Aucun enregistrement'))
              : ListView.separated(
                  itemCount: _files.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final f = _files[i];
                    final modified = f.statSync().modified;
                    return ListTile(
                      title: Text(_fname(f), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${modified.toLocal()} • ${_fsize(f)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(_playIconFor(f.path)),
                            onPressed: () => _togglePlay(f),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _delete(f),
                          ),
                        ],
                      ),
                      onTap: () => _togglePlay(f),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadFiles,
        icon: const Icon(Icons.refresh),
        label: const Text('Rafraîchir'),
      ),
    );
  }
}
