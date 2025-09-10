// lib/pages/app_choice_blocking.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:appa/models/appItem.dart';
import 'package:appa/pages/appConfigureChoice.dart';

class AppChoiceBlocking extends StatefulWidget {
  const AppChoiceBlocking({super.key});

  @override
  State<AppChoiceBlocking> createState() => _AppChoiceBlockingState();
}

class _AppChoiceBlockingState extends State<AppChoiceBlocking> {
  final Set<String> _selectedPackages = {};
  List<AppItem> _apps = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    try {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      if (!Platform.isAndroid) {
        setState(() {
          _apps = [];
          _loading = false;
          _errorMessage = "Cette fonctionnalité n'est disponible que sur Android";
        });
        return;
      }

      // Récupérer les apps installées
      final rawApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: false, // Changé à false pour éviter trop d'apps système
      );

      if (rawApps.isEmpty) {
        setState(() {
          _apps = [];
          _loading = false;
          _errorMessage = "Aucune application trouvée";
        });
        return;
      }

      // Trier par nom
      rawApps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

      // Convertir en AppItem
      final List<AppItem> appItems = [];
      for (var app in rawApps) {
        try {
          Uint8List? iconBytes;
          if (app is ApplicationWithIcon && app.icon != null) {
            iconBytes = app.icon;
          }
          
          appItems.add(AppItem(
            label: app.appName,
            packageName: app.packageName,
            iconBytes: iconBytes,
          ));
        } catch (e) {
          // Si une app pose problème, on la passe
          print('Erreur avec l\'app ${app.appName}: $e');
        }
      }

      setState(() {
        _apps = appItems;
        _loading = false;
      });

    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = "Erreur lors du chargement des applications: $e";
        _apps = [];
      });
    }
  }

  void _toggle(String pkg) {
    setState(() {
      if (_selectedPackages.contains(pkg)) {
        _selectedPackages.remove(pkg);
      } else {
        _selectedPackages.add(pkg);
      }
    });
  }

  Widget _buildAppTile(AppItem app) {
    final selected = _selectedPackages.contains(app.packageName);
    
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: app.iconBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    app.iconBytes!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.apps, size: 24);
                    },
                  ),
                )
              : const Icon(Icons.apps, size: 24),
        ),
        title: Text(
          app.label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          app.packageName,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Checkbox(
          value: selected,
          onChanged: (_) => _toggle(app.packageName),
          activeColor: Colors.purpleAccent,
        ),
        onTap: () => _toggle(app.packageName),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? Colors.purpleAccent : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir les apps à bloquer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInstalledApps,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Chargement des applications..."),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadInstalledApps,
                        child: const Text("Réessayer"),
                      ),
                    ],
                  ),
                )
              : _apps.isEmpty
                  ? const Center(
                      child: Text("Aucune application trouvée"),
                    )
                  : Column(
                      children: [
                        if (_selectedPackages.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.purpleAccent.withOpacity(0.1),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.purpleAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${_selectedPackages.length} app(s) sélectionnée(s)",
                                  style: TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _apps.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) => _buildAppTile(_apps[i]),
                          ),
                        ),
                      ],
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
                        builder: (_) => AppConfigureChoice(selectedApps: selectedApps),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _selectedPackages.isEmpty 
                  ? "Sélectionnez des applications"
                  : "Confirmer (${_selectedPackages.length})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}