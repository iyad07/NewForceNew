import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

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