import '/flutter_flow/flutter_flow_util.dart';
import 'google_search_widget.dart' show GoogleSearchWidget;
import 'package:flutter/material.dart';

class GoogleSearchModel extends FlutterFlowModel<GoogleSearchWidget> {
  /// State fields for stateful widgets in this page.

  // State field(s) for search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}