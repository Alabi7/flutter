import 'dart:typed_data';

class AppItem {
  final String label;
  final String packageName;
  final Uint8List? iconBytes;

  AppItem({
    required this.label,
    required this.packageName,
    this.iconBytes,
  });
}
