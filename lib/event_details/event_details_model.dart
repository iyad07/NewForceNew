import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

class EventDetailsModel extends FlutterFlowModel<EventDetailsWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class EventDetailsWidget extends StatefulWidget {
  const EventDetailsWidget({
    super.key,
    required this.eventTitle,
    required this.eventLocation,
    required this.eventCategory,
    required this.eventDescription,
  });

  final String eventTitle;
  final String eventLocation;
  final String eventCategory;
  final String eventDescription;

  @override
  State<EventDetailsWidget> createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<EventDetailsWidget> {
  late EventDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EventDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder
  }
}