import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:new_force_new_hope/flutter_flow/flutter_flow_theme.dart';
import 'package:share_plus/share_plus.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'ar_world_widget.dart' show ArWorldWidget;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';


class ArWorldModel extends FlutterFlowModel<ArWorldWidget> implements CameraKitFlutterEvents {
  static const List<String> _groupIdList = ['2a75b645-21f9-4750-8333-c72836b7a992'];
  static const String _cameraKitApiToken = 'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzIwNjYzMDc0LCJzdWIiOiJlN2RlZjgwNi04YzlmLTQxN2MtODlhYi0wNWFjYmM0NjAzZmJ-U1RBR0lOR342ZDJiZmNkYy1mYjkxLTRiYzktOWRhYi03YjA5Zjg5ODI1NTQifQ.N9gLbjfvHefJ1DglPfmkg6cVnA8wmDVjLlwh4qj3u7A';
  
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;
  BuildContext? _context;
  
  String filePath = '';
  String fileType = '';
  List<Lens> lensList = [];
  bool isLoading = false;
  String? errorMessage;
  bool hasMediaToShare = false;
  bool _hasProcessedResult = false;
  
  @override
  void initState(BuildContext context) {
    _context = context;
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
    _initializeCameraKit();
  }
  
  Future<void> _initializeCameraKit() async {
    try {
      await _openCameraKit();
      
      if (kDebugMode) {
        print('✅ CameraKit initialized and opened successfully');
      }
    } catch (e) {
      _handleError('Failed to initialize CameraKit: $e');
    }
  }
  
  Future<void> _openCameraKit() async {
    try {
      errorMessage = null;
      if (kDebugMode) {
        print('🎥 Opening CameraKit with groups: $_groupIdList');
      }
      
      await _cameraKitFlutterImpl.openCameraKit(
        groupIds: _groupIdList, 
        isHideCloseButton: false
      );
      
      if (kDebugMode) {
        print('✅ CameraKit opened successfully - waiting for user interaction');
      }
    } on PlatformException catch (e) {
      _handleError('Failed to open camera: ${e.message}');
    } catch (e) {
      _handleError('Failed to open camera: $e');
    }
  }
  
  void _handleError(String message) {
    errorMessage = message;
    isLoading = false;
    if (kDebugMode) {
      print('❌ ArWorldModel Error: $message');
    }
  }
  
  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    if (_hasProcessedResult) {
      if (kDebugMode) {
        print('⚠️ Result already processed, ignoring duplicate');
      }
      return;
    }
    
    _hasProcessedResult = true;
    
    if (kDebugMode) {
      print('🎯 ========== CAMERA RESULT RECEIVED ==========');
      print('Raw result: $result');
      print('Result keys: ${result.keys.toList()}');
      print('Context mounted: ${_context?.mounted}');
    }
    
    try {
      filePath = result["path"] as String? ?? '';
      fileType = result["type"] as String? ?? '';
      hasMediaToShare = filePath.isNotEmpty;
      
      if (kDebugMode) {
        print('📁 Parsed filePath: "$filePath"');
        print('📄 Parsed fileType: "$fileType"');
        print('📊 hasMediaToShare: $hasMediaToShare');
      }
      
      if (hasMediaToShare && _context?.mounted == true) {
        if (kDebugMode) {
          print('✅ MEDIA CAPTURED - Showing success dialog');
        }
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_context?.mounted == true) {
            _showSuccessDialog();
          }
        });
      } else {
        if (kDebugMode) {
          print('❌ NO MEDIA CAPTURED');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error handling camera kit result: $e");
      }
    }
  }

  void _showSuccessDialog() {
  if (_context?.mounted != true) return;
  
  if (kDebugMode) {
    print('📱 Showing success dialog with media preview');
  }
  
  final isVideo = fileType.toLowerCase() == 'video';
  
  showDialog(
    context: _context!,
    barrierDismissible: true,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(dialogContext).size.width,
        height: MediaQuery.of(dialogContext).size.height * 0.9,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(_context!).primaryBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    isVideo ? Icons.video_camera_back : Icons.camera_alt,
                    color: FlutterFlowTheme.of(_context!).primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isVideo ? 'Video Created!' : 'Photo Captured!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(_context!).primaryText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    color: Colors.grey.shade50,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: isVideo
                        ?  Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline, size: 80, color: FlutterFlowTheme.of(_context!).primary),
                                SizedBox(height: 12),
                                Text('Video Preview', style: TextStyle(fontSize: 18, color: FlutterFlowTheme.of(_context!).primary)),
                              ],
                            ),
                          )
                        : Image.file(
                            File(filePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 80, color: Colors.grey),
                                  SizedBox(height: 12),
                                  Text('Image Preview', style: TextStyle(fontSize: 18, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    isVideo
                        ? 'Your AR video is ready to share!'
                        : 'Your AR photo looks amazing!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: FlutterFlowTheme.of(_context!).primaryText),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _context?.pushNamed('Home');
                            if (kDebugMode) {
                              print('👤 User closed dialog and navigated to Home');
                            }
                          },
                          icon: const Icon(Icons.close, color: Colors.grey),
                          label: const Text('Discard', style: TextStyle(color: Colors.grey)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (kDebugMode) {
                              print('📤 User clicked share');
                            }
                            
                            await _shareMedia();
                            Navigator.of(dialogContext).pop();
                          },
                          icon: const Icon(Icons.share, color: Colors.white),
                          label: const Text('Share', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FlutterFlowTheme.of(_context!).primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Future<void> _shareMedia() async {
    if (!hasMediaToShare) {
      if (kDebugMode) {
        print('❌ No media to share');
      }
      return;
    }
    
    if (kDebugMode) {
      print('📤 Sharing media: $filePath');
    }
    
    try {
      final message = fileType.toLowerCase() == 'video'
          ? 'Check out this awesome AR video I created! 🎬✨'
          : 'Look at this cool AR photo I made! 📸✨';
      
      await Share.shareXFiles(
        [XFile(filePath)], 
        text: message
      );
      
      if (kDebugMode) {
        print('✅ Media shared successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Share error: $e');
      }
    }
  }
  
  @override
  void receivedLenses(List<Lens> lensList) {
    try {
      this.lensList = lensList;
      isLoading = false;
      errorMessage = lensList.isEmpty ? 'No lenses found for the configured groups' : null;
      
      if (kDebugMode) {
        print('📸 Received ${lensList.length} lenses');
        for (var lens in lensList) {
          print('  - Lens: ${lens.name} (${lens.id})');
        }
      }
    } catch (e) {
      isLoading = false;
      _handleError('Error processing lenses: $e');
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('🗑️ ArWorldModel disposing');
    }
    _context = null;
  }

  
}