import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ar_world_widget.dart' show ArWorldWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ArPreviewScreen extends StatefulWidget {
  final String filePath;
  final String fileType;

  const ArPreviewScreen({
    super.key,
    required this.filePath,
    required this.fileType,
  });

  @override
  State<ArPreviewScreen> createState() => _ArPreviewScreenState();
}

class _ArPreviewScreenState extends State<ArPreviewScreen> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  bool _isLoading = true;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  void _initializeMedia() {
    _isVideo = _checkIfVideo(widget.fileType);
    
    if (_isVideo) {
      _initializeVideo();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.file(File(widget.filePath));
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      setState(() => _isLoading = false);
    } catch (e) {
      if (kDebugMode) print('Video initialization error: $e');
      setState(() => _isLoading = false);
    }
  }

  bool _checkIfVideo(String fileType) {
    return fileType.toLowerCase().contains('video') ||
           fileType.toLowerCase().contains('mp4') ||
           fileType.toLowerCase().contains('mov');
  }

  Future<void> _shareMedia() async {
    if (_isSharing) return;
    
    setState(() => _isSharing = true);

    try {
      final message = _isVideo
          ? 'Check out this amazing AR video I created! 🎬✨ #ARCreation'
          : 'Look at this cool AR photo I made! 📸✨ #ARCreation';

      await Share.shareXFiles(
        [XFile(widget.filePath)],
        text: message,
        subject: _isVideo ? 'My AR Video' : 'My AR Photo',
      );
    } catch (e) {
      if (kDebugMode) print('Share error: $e');
      _showErrorSnackBar('Failed to share. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'Home',
      (route) => false,
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingView() : _buildPreviewContent(),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 28),
        onPressed: _navigateToHome,
      ),
      title: Text(
        _isVideo ? 'AR Video' : 'AR Photo',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading preview...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _isVideo ? _buildVideoPreview() : _buildImagePreview(),
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return _buildErrorView('Failed to load video');
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        _buildVideoControls(),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: Icon(
          _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play();
          });
        },
      ),
    );
  }

  Widget _buildImagePreview() {
    return Image.file(
      File(widget.filePath),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildErrorView('Failed to load image'),
    );
  }

  Widget _buildErrorView(String message) {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 50),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _navigateToHome,
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isSharing ? null : _shareMedia,
                icon: _isSharing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.share, color: Colors.white),
                label: Text(
                  _isSharing ? 'Sharing...' : 'Share',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class ArShareService {
  static Future<bool> shareMedia({
    required String filePath,
    required String fileType,
    String? customMessage,
  }) async {
    if (filePath.isEmpty) return false;

    try {
      final isVideo = fileType.toLowerCase().contains('video') || 
                     fileType.toLowerCase().contains('mp4');
      
      final message = customMessage ?? 
          (isVideo ? 'Watch this amazing AR video I made! 🎬✨' 
                   : 'Check out this cool AR photo I created! 📸✨');
      
      await Share.shareXFiles(
        [XFile(filePath)],
        text: message,
        subject: isVideo ? 'AR Video' : 'AR Photo',
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) print('Share error: $e');
      return false;
    }
  }
}

class ArWorldModel extends FlutterFlowModel<ArWorldWidget> implements CameraKitFlutterEvents {
  static const List<String> _groupIdList = ['2a75b645-21f9-4750-8333-c72836b7a992'];
  static const String _cameraKitApiToken = 'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzIwNjYzMDc0LCJzdWIiOiJlN2RlZjgwNi04YzlmLTQxN2MtODlhYi0wNWFjYmM0NjAzZmJ-U1RBR0lOR342ZDJiZmNkYy1mYjkxLTRiYzktOWRhYi03YjA5Zjg5ODI1NTQifQ.N9gLbjfvHefJ1DglPfmkg6cVnA8wmDVjLlwh4qj3u7A';

  CameraKitFlutterImpl? _cameraKitFlutterImpl;
  BuildContext? _context;
  
  String filePath = '';
  String fileType = '';
  List<Lens> lensList = [];
  bool isLoading = false;
  String? errorMessage;
  bool _isInitialized = false;
  bool hasMediaToShare = false;
  
  @override
  void initState(BuildContext context) {
    _context = context;
    _initializeCameraKit();
  }
  
  void _initializeCameraKit() {
    if (_isInitialized) return;
    
    try {
      _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
      _isInitialized = true;
      errorMessage = null;
      
      if (kDebugMode) {
        print('CameraKit initialized successfully');
      }
    } catch (e) {
      _handleError('Failed to initialize CameraKit: $e');
    }
  }
  
  Future<void> openCameraKit() async {
    if (!_isInitialized || _cameraKitFlutterImpl == null) {
      _handleError('CameraKit not initialized');
      return;
    }
    
    try {
      errorMessage = null;
      await _cameraKitFlutterImpl!.openCameraKit(
        groupIds: _groupIdList,
        isHideCloseButton: false,
      );
    } on PlatformException catch (e) {
      _handleError('Failed to open camera: ${e.message}');
      _navigateToHome();
    } catch (e) {
      _handleError('Failed to open camera: $e');
      _navigateToHome();
    }
  }
  
  Future<void> openCameraKitWithLens(String? lensId, String? groupId) async {
    if (!_isInitialized || _cameraKitFlutterImpl == null) {
      _handleError('CameraKit not initialized');
      return;
    }
    
    if (_isInvalidLensParams(lensId, groupId)) {
      _handleError('Invalid lens or group ID');
      return;
    }
    
    try {
      errorMessage = null;
      await _cameraKitFlutterImpl!.openCameraKitWithSingleLens(
        lensId: lensId!,
        groupId: groupId!,
        isHideCloseButton: false,
      );
    } on PlatformException catch (e) {
      _handleError('Failed to open lens: ${e.message}');
    } catch (e) {
      _handleError('Failed to open lens: $e');
    }
  }
  
  bool _isInvalidLensParams(String? lensId, String? groupId) {
    return lensId == null || groupId == null || lensId.isEmpty || groupId.isEmpty;
  }
  
  void _handleError(String message) {
    errorMessage = message;
    if (kDebugMode) {
      print('ArWorldModel Error: $message');
    }
  }
  
  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    try {
      filePath = result["path"]?.toString() ?? '';
      fileType = result["type"]?.toString() ?? '';
      hasMediaToShare = filePath.isNotEmpty;
      
      if (kDebugMode) {
        print('CameraKit result: $filePath, type: $fileType');
      }
      
      if (hasMediaToShare) {
        _navigateToPreview();
      } else {
        _navigateToHome();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error handling camera kit result: $e");
      }
      _navigateToHome();
    }
  }

  void _navigateToPreview() {
    if (_context?.mounted == true) {
      Navigator.of(_context!).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ArPreviewScreen(
            filePath: filePath,
            fileType: fileType,
          ),
        ),
      );
    }
  }

  Future<bool> shareCurrentMedia([String? customMessage]) async {
    if (!hasMediaToShare) return false;
    
    return await ArShareService.shareMedia(
      filePath: filePath,
      fileType: fileType,
      customMessage: customMessage,
    );
  }
  
  void _navigateToHome() {
    if (_context?.mounted == true) {
      Navigator.of(_context!).pushNamedAndRemoveUntil(
        'Home',
        (route) => false,
      );
    }
  }
  
  @override
  void receivedLenses(List<Lens> lenses) {
    try {
      lensList = lenses;
      isLoading = false;
      errorMessage = lenses.isEmpty ? 'No lenses found for the configured groups' : null;
      
      if (kDebugMode) {
        print('Received ${lenses.length} lenses');
      }
    } catch (e) {
      isLoading = false;
      _handleError('Error processing lenses: $e');
    }
  }

  void onCameraKitClosed() {
    if (kDebugMode) {
      print('Camera was closed by user, navigating to Home');
    }
    _navigateToHome();
  }

  @override
  void dispose() {
    _cameraKitFlutterImpl = null;
    _context = null;
    
    if (kDebugMode) {
      print('ArWorldModel disposed');
    }
  }
}