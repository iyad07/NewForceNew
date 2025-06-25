import '/components/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_widget.dart' show HomeWidget;
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Track if user is in guest mode
  bool isGuest = false;

  // State field(s) for mainColumn widget.
  ScrollController? mainColumn;
  // TextField removed - search bar is now inactive and uses GestureDetector
  // State field(s) for Carousel widget.
  CarouselController? carouselController;
  int carouselCurrentIndex = 0;

  // State field(s) for Row widget.
  ScrollController? rowController1;
  // State field(s) for Row widget.
  ScrollController? rowController2;
  // State field(s) for Row widget.
  ScrollController? rowController3;
  // State field(s) for Row widget.
  ScrollController? rowController4;
  // State field(s) for Row widget.
  ScrollController? rowController5;
  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // Model for sidebar component.
  late SidebarModel sidebarModel;

  @override
  void initState(BuildContext context) {
    mainColumn = ScrollController();
    rowController1 = ScrollController();
    rowController2 = ScrollController();
    rowController3 = ScrollController();
    rowController4 = ScrollController();
    rowController5 = ScrollController();
    listViewController = ScrollController();
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    mainColumn?.dispose();
    // TextController and FocusNode disposal removed - no longer used

    rowController1?.dispose();
    rowController2?.dispose();
    rowController3?.dispose();
    rowController4?.dispose();
    rowController5?.dispose();
    listViewController?.dispose();
    sidebarModel.dispose();
  }
}
