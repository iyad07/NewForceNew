import '/flutter_flow/flutter_flow_util.dart';
import 'new_force_page1_widget.dart' show NewForcePage1Widget;
import 'package:flutter/material.dart';

class NewForcePage1Model extends FlutterFlowModel<NewForcePage1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
