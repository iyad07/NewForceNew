import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A utility function that returns a loading indicator widget.
/// This can be used throughout the app to provide a consistent loading experience.
Widget getLoadingIndicator(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        color: FlutterFlowTheme.of(context).primary,
      ),
    ),
  );
}
