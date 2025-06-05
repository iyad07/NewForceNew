import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';

class ArShareDialog extends StatelessWidget {
  final String filePath;
  final String fileType;
  final VoidCallback onDismiss;

  const ArShareDialog({
    super.key,
    required this.filePath,
    required this.fileType,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = _isVideo(fileType);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            isVideo ? Icons.video_camera_back : Icons.camera_alt,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(isVideo ? 'Video Created!' : 'Photo Captured!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isVideo 
              ? 'Your AR video is ready to share!'
              : 'Your AR photo looks amazing!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareMedia(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareMedia(BuildContext context) async {
    try {
      final message = _isVideo(fileType)
          ? 'Check out this awesome AR video I created! 🎬✨'
          : 'Look at this cool AR photo I made! 📸✨';

      await Share.shareXFiles(
        [XFile(filePath)],
        text: message,
        subject: _isVideo(fileType) ? 'AR Video' : 'AR Photo',
      );
      
      if (context.mounted) {
        Navigator.of(context).pop();
        onDismiss();
      }
    } catch (e) {
      if (kDebugMode) print('Share error: $e');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
        onDismiss();
      }
    }
  }

  bool _isVideo(String fileType) {
    return fileType.toLowerCase().contains('video') ||
           fileType.toLowerCase().contains('mp4') ||
           fileType.toLowerCase().contains('mov');
  }
}