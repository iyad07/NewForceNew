import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_force_new_hope/home_page/home/offline_handler.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/utils/loading_indicator.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  Timer? _realEstateTimer;
  bool _showRealEstateFallback = false;
  bool _realEstateLoadingTimedOut = false;
  Timer? _connectivityTimer;
  bool _isDialogShowing = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _model = createModel(context, () => HomeModel());

    // Check if user is in guest mode from query parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the current URI from the GoRouter state
      final uri = GoRouterState.of(context).uri;
      final isGuest = uri.queryParameters['isGuest'] == 'true';

      setState(() {
        _model.isGuest = isGuest;
      });
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(
      () async {
        context.pushNamed(
          'googleSearch',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
            ),
          },
        );
      },
    );
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 800.0.ms,
            begin: const Offset(0.0, -22.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 150.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 800.0.ms,
            begin: const Offset(-27.0, 0.0),
            end: const Offset(3.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation1': AnimationInfo(
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Colors.black,
            begin: 0.0,
            end: 0.44,
          ),
        ],
      ),
      'buttonOnPageLoadAnimation2': AnimationInfo(
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Colors.black,
            begin: 0.0,
            end: 0.44,
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 210.0.ms,
            duration: 1060.0.ms,
            color: FlutterFlowTheme.of(context).primary,
            angle: 0.035,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShakeEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            hz: 1,
            offset: const Offset(0.0, 0.0),
            rotation: 0.026,
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1550.0.ms,
            color: FlutterFlowTheme.of(context).secondaryText,
            angle: -1.204,
          ),
        ],
      ),
    });
    _startRealEstateTimer();
  }

  Future<void> _initConnectivity() async {
    final connectivity = Connectivity();
    final results = await connectivity.checkConnectivity();
    _updateConnectionStatus(results);

    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus as void Function(
            List<ConnectivityResult> event)?);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final isOnline = !results.contains(ConnectivityResult.none);

    if (!isOnline) {
      _connectivityTimer?.cancel();
      _connectivityTimer = Timer(const Duration(seconds: 2), () {
        if (!_isDialogShowing && mounted) {
          _showOfflineDialog();
        }
      });
    } else if (isOnline && _isDialogShowing) {
      _connectivityTimer?.cancel();
      _hideOfflineDialog();
    }
  }

  void _showOfflineDialog() {
  if (_isDialogShowing || !mounted) return;
  
  _isDialogShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => OfflineDialog(
      onReload: () async {
        // Check connectivity when reload is pressed
        final connectivity = Connectivity();
        final results = await connectivity.checkConnectivity();
        final isOnline = !results.contains(ConnectivityResult.none);
        
        if (isOnline) {
          // Connection restored, close dialog
          _hideOfflineDialog();
        } else {
          // Still offline, show a brief message but keep dialog open
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Still no internet connection. Please check your network.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: FlutterFlowTheme.of(context).error,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    ),
  ).then((_) => _isDialogShowing = false);
}

  void _hideOfflineDialog() {
    if (!_isDialogShowing || !mounted) return;

    _isDialogShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _startRealEstateTimer() {
    _realEstateTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _realEstateLoadingTimedOut = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _realEstateTimer?.cancel();
    _model.dispose();
    _connectivityTimer?.cancel();
    _connectivitySubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: Drawer(
          elevation: 16.0,
          child: WebViewAware(
            child: wrapWithModel(
              model: _model.sidebarModel,
              updateCallback: () => safeSetState(() {}),
              child: const SidebarWidget(),
            ),
          ),
        ),
        body: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(15.0, 20.0, 15.0, 0.0),
            child: SingleChildScrollView(
              controller: _model.mainColumn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.96,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menu icon
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: Icon(
                            FFIcons.kmenu,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                        // Welcome text
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 15.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _model.isGuest
                                      ? 'Welcome, Guest'
                                      : 'Welcome, ${currentUserDisplayName.isEmpty ? 'User' : currentUserDisplayName}',
                                  style:
                                      FlutterFlowTheme.of(context).titleMedium,
                                ),
                                Text(
                                  _model.isGuest
                                      ? 'You are browsing in guest mode'
                                      : 'You are signed in as ${currentUserEmail}',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Profile icon
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              'Settings',
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 0),
                                ),
                              },
                            );
                          },
                          child: currentUserPhoto.isNotEmpty
                              ? Container(
                                  width: 36.0,
                                  height: 36.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: currentUserPhoto,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Icon(
                                      FFIcons.kprofileCircle,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      size: 24.0,
                                    ),
                                    placeholder: (context, url) => Container(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      child: Center(
                                        child: SizedBox(
                                          width: 15.0,
                                          height: 15.0,
                                          child: CircularProgressIndicator(
                                            color: FlutterFlowTheme.of(context).primary,
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Icon(
                                  FFIcons.kprofileCircle,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                        ),
                        if (_model.isGuest)
                          FFButtonWidget(
                            onPressed: () {
                              context.pushNamed('signInPage');
                            },
                            text: 'Sign In',
                            options: FFButtonOptions(
                              height: 36,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 12, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                              elevation: 2,
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                      ],
                    ),
                  ).animateOnPageLoad(
                      animationsMap['containerOnPageLoadAnimation1']!),
                  //const SizedBox(height: 4),
                  GestureDetector(
                    onTap: (){
                      context.pushNamed('googleSearch');
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Search',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Roboto',
                                      fontSize: 8.0,
                                      letterSpacing: 0.0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'SFPro',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  FFIcons.ksearchNormal1,
                                  color:
                                      FlutterFlowTheme.of(context).secondaryText,
                                  size: 23.0,
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Tiro Bangla',
                                    color: FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                  ),
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ],
                      ).animateOnPageLoad(
                          animationsMap['rowOnPageLoadAnimation']!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 0.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            'Editor\'s recommendation',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'SFPro',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 377.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 380.0,
                          child: CarouselSlider(
                            items: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 15.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await _model.mainColumn?.animateTo(
                                      _model
                                          .mainColumn!.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                    width: 349.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -0.99, -1.02),
                                                  child: Text(
                                                    'The Next Big Opportunity: Investing in African Markets',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          fontFamily:
                                                              'Tiro Bangla',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/images/2151003694.jpg',
                                              width: double.infinity,
                                              height: 224.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.97),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 8.0, 8.0, 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 96.91,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      offset: const Offset(
                                                        0.0,
                                                        6.14,
                                                      ),
                                                      spreadRadius: 0.0,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12.0),
                                                    bottomRight:
                                                        Radius.circular(12.0),
                                                    topLeft:
                                                        Radius.circular(12.0),
                                                    topRight:
                                                        Radius.circular(12.0),
                                                  ),
                                                ),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await _model.mainColumn
                                                        ?.animateTo(
                                                      _model
                                                          .mainColumn!
                                                          .position
                                                          .maxScrollExtent,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                                  text: 'Explore Now',
                                                  options: FFButtonOptions(
                                                    width: 350.0,
                                                    height: 45.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'SFPro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts: false,
                                                        ),
                                                    elevation: 2.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ).animateOnPageLoad(animationsMap[
                                                    'buttonOnPageLoadAnimation1']!),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 15.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await _model.mainColumn?.animateTo(
                                      _model
                                          .mainColumn!.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                    width: 349.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -0.99, -1.02),
                                                  child: Text(
                                                    'Get to know more about the New Force:\nThe newest new school political movement in Africa',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          fontFamily:
                                                              'Tiro Bangla',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/images/ForceGIFanimation-unscreen.gif',
                                              width: double.infinity,
                                              height: 224.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.97),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 8.0, 8.0, 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 96.91,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      offset: const Offset(
                                                        0.0,
                                                        6.14,
                                                      ),
                                                      spreadRadius: 0.0,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12.0),
                                                    bottomRight:
                                                        Radius.circular(12.0),
                                                    topLeft:
                                                        Radius.circular(12.0),
                                                    topRight:
                                                        Radius.circular(12.0),
                                                  ),
                                                ),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    context.pushNamed(
                                                      'newForcePage1',
                                                      extra: <String, dynamic>{
                                                        kTransitionInfoKey:
                                                            const TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType:
                                                              PageTransitionType
                                                                  .fade,
                                                        ),
                                                      },
                                                    );
                                                  },
                                                  text: 'Explore Now',
                                                  options: FFButtonOptions(
                                                    width: 350.0,
                                                    height: 45.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'SFPro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts: false,
                                                        ),
                                                    elevation: 2.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ).animateOnPageLoad(animationsMap[
                                                    'buttonOnPageLoadAnimation2']!),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            carouselController: CarouselSliderController(),
                            options: CarouselOptions(
                              initialPage: 0,
                              viewportFraction: 0.83,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.5,
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.horizontal,
                              autoPlay: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayInterval:
                                  const Duration(milliseconds: (800 + 4000)),
                              autoPlayCurve: Curves.linear,
                              pauseAutoPlayInFiniteScroll: true,
                              onPageChanged: (index, _) =>
                                  _model.carouselCurrentIndex = index,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Divider(
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),*/

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Top Reads',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'SFPro',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<TopReadArticlesRow>>(
                    future: TopReadArticlesTable().queryRows(
                      queryFn: (q) => q.order('created_at'),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).primary,
                                )));
                      }
                      List<TopReadArticlesRow> rowTopReadArticlesRowList =
                          snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _model.rowController3,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(
                              rowTopReadArticlesRowList.length, (rowIndex) {
                            final rowTopReadArticlesRow =
                                rowTopReadArticlesRowList[rowIndex];
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 16.0, 8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    'topReadArticlesDetails',
                                    queryParameters: {
                                      'publisher': serializeParam(
                                        rowTopReadArticlesRow.publisher,
                                        ParamType.String,
                                      ),
                                      'datepublished': serializeParam(
                                        rowTopReadArticlesRow.createdAt,
                                        ParamType.DateTime,
                                      ),
                                      'publisherPic': serializeParam(
                                        rowTopReadArticlesRow.publisherImageUrl,
                                        ParamType.String,
                                      ),
                                      'articleImage': serializeParam(
                                        rowTopReadArticlesRow.image,
                                        ParamType.String,
                                      ),
                                      'description': serializeParam(
                                        valueOrDefault<String>(
                                          rowTopReadArticlesRow.description,
                                          '0',
                                        ),
                                        ParamType.String,
                                      ),
                                      'tag': serializeParam(
                                        rowTopReadArticlesRow.tag,
                                        ParamType.String,
                                      ),
                                      'newsBody': serializeParam(
                                        rowTopReadArticlesRow.newsDescription,
                                        ParamType.String,
                                      ),
                                      'title': serializeParam(
                                        rowTopReadArticlesRow.title,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                      ),
                                    },
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5.0, 5.0, 5.0, 5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 8.0, 8.0, 8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: CachedNetworkImage(
                                                imageUrl: rowTopReadArticlesRow
                                                    .image!,
                                                width: 122.0,
                                                height: 117.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 8.0, 8.0, 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 8.0, 4.0, 8.0),
                                                    child: AutoSizeText(
                                                      valueOrDefault<String>(
                                                        rowTopReadArticlesRow
                                                            .title,
                                                        '0',
                                                      ),
                                                      maxLines: 4,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Tiro Bangla',
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      rowTopReadArticlesRow
                                                          .publisher,
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'SFPro',
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(
                                                    height: 12.0)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).divide(const SizedBox(width: 8.0)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Feed your Curiosity',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'SFPro',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontSize: 22.0,
                                    useGoogleFonts: false,
                                  ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation1']!),
                      ],
                    ),
                  ),
                  FutureBuilder<List<FeedyourcuriosityRow>>(
                    future: FeedyourcuriosityTable().queryRows(
                      queryFn: (q) => q,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).primary,
                                )));
                      }
                      List<FeedyourcuriosityRow> rowFeedyourcuriosityRowList =
                          snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _model.rowController4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              rowFeedyourcuriosityRowList.length, (rowIndex) {
                            final rowFeedyourcuriosityRow =
                                rowFeedyourcuriosityRowList[rowIndex];
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 12.0, 8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    'feedyourCuriosityTopics',
                                    queryParameters: {
                                      'tag': serializeParam(
                                        rowFeedyourcuriosityRow.title,
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 200),
                                      ),
                                    },
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  child: Container(
                                    width: 150.0,
                                    height: 209.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                rowFeedyourcuriosityRow.image!,
                                            width: double.infinity,
                                            height: 151.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5.0, 8.0, 0.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                rowFeedyourcuriosityRow.title,
                                                '0',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineSmall
                                                  .override(
                                                    fontFamily: 'Tiro Bangla',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: Text(
                                                  'Read Topics',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'SFPro',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.navigate_next,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 18.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 5.0)),
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation2']!),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  /*Divider(
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),*/
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            ' Africa has Real Estate\nInvestment Opportunities',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Tiro Bangla',
                                  fontSize: 27.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: 550.0,
                          child: Builder(
                            builder: (context) {
                              final appState = FFAppState();
                              final hasData =
                                  appState.foregroundImages.isNotEmpty ||
                                      appState.backgroundImages.isNotEmpty ||
                                      appState.texts.isNotEmpty;

                              if (!hasData) {
                                // Show loading widget when no data is available
                                return Container(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  height: 550.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Building icon with subtle animation
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.apartment,
                                          size: 50.0,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(height: 24.0),

                                      // Loading spinner
                                      SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: CircularProgressIndicator(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                      const SizedBox(height: 24.0),

                                      // Main loading text
                                      Text(
                                        'Loading Real Estate Opportunities',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: 'SFPro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                      const SizedBox(height: 12.0),

                                      // Descriptive text
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0),
                                        child: Text(
                                          'Discovering premium investment properties and development projects across African markets',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'SFPro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                //height: 1.4,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 24.0),

                                      // Status text
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          'Fetching latest investment data...',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'SFPro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Show the actual ParallaxCards when data is available
                              return custom_widgets.ParallaxCards(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                height: 550.0,
                                foregroundImages: appState.foregroundImages,
                                backgroundImages: appState.backgroundImages,
                                texts: appState.texts,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Divider(
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GradientText(
                          'Chat with our AI Assistant',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Tiro Bangla',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            const Color(0xC0684624)
                          ],
                          gradientDirection: GradientDirection.ttb,
                          gradientType: GradientType.linear,
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation2']!),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 5.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed('aiScreen');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Can you tell me about the top players in Afrobeats today?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SFPro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                                Icon(
                                  FFIcons.karrowRight3,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 5.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed('aiScreen');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Can you explain how blockchain is being used in African finance?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SFPro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                                Icon(
                                  FFIcons.karrowRight3,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),*/
                  
                 /* 
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 16.0),
                          child: Text(
                            'Explore and Invest in companies across the African Continent',
                            textAlign: TextAlign.left,
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'SFPro',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 40.0),
                          child: FutureBuilder<List<CountryProfilesRow>>(
                            future: CountryProfilesTable().queryRows(
                              queryFn: (q) => q,
                            ),
                            builder: (context, snapshot) {
                              // Show loading indicator while data is being fetched
                              if (!snapshot.hasData) {
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              List<CountryProfilesRow>
                                  listViewCountryProfilesRowList =
                                  snapshot.data!;

                              // If no data, hide the section completely instead of showing fallback image
                              if (listViewCountryProfilesRowList.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewCountryProfilesRowList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewCountryProfilesRow =
                                      listViewCountryProfilesRowList[
                                          listViewIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        'countryProfile',
                                        queryParameters: {
                                          'countrydetails': serializeParam(
                                            listViewCountryProfilesRow,
                                            ParamType.SupabaseRow,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey:
                                              const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration:
                                                Duration(milliseconds: 600),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 100.0,
                                      height: 62.0,
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(6.0, 0.0, 18.0, 0.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: listViewCountryProfilesRow
                                                          .flagImageUrl
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          listViewCountryProfilesRow
                                                              .flagImageUrl!,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.flag,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 25,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.flag,
                                                        color: Colors.grey[600],
                                                        size: 25,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              listViewCountryProfilesRow
                                                  .country,
                                              'Unknown Country',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Tiro Bangla',
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                controller: _model.listViewController,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),*/
                ].divide(const SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
