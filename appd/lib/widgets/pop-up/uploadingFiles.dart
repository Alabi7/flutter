import 'package:flutter/material.dart';

class UploadingFilesPopup extends StatefulWidget {
  final Future<String?> uploadFuture;
  final String? localPath;

  const UploadingFilesPopup({
    super.key,
    required this.uploadFuture,
    this.localPath,
  });

  @override
  State<UploadingFilesPopup> createState() => _UploadingFilesPopupState();
}

class _UploadingFilesPopupState extends State<UploadingFilesPopup>
    with TickerProviderStateMixin {
  
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  bool _isCompleted = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationController.repeat();
    _scaleController.forward();
    
    _handleUpload();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    try {
      final remotePath = await widget.uploadFuture;
      
      setState(() {
        _isCompleted = true;
      });
      
      _rotationController.stop();
      
      // Attendre un peu pour montrer le succès
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (mounted) {
        Navigator.of(context).pop({
          'localPath': widget.localPath,
          'remotePath': remotePath,
          'success': true,
        });
      }
      
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      
      _rotationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône animée
            ScaleTransition(
              scale: _scaleController,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _hasError 
                      ? Colors.red.shade50 
                      : _isCompleted 
                          ? Colors.green.shade50 
                          : Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: _hasError
                    ? const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      )
                    : _isCompleted
                        ? const Icon(
                            Icons.check_circle_outline,
                            size: 40,
                            color: Colors.green,
                          )
                        : AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * 3.14159,
                                child: const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              );
                            },
                          ),
              ),
            ),

            const SizedBox(height: 20),

            // Titre
            Text(
              _hasError
                  ? 'Upload Failed'
                  : _isCompleted
                      ? 'Upload Complete!'
                      : 'Uploading...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _hasError ? Colors.red : Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              _hasError
                  ? 'Failed to upload your recording'
                  : _isCompleted
                      ? 'Your recording has been uploaded successfully'
                      : 'Please wait while we upload your recording',
                textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            if (_hasError) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade700,
                ),
              ),
            ],

            // Boutons (seulement en cas d'erreur)
            if (_hasError) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'localPath': widget.localPath,
                          'remotePath': null,
                          'success': false,
                          'error': _errorMessage,
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Relancer le popup avec retry
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => UploadingFilesPopup(
                            uploadFuture: _retryUpload(),
                            localPath: widget.localPath,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Indicateur de progression (seulement pendant upload)
            if (!_isCompleted && !_hasError) ...[
              const SizedBox(height: 20),
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<String?> _retryUpload() {
    // Ici, tu devrais recréer l'upload future
    // Pour l'instant, on retourne le même future
    return widget.uploadFuture;
  }
}

// Fonction helper pour afficher le popup
Future<Map<String, dynamic>?> showUploadingDialog({
  required BuildContext context,
  required Future<String?> uploadFuture,
  String? localPath,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => UploadingFilesPopup(
      uploadFuture: uploadFuture,
      localPath: localPath,
    ),
  );
}