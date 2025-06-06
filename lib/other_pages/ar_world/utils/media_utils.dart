class MediaUtils {
  static bool isVideo(String fileType) {
    final lowerType = fileType.toLowerCase();
    return lowerType.contains('video') || 
           lowerType.contains('mp4') ||
           lowerType.contains('mov') ||
           lowerType.contains('avi') ||
           lowerType.contains('mkv');
  }

  static bool isImage(String fileType) {
    final lowerType = fileType.toLowerCase();
    return lowerType.contains('image') || 
           lowerType.contains('jpg') ||
           lowerType.contains('jpeg') ||
           lowerType.contains('png') ||
           lowerType.contains('gif') ||
           lowerType.contains('bmp');
  }

  static String getMediaTitle(String fileType) {
    return isVideo(fileType) ? 'AR Video Preview' : 'AR Photo Preview';
  }

  static String getCreationMessage(String fileType) {
    return isVideo(fileType) ? 'Video Created!' : 'Photo Captured!';
  }

  static String getReadyMessage(String fileType) {
    return isVideo(fileType) 
        ? 'Your AR video is ready to share!'
        : 'Your AR photo looks amazing!';
  }

  static String getDefaultShareMessage(String fileType) {
    return isVideo(fileType)
        ? 'Watch this amazing AR video I made with NewForce AR! 🎬✨'
        : 'Check out this cool AR photo I created with NewForce AR! 📸✨';
  }

  static String getShareSubject(String fileType) {
    return isVideo(fileType) 
        ? 'AR Video from NewForce AR'
        : 'AR Photo from NewForce AR';
  }

  static String getFileExtension(String fileType) {
    if (isVideo(fileType)) {
      return 'mp4';
    } else if (isImage(fileType)) {
      return 'jpg';
    }
    return 'dat';
  }

  static String getMimeType(String fileType) {
    if (isVideo(fileType)) {
      return 'video/*';
    } else if (isImage(fileType)) {
      return 'image/*';
    }
    return 'application/octet-stream';
  }
}