import 'package:flutter/material.dart';
import 'package:new_force_new_hope/flutter_flow/flutter_flow_theme.dart';

class OfflineDialog extends StatelessWidget {
  final VoidCallback? onReload;
  
  const OfflineDialog({super.key, this.onReload});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: FlutterFlowTheme.of(context).error,
          ),
          const SizedBox(height: 12),
          Text(
            'No Internet Connection',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'SFPro',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
        ],
      ),
      content: Text(
        'Please check your internet connection and try again.',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'SFPro',
          fontSize: 14,
          useGoogleFonts: false,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onReload,
          child: Text(
            'Reload',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}