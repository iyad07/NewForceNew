import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'ar_world_model.dart';
export 'ar_world_model.dart';

class ArWorldWidget extends StatefulWidget {
  const ArWorldWidget({super.key});

  @override
  State<ArWorldWidget> createState() => _ArWorldWidgetState();
}

class _ArWorldWidgetState extends State<ArWorldWidget> {
  late ArWorldModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArWorldModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      ),
    );
  }
}
