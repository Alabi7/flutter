import 'package:flutter/material.dart';

/// Ouvre le bottom sheet "New Note"
Future<void> showNewNoteSheet(BuildContext context, {int? initialIndex}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => NewNoteSheet(initialIndex: initialIndex),
  );
}

/// Contenu du bottom sheet
class NewNoteSheet extends StatelessWidget {
  final int? initialIndex;
  const NewNoteSheet({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('New Note', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 4),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              itemBuilder: (_, i) => NewNoteItem(
                icon: const [
                  Icons.graphic_eq_rounded,
                  Icons.library_music_outlined,
                  Icons.ondemand_video_rounded
                ][i],
                color: const [Color(0xFF567DF4), Color(0xFFF5A524), Color(0xFFE85D75)][i],
                title: const ['Record Audio', 'Upload Audio', 'Use Youtube video'][i],
                subtitle: const [
                  'Instantly record and save your thoughts',
                  'Import existing audio files seamlessly',
                  'Turn videos into organized notes'
                ][i],
                onTap: () {
                  Navigator.pop(context);
                  // TODO: navigate to the corresponding flow
                },
              ),
              separatorBuilder: (_, __) => Divider(color: Colors.black12, height: 1),
              itemCount: 3,
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
