import 'dart:math';

import 'package:syncfusion_flutter_maps/maps.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_page_model.dart';
export 'onboarding_page_model.dart';

class OnboardingPageWidget extends StatefulWidget {
  const OnboardingPageWidget({super.key});

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with TickerProviderStateMixin {
  late OnboardingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  late MapShapeSource _shapeSource;
  List<MapModel> _mapData = [];
  final Offset _offset = Offset.zero;
  double dragPosition = 0;
  late AnimationController _controller;
  late Animation<double> animation;
  bool isLoading = true;
  late MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingPageModel());

    _zoomPanBehavior = MapZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      minZoomLevel: 1.0,
      maxZoomLevel: 15.0,
      // zoomLevel: 1.0,
      // enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        dragPosition = animation.value;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Add a timeout to the map loading
        _mapData = await parseJsonFileToMapModels().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            // Return empty list on timeout
            return [];
          },
        );

        if (mounted) {
          setState(() {
            _shapeSource = MapShapeSource.asset(
              'assets/africaMap.json',
              shapeDataField: 'name',
              dataCount: _mapData.length,
              primaryValueMapper: (int index) => _mapData[index].name,
              dataLabelMapper: (int index) => _mapData[index].abbrev,
            );
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading map data: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 460.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 460.0.ms,
            duration: 620.0.ms,
            begin: 0.09,
            end: 0.765,
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 640.0.ms,
            duration: 3000.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
          ),
          SaturateEffect(
            curve: Curves.easeInOut,
            delay: 4200.0.ms,
            duration: 1270.0.ms,
            begin: 0.0,
            end: 1.63,
          ),
        ],
      ),
      'imageOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 460.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 460.0.ms,
            duration: 620.0.ms,
            begin: 0.09,
            end: 0.765,
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 640.0.ms,
            duration: 3000.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
          ),
          SaturateEffect(
            curve: Curves.easeInOut,
            delay: 4200.0.ms,
            duration: 1270.0.ms,
            begin: 0.0,
            end: 1.63,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double angle = dragPosition / 180 * pi;

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 600.0,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 40.0),
                          child: PageView(
                            controller: _model.pageViewController ??=
                                PageController(initialPage: 0),
                            onPageChanged: (_) => setState(() {}),
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 15.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Discover Africa\'s Opportunities',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                    fontFamily: 'SFPro',
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Explore Africa\'s Wealth \nTap on a country to uncover its rich resources and lucrative investment opportunities. From tech startups to natural resources, see where you can make a difference.',
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SFPro',
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                        lineHeight: 1.5,
                                                      ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 6.0)),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 400.0,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            GestureDetector(
                                              onHorizontalDragUpdate:
                                                  (details) => setState(() {
                                                dragPosition -=
                                                    details.delta.dx;
                                                dragPosition %= 360;
                                              }),
                                              onHorizontalDragEnd: (details) {
                                                double end = dragPosition < 180
                                                    ? 360
                                                    : -720;
                                                animation = Tween<double>(
                                                        begin: dragPosition,
                                                        end: end)
                                                    .animate(_controller);

                                                _controller.forward(from: 0);
                                              },
                                              child: Transform(
                                                transform: Matrix4.identity()
                                                  ..setEntry(3, 2, 0.001)
                                                  ..rotateY(angle),
                                                alignment:
                                                    FractionalOffset.center,
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    height: 400.0,
                                                    child: isLoading
                                                        ? Center(
                                                            child: CircularProgressIndicator(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    50,
                                                                    0,
                                                                    0),
                                                            child: Stack(
                                                                children: [
                                                                  SfMaps(
                                                                    layers: [
                                                                      MapShapeLayer(
                                                                        color: Colors
                                                                            .black,
                                                                        zoomPanBehavior:
                                                                            _zoomPanBehavior,
                                                                        source:
                                                                            _shapeSource,
                                                                        showDataLabels:
                                                                            true,

                                                                        dataLabelSettings: const MapDataLabelSettings(
                                                                            overflowMode:
                                                                                MapLabelOverflow.hide,
                                                                            textStyle: TextStyle(color: Colors.white, fontSize: 10)),

                                                                        strokeColor: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            133,
                                                                            83,
                                                                            37),
                                                                        strokeWidth:
                                                                            2,
                                                                        // onWillZoom:
                                                                        //     (MapZoomDetails
                                                                        //         details) {
                                                                        //   return true;
                                                                        // },

                                                                        // onWillPan:
                                                                        //     (MapPanDetails
                                                                        //         details) {
                                                                        //   return true;
                                                                        // },

                                                                        onSelectionChanged:
                                                                            (int
                                                                                details) {
                                                                          final int
                                                                              index =
                                                                              details;
                                                                          final country =
                                                                              _mapData[index].name;
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: Text(country),
                                                                                content: Text('Population: ${_mapData[index].population}\n'
                                                                                    'GDP: ${_mapData[index].gdp}'),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                    child: const Text('Close'),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ).animateOnPageLoad(
                                                                      animationsMap[
                                                                          'imageOnPageLoadAnimation2']!),
                                                                  //        FloatingActionButton(
                                                                  //   onPressed: () {
                                                                  //     setState(() {
                                                                  //    _zoomPanBehavior.zoomLevel = 1;

                                                                  //     });
                                                                  //   },
                                                                  //   child: Text('out'),
                                                                  // ),
                                                                ])

                                                            //   ),),,
                                                            )),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  _zoomPanBehavior.zoomLevel =
                                                      1;
                                                },
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                icon: const Icon(
                                                    Icons.zoom_out_map))
                                          ],
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              'signInPage',
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 800),
                                ),
                              },
                            );
                          },
                          text: 'Get Started',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 24.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
