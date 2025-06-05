import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ar_world_model.dart';
export 'ar_world_model.dart';

class ArWorldWidget extends StatefulWidget {
  const ArWorldWidget({super.key});

  @override
  State<ArWorldWidget> createState() => _ArWorldWidgetState();
}

class _ArWorldWidgetState extends State<ArWorldWidget> {
  late ArWorldModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArWorldModel());
    // Initialize and auto-open camera
    _model.initializeCameraKit();
    
    // Auto-open camera after CameraKit is initialized
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _model.openCameraKit();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'AR Camera Filters',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter', // Using a standard font
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _model.isLensListVisible ? Icons.close : Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _model.toggleLensList();
                  if (_model.isLensListVisible && _model.lensList.isEmpty) {
                    _model.loadLenses();
                  }
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Main camera button
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 80,
                          color: Colors.white,
                        ),
                        onPressed: () => _model.openCameraKit(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tap to open Camera with Filters',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Inter', // Using a standard font
                        color: Colors.white,
                      ),
                    ),
                    if (_model.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 1),
                        ),
                        child: Text(
                          _model.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Lens list section
            if (_model.isLensListVisible)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Available Filters',
                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (_model.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildLensContent(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLensContent() {
    if (_model.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading filters...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_model.lensList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_list, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No filters available.\nMake sure to configure your\nSnap Kit credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _model.loadLenses(),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _model.lensList.length,
      itemBuilder: (context, index) {
        final lens = _model.lensList[index];
        return _buildLensItem(lens, index);
      },
    );
  }

  Widget _buildLensItem(dynamic lens, int index) {
    // Handle different lens data structures
    final String lensId = lens?.id ?? '';
    final String groupId = lens?.groupId ?? '';
    final String name = lens?.name ?? 'Filter ${index + 1}';
    final List<String>? thumbnails = lens?.thumbnail;
    final String thumbnailUrl = (thumbnails?.isNotEmpty == true) ? thumbnails!.first : '';

    return GestureDetector(
      onTap: () {
        if (lensId.isNotEmpty && groupId.isNotEmpty) {
          _model.openCameraKitWithLens(lensId, groupId);
        } else {
          _showErrorSnackBar('Invalid lens data');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[700],
                            child: const Icon(
                              Icons.filter,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[700],
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[700],
                          child: const Icon(
                            Icons.filter,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}