import '/flutter_flow/flutter_flow_util.dart';
import 'investment_opportunities_widget.dart' show InvestmentOpportunitiesWidget;
import 'package:flutter/material.dart';

class InvestmentOpportunitiesModel
    extends FlutterFlowModel<InvestmentOpportunitiesWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}