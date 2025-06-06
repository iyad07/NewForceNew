import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ArShareService {
  static const String _appName = 'NewForce AR';
  
  static Future<bool> shareMedia({
    required String filePath,
    required String fileType,
    String? customMessage,
  }) async {
    if (filePath.isEmpty) {
      if (kDebugMode) print('No file to share');
      return false;
    }

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        if (kDebugMode) print('File does not exist: $filePath');
        return false;
      }

      await _requestPermissions();
      
      return _isVideo(fileType) 
          ? await _shareVideo(file, customMessage)
          : await _shareImage(file, customMessage);
    } catch (e) {
      if (kDebugMode) print('Share error: $e');
      return false;
    }
  }

  static Future<bool> _shareImage(File imageFile, String? customMessage) async {
    try {
      final message = customMessage ?? 'Check out this cool AR photo I created with $_appName! 📸✨';
      
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: message,
        subject: 'AR Photo from $_appName',
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) print('Image share error: $e');
      return false;
    }
  }

  static Future<bool> _shareVideo(File videoFile, String? customMessage) async {
    try {
      final message = customMessage ?? 'Watch this amazing AR video I made with $_appName! 🎬✨';
      
      await Share.shareXFiles(
        [XFile(videoFile.path)],
        text: message,
        subject: 'AR Video from $_appName',
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) print('Video share error: $e');
      return false;
    }
  }

  static Future<bool> saveToGallery({
    required String filePath,
    required String fileType,
  }) async {
    if (filePath.isEmpty) return false;

    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      await _requestPermissions();
      
      final directory = await _getGalleryDirectory();
      final fileName = _generateFileName(fileType);
      final savedFile = File('${directory.path}/$fileName');
      
      await file.copy(savedFile.path);
      
      if (kDebugMode) print('Media saved to gallery: ${savedFile.path}');
      return true;
    } catch (e) {
      if (kDebugMode) print('Save to gallery error: $e');
      return false;
    }
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
    } else if (Platform.isIOS) {
      await Permission.photos.request();
    }
  }

  static Future<Directory> _getGalleryDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/DCIM/NewForceAR');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static bool _isVideo(String fileType) {
    final lowerType = fileType.toLowerCase();
    return lowerType.contains('video') || 
           lowerType.contains('mp4') ||
           lowerType.contains('mov');
  }

  static String _generateFileName(String fileType) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = _isVideo(fileType) ? 'mp4' : 'jpg';
    return 'newforce_ar_$timestamp.$extension';
  }

  static Future<bool> shareWithCustomApps({
    required String filePath,
    required String fileType,
    List<String>? preferredApps,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final mimeType = _isVideo(fileType) ? 'video/*' : 'image/*';
      
      await Share.shareXFiles(
        [XFile(file.path, mimeType: mimeType)],
        text: 'Created with $_appName AR! 🚀',
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) print('Custom share error: $e');
      return false;
    }
  }
}