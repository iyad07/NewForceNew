import '/components/donate_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'donation_widget.dart' show DonationWidget;
import 'package:flutter/material.dart';

class DonationModel extends FlutterFlowModel<DonationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for donateCard component.
  late DonateCardModel donateCardModel;

  @override
  void initState(BuildContext context) {
    donateCardModel = createModel(context, () => DonateCardModel());
  }

  @override
  void dispose() {
    donateCardModel.dispose();
  }
}
