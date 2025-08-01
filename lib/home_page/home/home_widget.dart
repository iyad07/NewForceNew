import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_force_new_hope/flutter_flow/flutter_flow_pdf_viewer.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_youtube_player.dart';
import '/flutter_flow/utils/loading_indicator.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/home_page/home_article_details/home_article_details_widget.dart';
import '/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
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


  @override
  void initState() {
    super.initState();

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

    // Search functionality moved to GestureDetector in UI
    // TextController and FocusNode no longer needed for inactive search bar
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
                        const Spacer(),
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
                            child: GestureDetector(
                              onTap: () {
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
                              child: Container(
                                height: 56.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Icon(
                                        FFIcons.ksearchNormal1,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 23.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Search',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'SFPro',
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                                       Alignment.center,
                                                  child: Text(
                                                    'Speak to the New Force AI',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          fontFamily:
                                                              'Tiro Bangla',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 24.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      'aiScreen',
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
                                                  text: 'Speak Now',
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

                  // New Force Section
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 12.0, 0.0, 0.0),
                    child: Text(
                      'Popular Write Ups',
                      style: FlutterFlowTheme.of(context)
                          .labelLarge
                          .override(
                            fontFamily: 'SFPro',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 160.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primaryBackground,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 4.0, 0.0, 5.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional
                                  .fromSTEB(16.0, 8.0, 0.0, 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeArticleDetailsWidget(
                                        title: 'The New Force Movement pledges to change the country\'s fortunes with Save Ghana Fund',
                                        articleImage: 'assets/images/WhatsApp-Image-2024-05-06-at-17.57.29-768x552.jpeg',
                                        description: 'The New Force Movement has announced a comprehensive plan to transform Ghana\'s economic landscape through the establishment of the Save Ghana Fund.',
                                        content: 'The New Force Movement has unveiled an ambitious initiative to revitalize Ghana\'s economy through the creation of the Save Ghana Fund. This comprehensive economic recovery plan aims to address the country\'s financial challenges while promoting sustainable development and growth.\n\nThe Save Ghana Fund represents a strategic approach to economic transformation, focusing on key sectors that will drive long-term prosperity. The movement believes that through careful planning and implementation, Ghana can overcome its current economic difficulties and emerge as a stronger, more resilient nation.\n\nKey components of the Save Ghana Fund include investments in infrastructure, education, healthcare, and technology. The fund will also support small and medium enterprises, which are crucial for job creation and economic diversification.\n\nThe New Force Movement emphasizes that this initiative is not just about immediate relief but about building a foundation for sustained economic growth that will benefit all Ghanaians.',
                                        author: 'New Force Movement',
                                        publishDate: DateTime(2024, 5, 6),
                                        category: 'Economic Policy',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 320.0,
                                  height: 160.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x430F1113),
                                        offset: Offset(
                                          0.0,
                                          1.0,
                                        ),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: 'locationImage',
                                        transitionOnUserGestures:
                                            true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  8.0),
                                          child: Image.asset(
                                            'assets/images/WhatsApp-Image-2024-05-06-at-17.57.29-768x552.jpeg',
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'The New Force Movement pledges to change the country\'s fortunes with Save Ghana Fund',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelSmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              'May 6, 2024',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize:
                                            MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          /*Padding(
                                            padding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(4.0,
                                                    4.0, 0.0, 0.0),
                                            child: Text(
                                              'View Now',
                                              style:
                                                  FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'SFPro',
                                                        letterSpacing:
                                                            0.0,
                                                        useGoogleFonts:
                                                            false,
                                                      ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.navigate_next,
                                            color: Colors.black,
                                            size: 24.0,
                                          ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                            Padding(
                              padding: const EdgeInsetsDirectional
                                  .fromSTEB(8.0, 8.0, 0.0, 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeArticleDetailsWidget(
                                        title: 'New Africa Foundation Convention cancelled after tension at Independence Square',
                                        articleImage: 'assets/images/GDRkcASX0AAU8ws.jpeg',
                                        description: 'The highly anticipated New Africa Foundation Convention has been cancelled following unexpected tensions that arose at Independence Square.',
                                        content: 'The New Africa Foundation Convention, which was scheduled to be a landmark event bringing together leaders, activists, and citizens from across the continent, has been cancelled due to rising tensions at Independence Square.\n\nThe convention was intended to address critical issues facing Africa, including economic development, governance, and social justice. However, organizers made the difficult decision to cancel the event after security concerns arose from demonstrations at the venue.\n\nIndependence Square, a historically significant location for political gatherings in Ghana, became the center of controversy as various groups expressed conflicting views about the convention\'s agenda and participants.\n\nThe New Africa Foundation expressed disappointment at the cancellation but emphasized that the safety of all participants was their primary concern. They have indicated that they are exploring alternative venues and dates for the convention.\n\nThis incident highlights the complex political landscape in Ghana and the challenges faced when organizing large-scale political and social events.',
                                        author: 'New Africa Foundation',
                                        publishDate: DateTime(2023, 12, 15),
                                        category: 'Political Events',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 320.0,
                                  height: 160.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x430F1113),
                                        offset: Offset(
                                          0.0,
                                          1.0,
                                        ),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                                8.0),
                                        child: Image.asset(
                                          'assets/images/GDRkcASX0AAU8ws.jpeg',
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'New Africa Foundation Convention cancelled after tension at Independence Square',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelSmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              'Dec 15, 2023',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize:
                                            MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          /*Padding(
                                            padding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(4.0,
                                                    4.0, 0.0, 0.0),
                                            child: Text(
                                              'View Now',
                                              style:
                                                  FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'SFPro',
                                                        letterSpacing:
                                                            0.0,
                                                        useGoogleFonts:
                                                            false,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(0.0,
                                                    4.0, 0.0, 0.0),
                                            child: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                            Padding(
                              padding: const EdgeInsetsDirectional
                                  .fromSTEB(8.0, 8.0, 16.0, 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeArticleDetailsWidget(
                                        title: 'Launch of 12 pillars for economic freedom by the New Force: Quotable quotes',
                                        articleImage: 'assets/images/cheddar.jpg',
                                        description: 'The New Force has officially launched their comprehensive 12 pillars for economic freedom, outlining a transformative vision for Ghana\'s economic future.',
                                        content: 'The New Force has unveiled their ambitious 12 pillars for economic freedom, a comprehensive framework designed to transform Ghana\'s economic landscape and create sustainable prosperity for all citizens.\n\nThese 12 pillars represent a holistic approach to economic development, addressing key areas such as fiscal responsibility, monetary policy, trade liberalization, and institutional reforms. Each pillar is carefully designed to work in synergy with the others, creating a robust foundation for long-term economic growth.\n\nKey highlights from the launch include:\n\n1. Fiscal Discipline and Debt Management\n2. Monetary Policy Reform\n3. Trade and Investment Liberalization\n4. Infrastructure Development\n5. Education and Skills Development\n6. Healthcare System Strengthening\n7. Agricultural Modernization\n8. Digital Economy Advancement\n9. Financial Sector Development\n10. Environmental Sustainability\n11. Governance and Institutional Reforms\n12. Social Protection and Inclusion\n\nThe New Force leadership emphasized that these pillars are not just theoretical concepts but practical solutions that can be implemented to address Ghana\'s current economic challenges while building a foundation for future prosperity.\n\nThe launch event featured notable quotes from key leaders, highlighting their commitment to economic transformation and their vision for a prosperous Ghana.',
                                        author: 'New Force Leadership',
                                        publishDate: DateTime(2024, 3, 20),
                                        category: 'Economic Policy',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 320.0,
                                  height: 160.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x430F1113),
                                        offset: Offset(
                                          0.0,
                                          1.0,
                                        ),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                                8.0),
                                        child: Image.asset(
                                          'assets/images/cheddar.jpg',
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Launch of 12 pillars for economic freedom by the New Force: Quotable quotes',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelSmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 20.0),
                                            Text(
                                              'Mar 20, 2024',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'SFPro',
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize:
                                            MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          /*Padding(
                                            padding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(4.0,
                                                    4.0, 0.0, 0.0),
                                            child: Text(
                                              'View Now',
                                              style:
                                                  FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'SFPro',
                                                        letterSpacing:
                                                            0.0,
                                                        useGoogleFonts:
                                                            false,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(0.0,
                                                    4.0, 0.0, 0.0),
                                            child: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Upcoming Section
                  /*Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 0.0, 12.0),
                    child: Text(
                      'Upcoming',
                      style: FlutterFlowTheme.of(context)
                          .labelLarge
                          .override(
                            fontFamily: 'SFPro',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 12.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 7.0,
                            color: Color(0x2F1D2429),
                            offset: Offset(
                              0.0,
                              3.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/Nana-Bediako.jpg',
                                width: double.infinity,
                                height: 160.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional
                                  .fromSTEB(0.0, 8.0, 0.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Launch of 12 pillars for economic freedom by the New Force:',
                                      style: FlutterFlowTheme.of(
                                              context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                'Tiro Bangla',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    'The first ever virtual policy launch by the New Force "12 Pillars of Economic Freedom". ',
                                    style: FlutterFlowTheme.of(
                                            context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'SFPro',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 12.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 7.0,
                            color: Color(0x2F1D2429),
                            offset: Offset(
                              0.0,
                              3.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/Snapinsta.app_432432358_1210962189985096_244151756642435234_n_1080.jpg',
                                width: double.infinity,
                                height: 160.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional
                                  .fromSTEB(0.0, 8.0, 0.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '16 Regional Listening Tour',
                                      style: FlutterFlowTheme.of(
                                              context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                'Tiro Bangla',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Text(
                                    'The 16 regional listening tour focuses on addressing unemployment by promoting regional industrialization and job creation. Bediako\'s plan to listen to people\'s problems will help in crafting a national manifesto which is based on the people\'s problems.',
                                    style: FlutterFlowTheme.of(
                                            context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'SFPro',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/

                  // Polici
                  // Videos Section
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 12.0, 0.0, 12.0),
                    child: Text(
                      'Videos',
                      style: FlutterFlowTheme.of(context)
                          .labelLarge
                          .override(
                            fontFamily: 'SFPro',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 10.0, 10.0, 25.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 300.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const FlutterFlowYoutubePlayer(
                                url:
                                    'https://www.youtube.com/watch?v=EO_R4JWU4ZQ',
                                autoPlay: false,
                                looping: true,
                                mute: false,
                                showControls: true,
                                showFullScreen: true,
                                strictRelatedVideos: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 300.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const FlutterFlowYoutubePlayer(
                                url:
                                    'https://www.youtube.com/watch?v=B8JzCo4gcP0',
                                autoPlay: false,
                                looping: true,
                                mute: false,
                                showControls: true,
                                showFullScreen: true,
                                strictRelatedVideos: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 300.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const FlutterFlowYoutubePlayer(
                                url:
                                    'https://www.youtube.com/watch?v=vPwwSyv7gbk',
                                autoPlay: false,
                                looping: true,
                                mute: false,
                                showControls: true,
                                showFullScreen: true,
                                strictRelatedVideos: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 0.0, 10.0, 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const FlutterFlowYoutubePlayer(
                                url:
                                    'https://www.youtube.com/watch?v=QwUcFVR9uIY',
                                autoPlay: false,
                                looping: true,
                                mute: false,
                                showControls: true,
                                showFullScreen: true,
                                strictRelatedVideos: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 0.0, 10.0, 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const FlutterFlowYoutubePlayer(
                                url:
                                    'https://www.youtube.com/watch?v=aD4W6KSuuD0',
                                autoPlay: false,
                                looping: true,
                                mute: false,
                                showControls: true,
                                showFullScreen: true,
                                strictRelatedVideos: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
/*
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
                  ),*/
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
                      
                      // Provide fallback data if table is empty
                      if (rowFeedyourcuriosityRowList.isEmpty) {
                        rowFeedyourcuriosityRowList = [
                          FeedyourcuriosityRow({
                            'id': 1,
                            'created_at': DateTime.now().toIso8601String(),
                            'title': 'African Culture & Lifestyle',
                            'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500&h=300&fit=crop',
                          }),
                          FeedyourcuriosityRow({
                            'id': 2,
                            'created_at': DateTime.now().toIso8601String(),
                            'title': 'African Agriculture',
                            'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500&h=300&fit=crop',
                          }),
                          FeedyourcuriosityRow({
                            'id': 3,
                            'created_at': DateTime.now().toIso8601String(),
                            'title': 'African Technology',
                            'image': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=500&h=300&fit=crop',
                          }),
                        ];
                      }

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
                            'Investment Opportunities',
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
                                onCardTap: (index) {
                                  // Navigate to investment tab in bottom navigation
                                  final navBarState = context.findAncestorStateOfType<NavBarPageState>();
                                  if (navBarState != null) {
                                    navBarState.navigateToTab('investmentPage');
                                  }
                                },
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
                              queryFn: (q) => q.order('country', ascending: true).limit(100),
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
