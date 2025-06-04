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
  /// There will be interface that we will implement on [_MyAppState] class in the future,
  /// right now we have no method to show override any function
  late String _filePath = '';
  late String _fileType = '';
  late List<Lens> lensList = [];
  late final _cameraKitFlutterImpl =
      CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  bool isLensListPressed = false;

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterImpl.setCredentials(apiToken: Constants.cameraKitApiToken);
    initCameraKit();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCameraKit() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await _cameraKitFlutterImpl.openCameraKit(
          groupIds: Constants.groupIdList, isHideCloseButton: false);
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  getGroupLenses() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      _cameraKitFlutterImpl.getGroupLenses(groupIds: Constants.groupIdList);
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Camera Kit'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Click the btton below if loading takes too long',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary),
                onPressed: () {
                  initCameraKit();
                },
                child: const Text(" New Force AR world",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
            // isLensListPressed ? const CircularProgressIndicator() : Container()
          ],
        ),
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaResultWidget(
                filePath: _filePath,
                fileType: _fileType,
              )));
    });
  }

  @override
  void receivedLenses(List<Lens> lensList) async {
    isLensListPressed = false;
    setState(() {});
    final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LensListView(lensList: lensList)))
        as Map<String, dynamic>?;
    final lensId = result?['lensId'] as String?;
    final groupId = result?['groupId'] as String?;

    if ((lensId?.isNotEmpty ?? false) && (groupId?.isNotEmpty ?? false)) {
      _cameraKitFlutterImpl.openCameraKitWithSingleLens(
          lensId: lensId!, groupId: groupId!, isHideCloseButton: false);
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
