import 'package:appd/configs/permissions.dart';
import 'package:appd/screens/recordings_list_screen.dart';
import 'package:appd/widgets/pop-up/uploadingFiles.dart';
import 'package:appd/widgets/record/audioRecord.dart';
import 'package:flutter/material.dart';

/// Ouvre le bottom sheet "Record"
Future<void> showNewNoteRecord(BuildContext context, {int? initialIndex}) {
  return showModalBottomSheet(
    // <-- corrigé ici
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (_) => NewNoteRecord(initialIndex: initialIndex),
  );
}

/// Contenu du bottom sheet
class NewNoteRecord extends StatelessWidget {
  final int? initialIndex;
  const NewNoteRecord({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // callbacks différentes selon l’item
    // final actions = <VoidCallback>[
    //   () { debugPrint('1'); }, // Record Audio
    //   () { debugPrint('2'); }, // Upload Audio
    //   () { debugPrint('3'); }, // Use Youtube video
    // ];

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
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'New Record',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 4),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              itemCount: 3,
              separatorBuilder:
                  (_, __) => const Divider(color: Colors.black12, height: 1),
              itemBuilder:
                  (_, i) => NewNoteItem(
                    icon:
                        const [
                          Icons.graphic_eq_rounded, // 0 : Record
                          Icons.library_music_outlined, // 1 : Upload
                          Icons.ondemand_video_rounded, // 2 : YouTube
                        ][i],
                    color:
                        const [
                          Color(0xFF567DF4),
                          Color(0xFFF5A524),
                          Color(0xFFE85D75),
                        ][i],
                    title:
                        const [
                          'Record Audio',
                          'Upload Audio',
                          'Use Youtube video',
                        ][i],
                    subtitle:
                        const [
                          'Instantly record and save your thoughts',
                          'Import existing audio files seamlessly',
                          'Turn videos into organized notes',
                        ][i],
                    onTap: () async {
                      if (i == 0) {
                        // Record -> demander le micro
                        final ok = await ensureMicPermission(context);
                        if (!ok) return;
                        Navigator.pop(context);
                        debugPrint('1');
                        // TODO: démarrer l’enregistreur
                        showAudioRecord(context);
                      } else if (i == 1) {
                        // Upload -> demander accès fichiers/médias
                        final ok = await ensureUploadAudioPermission(context);
                        if (!ok) return;
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RecordingsListScreen(),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        debugPrint(
                          '3',
                        ); // TODO: flux YouTube (pas de permission spéciale ici)
                        showUploadingDialog(
                          context: context,
                          uploadFuture: Future.delayed(
                            const Duration(seconds: 2),
                            () => 'uploads/test/success.m4a',
                          ),
                          localPath: 'local/test.m4a',
                        );
                                          }
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une ligne du sheet
class NewNoteItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const NewNoteItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.12),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
    );
  }
}
