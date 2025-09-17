import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';

Future<bool> ensureMicPermission(BuildContext context) async {
  final status = await Permission.microphone.request();

  if (status.isGranted) return true;

  if (status.isPermanentlyDenied && context.mounted) {
    final go = await _askOpenSettings(
      context,
      title: 'Permission micro requise',
      message:
          'Le micro est nécessaire pour enregistrer un audio. '
          'Vous pouvez l’activer dans les réglages.',
    );
    if (go == true) await openAppSettings();
  }
  return false;
}


/// Permission UNIQUEMENT pour l’upload de fichiers audio.
Future<bool> ensureUploadAudioPermission(BuildContext context) async {
  if (Platform.isIOS) {
    // Pour des fichiers audio via le Files picker (UIDocumentPicker), pas de permission nécessaire.
    // -> Retourne true directement.
    return true;
  }

  if (Platform.isAndroid) {
    // Essaie d’abord la permission moderne (Android 13+)
    final statusAudio = await Permission.audio.request();
    if (statusAudio.isGranted) return true;

    // Fallback (Android 12 et -) : STORAGE
    final statusStorage = await Permission.storage.request();
    if (statusStorage.isGranted) return true;

    // Gestion "permanently denied"
    final permanentlyDenied =
        statusAudio.isPermanentlyDenied || statusStorage.isPermanentlyDenied;

    if (permanentlyDenied && context.mounted) {
      final go = await _askOpenSettings(
        context,
        title: 'Accès audio requis',
        message:
            'Autorise l’accès aux fichiers audio dans les réglages pour importer un fichier.',
      );
      if (go == true) await openAppSettings();
    }
    return false;
  }

  // Autres plateformes non gérées
  return false;
}

Future<bool?> _askOpenSettings(BuildContext context,
    {required String title, required String message}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ouvrir les réglages')),
      ],
    ),
  );
}