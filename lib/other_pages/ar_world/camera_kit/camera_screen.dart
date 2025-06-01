import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_force_new_hope/flutter_flow/flutter_flow_theme.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/cameraKitSnapAR.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/camera_model.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/lensList.dart';
import 'package:new_force_new_hope/other_pages/ar_world/camera_kit/mediaresult.dart';

class MyTest extends StatefulWidget {
  const MyTest({super.key});

  @override
  State<MyTest> createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> implements CameraKitFlutterEvents {
  late String _filePath = '';
  late String _fileType = '';
  late List<Lens> lensList = [];
  late final _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  bool isLensListPressed = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCameraKit();
  }

  Future<void> _initCameraKit() async {
    try {
      // Check credentials setup (optional, as it's handled in platform configs)
      final result = await _cameraKitFlutterImpl.setCredentials(apiToken: Constants.cameraKitApiToken);
      if (result != null && result.contains('Error')) {
        setState(() {
          _errorMessage = result;
        });
        return;
      }
      await _cameraKitFlutterImpl.openCameraKit(
        groupIds: Constants.groupIdList,
        isHideCloseButton: false,
      );
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = 'Failed to open CameraKit: ${e.message}';
      });
      if (kDebugMode) {
        print(_errorMessage);
      }
    }
  }

  Future<void> _getGroupLenses() async {
    setState(() {
      isLensListPressed = true;
    });
    try {
      await _cameraKitFlutterImpl.getGroupLenses(groupIds: Constants.groupIdList);
    } on PlatformException catch (e) {
      setState(() {
        isLensListPressed = false;
        _errorMessage = 'Failed to get lenses: ${e.message}';
      });
      if (kDebugMode) {
        print(_errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (isLensListPressed)
              CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text(
              'Click the button below if loading takes too long',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                ),
                onPressed: _initCameraKit,
                child: const Text(
                  'New Force AR World',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
                onPressed: _getGroupLenses,
                child: const Text(
                  'View Lenses',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result['path'] as String;
      _fileType = result['type'] as String;

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MediaResultWidget(
          filePath: _filePath,
          fileType: _fileType,
        ),
      ));
    });
  }

  @override
  void receivedLenses(List<Lens> lensList) async {
    setState(() {
      isLensListPressed = false;
      this.lensList = lensList;
    });
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LensListView(lensList: lensList),
      ),
    ) as Map<String, dynamic>?;
    final lensId = result?['lensId'] as String?;
    final groupId = result?['groupId'] as String?;

    if ((lensId?.isNotEmpty ?? false) && (groupId?.isNotEmpty ?? false)) {
      _cameraKitFlutterImpl.openCameraKitWithSingleLens(
        lensId: lensId!,
        groupId: groupId!,
        isHideCloseButton: false,
      );
    }
  }
}

class Constants {
  /// List of group IDs for Camera Kit
  static const List<String> groupIdList = [
    '2a75b645-21f9-4750-8333-c72836b7a992'
  ]; // TODO: Fill group IDs here

  /// The API token for Camera Kit in the staging environment
  static const cameraKitApiToken =
      'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzIwNjYzMDc0LCJzdWIiOiJlN2RlZjgwNi04YzlmLTQxN2MtODlhYi0wNWFjYmM0NjAzZmJ-U1RBR0lOR342ZDJiZmNkYy1mYjkxLTRiYzktOWRhYi03YjA5Zjg5ODI1NTQifQ.N9gLbjfvHefJ1DglPfmkg6cVnA8wmDVjLlwh4qj3u7A'; // TODO fill api token staging or production here
}