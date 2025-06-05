import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'ar_world_widget.dart' show ArWorldWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';



class ArWorldModel extends FlutterFlowModel<ArWorldWidget> implements CameraKitFlutterEvents {
  // CameraKit implementation
  CameraKitFlutterImpl? _cameraKitFlutterImpl;
  
  // Current state
  String filePath = '';
  String fileType = '';
  List<Lens> lensList = [];
  bool isLoading = false;
  bool isLensListVisible = false;
  String? errorMessage;
  
  // Constants - replace with your actual values
  static const List<String> groupIdList = [
    '2a75b645-21f9-4750-8333-c72836b7a992'
  ];
  
  static const String cameraKitApiToken =
      'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzIwNjYzMDc0LCJzdWIiOiJlN2RlZjgwNi04YzlmLTQxN2MtODlhYi0wNWFjYmM0NjAzZmJ-U1RBR0lOR342ZDJiZmNkYy1mYjkxLTRiYzktOWRhYi03YjA5Zjg5ODI1NTQifQ.N9gLbjfvHefJ1DglPfmkg6cVnA8wmDVjLlwh4qj3u7A';
  
  @override
  void initState(BuildContext context) {
    // Remove super.initState() since it's abstract in the supertype
    initializeCameraKit();
    // Auto-open camera after a short delay to ensure CameraKit is initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      openCameraKit();
    });
  }
  
  /// Initialize CameraKit and auto-open camera
  void initializeCameraKit() {
    try {
      // Only initialize if not already initialized
      if (_cameraKitFlutterImpl == null) {
        _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
        //_cameraKitFlutterImpl!.setCredentials(apiToken: cameraKitApiToken);
        if (kDebugMode) {
          print('CameraKit initialized successfully');
        }
        
        // Auto-open camera after initialization
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_cameraKitFlutterImpl != null) {
            openCameraKit();
          }
        });
      }
    } catch (e) {
      errorMessage = 'Failed to initialize CameraKit: $e';
      if (kDebugMode) {
        print('CameraKit initialization error: $e');
      }
    }
  }
  
  /// Load available lenses
  Future<void> loadLenses() async {
    if (isLoading || _cameraKitFlutterImpl == null) return;
    
    try {
      isLoading = true;
      errorMessage = null;
      
      await _cameraKitFlutterImpl!.getGroupLenses(groupIds: groupIdList);
      
      if (kDebugMode) {
        print('Requesting lenses for groups: $groupIdList');
      }
    } on PlatformException catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load lenses: ${e.message}';
      if (kDebugMode) {
        print('Platform exception getting group lenses: ${e.message}');
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load lenses: $e';
      if (kDebugMode) {
        print('Error getting group lenses: $e');
      }
    }
  }
  
  /// Open CameraKit with all lenses
  Future<void> openCameraKit() async {
    if (_cameraKitFlutterImpl == null) {
      errorMessage = 'CameraKit not initialized';
      return;
    }
    
    try {
      errorMessage = null;
      await _cameraKitFlutterImpl!.openCameraKit(
        groupIds: groupIdList,
        isHideCloseButton: false,
      );
    } on PlatformException catch (e) {
      errorMessage = 'Failed to open camera: ${e.message}';
      if (kDebugMode) {
        print('Platform exception opening camera kit: ${e.message}');
      }
    } catch (e) {
      errorMessage = 'Failed to open camera: $e';
      if (kDebugMode) {
        print('Error opening camera kit: $e');
      }
    }
  }
  
  /// Open CameraKit with specific lens
  Future<void> openCameraKitWithLens(String? lensId, String? groupId) async {
    if (_cameraKitFlutterImpl == null) {
      errorMessage = 'CameraKit not initialized';
      return;
    }
    
    if (lensId == null || groupId == null || lensId.isEmpty || groupId.isEmpty) {
      errorMessage = 'Invalid lens or group ID';
      return;
    }
    
    try {
      errorMessage = null;
      await _cameraKitFlutterImpl!.openCameraKitWithSingleLens(
        lensId: lensId,
        groupId: groupId,
        isHideCloseButton: false,
      );
    } on PlatformException catch (e) {
      errorMessage = 'Failed to open lens: ${e.message}';
      if (kDebugMode) {
        print('Platform exception opening single lens: ${e.message}');
      }
    } catch (e) {
      errorMessage = 'Failed to open lens: $e';
      if (kDebugMode) {
        print('Error opening single lens: $e');
      }
    }
  }
  
  /// Toggle lens list visibility
  void toggleLensList() {
    isLensListVisible = !isLensListVisible;
    errorMessage = null; // Clear any previous errors
    
    // Load lenses when showing the list for the first time
    if (isLensListVisible && lensList.isEmpty && !isLoading) {
      loadLenses();
    }
  }
  
  // CameraKitFlutterEvents implementation
  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    try {
      filePath = result["path"]?.toString() ?? '';
      fileType = result["type"]?.toString() ?? '';
      
      if (kDebugMode) {
        print('CameraKit result: $filePath, type: $fileType');
      }
      
      // Here you can handle the captured media
      // For example, navigate to a result screen:
      /*
      if (filePath.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaResultWidget(
              filePath: filePath,
              fileType: fileType,
            ),
          ),
        );
      }
      */
      
    } catch (e) {
      if (kDebugMode) {
        print("Error handling camera kit result: $e");
      }
    }
  }
  
  @override
  void receivedLenses(List<Lens> lenses) {
    try {
      lensList = lenses;
      isLoading = false;
      errorMessage = null;
      
      if (kDebugMode) {
        print('Received ${lenses.length} lenses');
        for (var lens in lenses) {
          print('Lens: ${lens.name} (ID: ${lens.id})');
        }
      }
      
      if (lensList.isEmpty) {
        errorMessage = 'No lenses found for the configured groups';
      }
      
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error processing lenses: $e';
      if (kDebugMode) {
        print("Error handling received lenses: $e");
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources if needed
    if (kDebugMode) {
      print('ArWorldModel disposed');
    }
// No need to call super.dispose() since it's abstract in the supertype
  }
}