// lib/pages/app_configure_choice.dart
import 'package:flutter/material.dart';
import 'package:appa/models/appItem.dart';  // <-- même modèle

class AppConfigureChoice extends StatelessWidget {
  final List<AppItem> selectedApps;
  const AppConfigureChoice({super.key, required this.selectedApps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configure selected apps")),
      body: selectedApps.isEmpty
          ? const Center(child: Text("No app selected"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: selectedApps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final app = selectedApps[i];
                return ListTile(
                  leading: app.iconBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(app.iconBytes!, width: 40, height: 40, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.apps),
                  title: Text(app.label),
                  subtitle: Text(app.packageName, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: suite de la config
              Navigator.pop(context);
            },
            child: const Text("Save configuration"),
          ),
        ),
      ),
    );
  }
}
