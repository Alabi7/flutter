import 'dart:async';
import 'dart:io';
import 'package:appd/common/gappedCircleButton.dart';
import 'package:appd/common/recordLottie.dart';
import 'package:appd/widgets/pop-up/uploadingFiles.dart';
// import 'package:appd/common/waveRecord.dart';
// import 'package:appd/common/waveRecord3.dart';
import 'package:flutter/material.dart';
import 'package:appd/common/circleButton.dart';
// import 'package:appd/common/gappedCircleButton.dart'
import 'package:appd/controllers/audio/recording_session.dart';
import 'package:appd/controllers/audio/audio_capture_controller.dart'; // RecordingPhase
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> showAudioRecord(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AudioRecord(),
  );
}

class AudioRecord extends StatefulWidget {
  const AudioRecord({super.key});
  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord>
  with TickerProviderStateMixin {
    
    bool _closing = false; // ← gèle l’UI pendant la fermeture
    bool _uploading = false; // Nouvel état pour l'upload
    late final RecordingSession _session;
    late final AnimationController _blink; // pour le point rouge clignotant

  @override
  void initState() {
    super.initState();
    // null => chronomètre ; mets une Duration pour un compte à rebours
    _session = RecordingSession(countdownFrom: null);

    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // anime/stoppe le clignotement selon la phase
    _session.phase.addListener(() {
      final p = _session.phase.value;
      if (p == RecordingPhase.recording) {
        _blink.repeat(reverse: true);
      } else {
        _blink.stop();
        _blink.value = 1.0;
      }
      setState(() {}); // pour rafraîchir l'UI au changement de phase
    });
  }

  @override
  void dispose() {
    _blink.dispose();
    _session.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // Fonction pour uploader le fichier sur Supabase
  Future<String?> _uploadToSupabase(String localFilePath) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Générer un ID unique pour la note
      const uuid = Uuid();
      final noteId = uuid.v4();

      // Construire le chemin de destination
      final fileName = '$noteId.m4a';
      final storagePath = 'Ingest/audio/${user.id}/$fileName';

      // Lire le fichier local
      final file = File(localFilePath);
      final fileBytes = await file.readAsBytes();

      // Upload vers Supabase Storage
      await Supabase.instance.client.storage
          .from('Ingest') // nom de ton bucket (remplace si différent)
          .uploadBinary(storagePath, fileBytes);

      return storagePath; // Retourner le chemin pour référence
    } catch (e) {
      debugPrint('Erreur upload Supabase: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final phase =
        _closing
            ? RecordingPhase
                .paused // ← on reste visuellement sur bouton bleu
            : _session.phase.value;

    // final phase = _session.phase.value;
    final showSides = phase == RecordingPhase.paused; // review
    final showHint = phase == RecordingPhase.idle;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Header =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x11000000), width: 1),
                ),
              ),
              height: 62,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'My Recording',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Contenu =====
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timer + indicateur
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(phase),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<Duration>(
                        valueListenable: _session.time,
                        builder:
                            (_, d, __) => Text(
                              _fmt(d),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 115,
                    width: double.infinity,
                    child: RecordLottie(
                      isRecording:
                          _session.phase.value == RecordingPhase.recording,
                      isPaused: _session.phase.value == RecordingPhase.paused,
                      // asset: 'assets/animations/sphereAnimation1.json', // par défaut
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Hint en idle uniquement
                  Visibility(
                    visible: showHint,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: const Text(
                      'Tap to start recording',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ===== Boutons =====
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showSides) ...[
                        CircleButton(
                          size: 54,
                          circleColor: const Color(0xFFE5E7EB),
                          border: const BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                          icon: Icons.close_rounded,
                          iconSize: 26,
                          iconColor: const Color(0xFF6B7282),
                          label: 'Cancel',
                          labelWidth: 80,
                          showLabel: true,
                          onTap: () => _session.cancel(),
                        ),
                        const SizedBox(width: 20),
                      ],

                      // Centre (Switch rouge -> vert -> bleu)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _buildCenterButton(phase, key: ValueKey(phase)),
                      ),

                      if (showSides) ...[
                        const SizedBox(width: 20),
                        CircleButton(
                          size: 54,
                          circleColor: const Color(0xFFE5E7EB),
                          border: const BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                          icon: Icons.play_arrow_rounded,
                          iconSize: 30,
                          iconColor: const Color(0xFF6B7282),
                          label: 'Continue',
                          labelWidth: 80,
                          showLabel: true,
                          onTap: () => _session.resume(),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Bouton central selon la phase ----
  Widget _buildCenterButton(RecordingPhase phase, {Key? key}) {
    switch (phase) {
      case RecordingPhase.idle:
        // Rouge (start)
        return SizedBox(
          key: key,
          child: GappedCircleButton(
            size: 52,
            ringWidth: 3,
            ringGap: 3,
            ringColor: const Color(0xFFD9DDE3),
            gapColor: Colors.white,
            circleColor: const Color(0xFFEF5A49),
            label: 'Start',
            showLabel: false,
            onTap: () => _session.start(),
          ),
        );

      case RecordingPhase.recording:
        // Vert (pause)
        return SizedBox(
          key: key,
          child: CircleButton(
            size: 64,
            circleColor: const Color(0xFF22C55E),
            border: const BorderSide(color: Colors.blueGrey, width: 1),
            icon: Icons.pause,
            iconColor: Colors.white,
            label: 'Recording',
            showLabel: false,
            onTap: () => _session.pause(),
          ),
        );

      case RecordingPhase.paused:
        return SizedBox(
          key: key,
          child: CircleButton(
            size: 64,
            circleColor: const Color(0xFF3B82F6),
            border: const BorderSide(color: Colors.blueGrey, width: 1),
            // Utiliser l'icône conditionnellement
            icon: _uploading ? Icons.hourglass_empty : Icons.check,
            iconColor: Colors.white,
            label: _uploading ? 'Uploading...' : 'Done',
            showLabel: true,
            onTap: () async {
              // 1. Arrêter l'enregistrement d'abord
              final localPath = await _session.confirmStop();

              // 2. Fermer immédiatement le sheet
              if (mounted) {
                Navigator.pop(context);
              }

              // 3. Afficher le popup de loading avec l'upload
              if (localPath != null && mounted) {
                final result = await showUploadingDialog(
                  context: context,
                  uploadFuture: _uploadToSupabase(localPath),
                  localPath: localPath,
                );

                // 4. Optionnel : gérer le résultat
                if (result != null && result['success'] == true) {
                  debugPrint('Upload réussi: ${result['remotePath']}');
                } else if (result != null && result['success'] == false) {
                  debugPrint('Upload échoué: ${result['error']}');
                }
              }
            },
          ),
        );
    }
  }

  // ---- Indicateur de statut à gauche du timer ----
  Widget _buildStatusIndicator(RecordingPhase phase) {
    switch (phase) {
      case RecordingPhase.idle:
        return const SizedBox.shrink();
      case RecordingPhase.recording:
        return AnimatedBuilder(
          animation: _blink,
          builder:
              (_, __) => Opacity(
                opacity: _blink.value,
                child: const Icon(Icons.circle, color: Colors.red, size: 8),
              ),
        );
      case RecordingPhase.paused:
        return const Icon(Icons.circle, color: Colors.grey, size: 8);
    }
  }
}
