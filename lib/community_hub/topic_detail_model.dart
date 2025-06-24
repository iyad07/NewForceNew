import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'topic_detail_widget.dart' show TopicDetailWidget;
import 'package:flutter/material.dart';

class TopicDetailModel extends FlutterFlowModel<TopicDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for postContent widget.
  FocusNode? postContentFocusNode;
  TextEditingController? postContentTextController;
  String? Function(BuildContext, String?)? postContentTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    postContentFocusNode?.dispose();
    postContentTextController?.dispose();
  }
}