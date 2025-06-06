import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'utils/media_utils.dart';

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
    final isVideo = MediaUtils.isVideo(fileType);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            isVideo ? Icons.video_camera_back : Icons.camera_alt,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(MediaUtils.getCreationMessage(fileType)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            MediaUtils.getReadyMessage(fileType),
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
      final message = MediaUtils.getDefaultShareMessage(fileType);
      final subject = MediaUtils.getShareSubject(fileType);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: message,
        subject: subject,
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
}