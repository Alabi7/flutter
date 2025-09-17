import 'package:flutter/material.dart';

void main() => runApp(const NoteAIApp());

class NoteAIApp extends StatelessWidget {
  const NoteAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F6F8);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111111)),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/* ===========================
            HOME
   =========================== */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum HomeTab { notes, folders }

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _tab = HomeTab.notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _TopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _SegmentedTabs(
            current: _tab,
            onChanged: (t) => setState(() => _tab = t),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _tab == HomeTab.notes
                  ? const _NotesEmptyState()
                  : const _FolderList(),
            ),
          ),
        ],
      ),
      // barre d’actions en bas
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: 'Record',
                  icon: Icons.fiber_manual_record_rounded,
                  background: Colors.black,
                  foreground: Colors.white,
                  onPressed: () {
                    _showNewNoteSheet(context, initialIndex: 0);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PillButton(
                  label: 'New Note',
                  icon: Icons.edit_outlined,
                  background: Colors.white,
                  foreground: Colors.black87,
                  border: BorderSide(color: Colors.black12),
                  onPressed: () {
                    _showNewNoteSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/* ===========================
          APP BAR
   =========================== */

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: false,
      title: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text('Note AI', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _ProBadge(onPressed: () {}),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _UserBubble(onPressed: () {}),
        ),
      ],
    );
  }
}

class _ProBadge extends StatelessWidget {
  final VoidCallback onPressed;
  const _ProBadge({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_awesome, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text('PRO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final VoidCallback onPressed;
  const _UserBubble({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(Icons.person_outline, color: Colors.black54),
        ),
      ),
    );
  }
}

/* ===========================
       TABS (Notes/Folders)
   =========================== */

class _SegmentedTabs extends StatelessWidget {
  final HomeTab current;
  final ValueChanged<HomeTab> onChanged;
  const _SegmentedTabs({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _TabPill(
              icon: Icons.edit_note_rounded,
              label: 'All Notes',
              selected: current == HomeTab.notes,
              onTap: () => onChanged(HomeTab.notes),
            ),
            _TabPill(
              icon: Icons.folder_open_rounded,
              label: 'Folders',
              selected: current == HomeTab.folders,
              onTap: () => onChanged(HomeTab.folders),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabPill({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : Colors.black87),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===========================
          NOTES (EMPTY)
   =========================== */

class _NotesEmptyState extends StatelessWidget {
  const _NotesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('😴', style: TextStyle(fontSize: 42)),
            SizedBox(height: 10),
            Text("You haven't created any notes yet.", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

/* ===========================
           FOLDERS
   =========================== */

class _FolderList extends StatelessWidget {
  const _FolderList();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _FolderTile(title: 'All Notes', count: 0),
      _FolderTile(title: 'fff', count: 0),
    ];

    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            itemBuilder: (_, i) => items[i],
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
        // bouton New Folder centré en bas
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _PillButton(
              label: 'New Folder',
              icon: Icons.folder_open,
              background: Colors.black,
              foreground: Colors.white,
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }
}

class _FolderTile extends StatelessWidget {
  final String title;
  final int count;
  const _FolderTile({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder_rounded, color: Color(0xFFF5A524)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text('$count notes', style: const TextStyle(color: Colors.black45)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===========================
        BOTTOM SHEET
   =========================== */

void _showNewNoteSheet(BuildContext context, {int? initialIndex}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NewNoteSheet(initialIndex: initialIndex),
  );
}

class _NewNoteSheet extends StatelessWidget {
  final int? initialIndex;
  const _NewNoteSheet({this.initialIndex});

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
              itemBuilder: (_, i) => _NewNoteItem(
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

class _NewNoteItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NewNoteItem({
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

/* ===========================
        COMMON WIDGETS
   =========================== */

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final BorderSide? border;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: StadiumBorder(side: border ?? BorderSide.none),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




