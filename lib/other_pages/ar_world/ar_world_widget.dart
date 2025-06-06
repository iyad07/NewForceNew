import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'ar_world_model.dart';
export 'ar_world_model.dart';

class ArWorldWidget extends StatefulWidget {
  const ArWorldWidget({super.key});

  @override
  State<ArWorldWidget> createState() => _ArWorldWidgetState();
}

class _ArWorldWidgetState extends State<ArWorldWidget> {
  late ArWorldModel _model;
  bool _hasInitialized = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArWorldModel());
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_hasInitialized) return;
    _hasInitialized = true;

    if (kDebugMode) {
      print('🎥 Initializing camera...');
    }

    // Add a small delay to ensure widget is fully built
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      // The camera initialization happens in the model's initState
      // We just need to wait and show loading
      if (kDebugMode) {
        print('📷 Camera initialization started in model');
      }
    }
  }

  void _retryCamera() {
    if (kDebugMode) {
      print('🔄 Retrying camera initialization');
    }
    
    setState(() {
      _hasInitialized = false;
    });
    _initializeCamera();
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('🗑️ ArWorldWidget disposing...');
    }
    _model.dispose();
    super.dispose();
  }

  @override
 @override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) {
      if (!didPop) {
        context.pushReplacementNamed('Home');
      }
    },
    child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCameraIcon(),
              const SizedBox(height: 24),
              _buildStatusText(),
              const SizedBox(height: 16),
              _buildLoadingIndicator(),
              if (_model.errorMessage != null) _buildErrorSection(),
              //_buildRetryButton(),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildCameraIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(
        Icons.camera_alt,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStatusText() {
    String statusText = 'Opening Camera...';
    
    if (_model.errorMessage != null) {
      statusText = 'Camera Error';
    } else if (_hasInitialized) {
      statusText = 'Camera Ready';
    }
    
    return Text(
      statusText,
      style: FlutterFlowTheme.of(context).headlineSmall.override(
        fontFamily: 'Inter',
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (_model.errorMessage != null) {
      return const SizedBox.shrink();
    }
    
    return CircularProgressIndicator(
      color: FlutterFlowTheme.of(context).primary,
    );
  }

  Widget _buildErrorSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Text(
          _model.errorMessage!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: _retryCamera,
          child: const Text(
            "New Force AR world",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}