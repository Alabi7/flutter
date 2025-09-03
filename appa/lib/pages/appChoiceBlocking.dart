import 'package:appa/widgets/selectTypeBlocking.dart';
import 'package:flutter/material.dart';

class AppItem {
  final String name;
  final IconData icon;
  const AppItem(this.name, this.icon);
}

class AppChoiceBlocking extends StatefulWidget {
  final BlockingMode mode;
  const AppChoiceBlocking({super.key, required this.mode});

  @override
  State<AppChoiceBlocking> createState() => _ChoiceAppBlockingState();
}

class _ChoiceAppBlockingState extends State<AppChoiceBlocking> {
  final List<AppItem> _apps = const [
    AppItem("Instagram", Icons.camera_alt),
    AppItem("TikTok", Icons.play_circle),
    AppItem("YouTube", Icons.ondemand_video),
  ];

  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose apps to block"),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _apps.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final app = _apps[i];
          final isSelected = _selected.contains(i);
          return ListTile(
            leading: Icon(app.icon),
            title: Text(app.name),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (_) {
                setState(() {
                  if (isSelected) {
                    _selected.remove(i);
                  } else {
                    _selected.add(i);
                  }
                });
              },
            ),
            onTap: () {
              setState(() {
                isSelected ? _selected.remove(i) : _selected.add(i);
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSelected ? Colors.purpleAccent : Colors.grey.shade300),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          onPressed: _selected.isEmpty
              ? null
              : () {
                  // Récupère la sélection
                  final selectedApps = _selected.map((i) => _apps[i]).toList();

                  // Route suivante en fonction du mode
                  final next = widget.mode == BlockingMode.now
                      ? PageM(selectedApps: selectedApps)
                      : PageN(selectedApps: selectedApps);

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => next));
                },
          child: Text(widget.mode == BlockingMode.now ? "Confirm & configure now" : "Confirm & schedule"),
        ),
      ),
    );
  }
}



class PageM extends StatelessWidget {
  final List<AppItem> selectedApps;
  const PageM({super.key, required this.selectedApps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configure Blocking (Now)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Apps: ${selectedApps.map((a) => a.name).join(', ')}"),
      ),
    );
  }
}

class PageN extends StatelessWidget {
  final List<AppItem> selectedApps;
  const PageN({super.key, required this.selectedApps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configure Blocking (Schedule)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Apps: ${selectedApps.map((a) => a.name).join(', ')}"),
      ),
    );
  }
}
