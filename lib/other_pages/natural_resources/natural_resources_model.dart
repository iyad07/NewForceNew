import '/flutter_flow/flutter_flow_util.dart';
import 'natural_resources_widget.dart' show NaturalResourcesWidget;
import 'package:flutter/material.dart';

class NaturalResourcesModel extends FlutterFlowModel<NaturalResourcesWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;
  // State field(s) for TabBar widget.
  TabController? tabBarController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}