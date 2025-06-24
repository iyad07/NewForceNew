import '/flutter_flow/flutter_flow_util.dart';
import 'community_hub_widget.dart' show CommunityHubWidget;
import 'package:flutter/material.dart';

class CommunityHubModel extends FlutterFlowModel<CommunityHubWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}