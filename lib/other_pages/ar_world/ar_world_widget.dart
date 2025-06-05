import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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

class _ArWorldWidgetState extends State<ArWorldWidget> with WidgetsBindingObserver {
  late ArWorldModel _model;
  bool _hasOpenedCamera = false;
  bool _cameraIsOpen = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => ArWorldModel());
    _openCameraDirectly();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed && _cameraIsOpen) {
      if (kDebugMode) {
        print('App resumed after camera, navigating to Home');
      }
      _navigateToHome();
    }
  }

  Future<void> _openCameraDirectly() async {
    if (_hasOpenedCamera) return;
    _hasOpenedCamera = true;

    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      _cameraIsOpen = true;
      await _model.openCameraKit();
      
      if (mounted && _model.errorMessage == null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _navigateToHome();
        });
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'Home',
      (route) => false,
    );
  }

  void _retryCamera() {
    setState(() {
      _hasOpenedCamera = false;
    });
    _openCameraDirectly();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCameraIcon(),
            const SizedBox(height: 24),
            _buildStatusText(),
            const SizedBox(height: 16),
            _buildLoadingIndicator(),
            if (_model.errorMessage != null) _buildErrorSection(),
          ],
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
    return Text(
      'Opening Camera...',
      style: FlutterFlowTheme.of(context).headlineSmall.override(
        fontFamily: 'Inter',
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.white,
      ),
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
        child: Column(
          children: [
            Text(
              _model.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _buildErrorActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          'Retry',
          FlutterFlowTheme.of(context).primary,
          _retryCamera,
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          'Go to Homepage',
          Colors.grey[700]!,
          _navigateToHome,
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}