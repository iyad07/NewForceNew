import '/flutter_flow/flutter_flow_util.dart';
import 'country_profile_widget.dart' show CountryProfileWidget;
import 'package:flutter/material.dart';

class CountryProfileModel extends FlutterFlowModel<CountryProfileWidget> {
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;

  @override
  void initState(BuildContext context) {
    _isInitialized = false;
  }

  void markAsInitialized() {
    _isInitialized = true;
  }

  @override
  void dispose() {
    // Clean up any resources if needed
  }
}