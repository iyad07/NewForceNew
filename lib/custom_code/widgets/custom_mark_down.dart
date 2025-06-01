// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_markdown/flutter_markdown.dart';

class CustomMarkDown extends StatefulWidget {
  const CustomMarkDown({
    super.key,
    this.width,
    this.height,
    required this.inputString,
  });

  final double? width;
  final double? height;
  final String inputString;

  @override
  State<CustomMarkDown> createState() => _CustomMarkDownState();
}

class _CustomMarkDownState extends State<CustomMarkDown> {
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: widget.inputString,
      styleSheet: MarkdownStyleSheet(
        p: FlutterFlowTheme.of(context).bodyMedium.copyWith(
              height: 1.4,
            ),
        h3: FlutterFlowTheme.of(context).titleSmall,
        listBullet: FlutterFlowTheme.of(context).bodyLarge,
      ),
    );
  }
}
