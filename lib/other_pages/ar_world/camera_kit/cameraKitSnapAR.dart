// Automatic FlutterFlow imports
import 'dart:convert';
import 'package:camerakit_flutter/camerakit_flutter_platform_interface.dart';
import 'package:camerakit_flutter/invoke_methods.dart';
import 'package:flutter/services.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/camera_model.dart';

// Imports other custom widgets
// Imports custom actions
// Imports custom functions
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CameraKitFlutterImpl {
  final CameraKitFlutterEvents cameraKitFlutterEvents;

  /// Constructor for CameraKitFlutterImpl.
  /// [cameraKitFlutterEvents] is an object that defines event handlers for CameraKit.
  CameraKitFlutterImpl({required this.cameraKitFlutterEvents}) {
    // Obtain the method channel from the CameraKit platform.
    CamerakitFlutterPlatform.instance
        .getMethodChannel()
        .setMethodCallHandler((MethodCall call) async {
      // Handle method calls based on their method name.
      switch (call.method) {
        case InputMethods.cameraKitResults:
          // When 'cameraKitResults' method is called, trigger the corresponding event with the provided arguments.
          cameraKitFlutterEvents.onCameraKitResult(call.arguments);
          break;
        case InputMethods.receivedLenses:
          // When 'receiveLenses' method is called, decode the JSON arguments and map them to Lens objects.
          final List<dynamic> list = json.decode(call.arguments);
          final List<Lens> lensList =
              list.map((item) => Lens.fromJson(item)).toList();
          // Trigger the 'receiveLenses' event with the list of Lens objects.
          cameraKitFlutterEvents.receivedLenses(lensList);
          break;
      }
    });
  }

  /// Asynchronously opens the CameraKit.
  Future<String?> openCameraKit(
      {required List<String> groupIds, bool isHideCloseButton = false}) {
    return CamerakitFlutterPlatform.instance.openCameraKit(
        groupIds: groupIds, isHideCloseButton: isHideCloseButton);
  }

  /// Asynchronously opens the CameraKit with single lens.
  Future<String?> openCameraKitWithSingleLens(
      {required String lensId,
      required String groupId,
      bool isHideCloseButton = false}) {
    return CamerakitFlutterPlatform.instance.openCameraKitWithSingleLens(
        lensId: lensId, groupId: groupId, isHideCloseButton: isHideCloseButton);
  }

  /// Method to set Snap CameraKit credentials (not supported programmatically).
  Future<String?> setCredentials({required String apiToken}) async {
    // Credentials should be set in AndroidManifest.xml or Info.plist
    return 'Credentials should be set in platform-specific configurations';
  }

  /// Asynchronously retrieves group lenses from the CameraKit.
  Future<String?> getGroupLenses({required List<String> groupIds}) {
    return CamerakitFlutterPlatform.instance.getGroupLenses(groupIds: groupIds);
  }
}

/// Abstract class defining event callbacks related to CameraKit.
abstract class CameraKitFlutterEvents {
  /// Callback for when a CameraKit result is received.
  void onCameraKitResult(Map<dynamic, dynamic> result);

  /// Callback for receiving a list of lenses.
  void receivedLenses(List<Lens> lensList);
}