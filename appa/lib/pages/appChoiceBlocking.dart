// lib/pages/app_choice_blocking.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:appa/models/appItem.dart';                // <-- modèle unique
import 'package:appa/pages/appConfigureChoice.dart';     // <-- destination

class AppChoiceBlocking extends StatefulWidget {
  const AppChoiceBlocking({super.key});

  @override
  State<AppChoiceBlocking> createState() => _AppChoiceBlockingState();
}

class _AppChoiceBlockingState extends State<AppChoiceBlocking> {
  final Set<String> _selectedPackages = {};
  List<AppItem> _apps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    if (!Platform.isAndroid) {
      setState(() { _apps = []; _loading = false; });
      return;
    }
    final rawApps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );

    rawApps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

    setState(() {
      _apps = rawApps.map((app) {
        final icon = (app is ApplicationWithIcon) ? app.icon : null;
        return AppItem(label: app.appName, packageName: app.packageName, iconBytes: icon);
      }).toList();
      _loading = false;
    });
  }

  void _toggle(String pkg) {
    setState(() {
      _selectedPackages.contains(pkg) ? _selectedPackages.remove(pkg) : _selectedPackages.add(pkg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose apps to block")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _apps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final app = _apps[i];
                final selected = _selectedPackages.contains(app.packageName);
                return ListTile(
                  leading: app.iconBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(app.iconBytes!, width: 40, height: 40, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.apps),
                  title: Text(app.label),
                  subtitle: Text(app.packageName, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  trailing: Checkbox(value: selected, onChanged: (_) => _toggle(app.packageName)),
                  onTap: () => _toggle(app.packageName),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: selected ? Colors.purpleAccent : Colors.grey.shade300),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _selectedPackages.isEmpty
                ? null
                : () {
                    final selectedApps = _apps
                        .where((a) => _selectedPackages.contains(a.packageName))
                        .toList();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AppConfigureChoice(selectedApps: selectedApps), // <--
                      ),
                    );
                  },
            child: const Text("Confirm"),
          ),
        ),
      ),
    );
  }
}
