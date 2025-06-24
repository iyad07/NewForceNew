import '/flutter_flow/flutter_flow_util.dart';
import 'natural_resources_widget.dart' show NaturalResourcesWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class NaturalResourcesModel extends FlutterFlowModel<NaturalResourcesWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;
  PageController? cashCropsPageViewController;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  // Auto-slide timers
  Timer? mineralsAutoSlideTimer;
  Timer? cashCropsAutoSlideTimer;
  
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
      
  int get cashCropsCurrentIndex => cashCropsPageViewController != null &&
          cashCropsPageViewController!.hasClients &&
          cashCropsPageViewController!.page != null
      ? cashCropsPageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    mineralsAutoSlideTimer?.cancel();
    cashCropsAutoSlideTimer?.cancel();
    pageViewController?.dispose();
    cashCropsPageViewController?.dispose();
  }
}