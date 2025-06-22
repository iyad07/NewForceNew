import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'investment_page_model.dart';
export 'investment_page_model.dart';

class InvestmentPageWidget extends StatefulWidget {
  const InvestmentPageWidget({super.key});

  @override
  State<InvestmentPageWidget> createState() => _InvestmentPageWidgetState();
}

class _InvestmentPageWidgetState extends State<InvestmentPageWidget>
    with TickerProviderStateMixin {
  late InvestmentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentPageModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
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
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with gradient background
              Container(
                width: double.infinity,
                height: 200.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).accent1,
                    ],
                    stops: const [0.0, 1.0],
                    begin: const AlignmentDirectional(-1.0, -1.0),
                    end: const AlignmentDirectional(1.0, 1.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 40.0, 16.0, 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Explore Africa',
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                              fontFamily: 'SFPro',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 28.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ),
                ),
              ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
                
                // Investment Categories Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Text(
                        'Investment Opportunities',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Explore key sectors and opportunities across Africa',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Business Index Section
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(16.0),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/2151003694.jpg'),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                                FlutterFlowTheme.of(context).primary.withOpacity(0.6),
                              ],
                              stops: const [0.0, 1.0],
                              begin: const AlignmentDirectional(0.0, -1.0),
                              end: const AlignmentDirectional(0, 1.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: const Icon(
                                        Icons.business_center,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Business Index',
                                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                              fontFamily: 'SF Pro Display',
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Discover investment opportunities across African markets',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'SF Pro Display',
                                              color: Colors.white.withOpacity(0.9),
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed('BusinessIndex');
                                  },
                                  text: 'EXPLORE BUSINESSES',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 44.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16.0),
                      
                      // Natural Resources Section with Africa Map
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).tertiary,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Stack(
                          children: [
                            // Africa Map Background
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      FlutterFlowTheme.of(context).tertiary.withOpacity(0.8),
                                      FlutterFlowTheme.of(context).tertiary.withOpacity(0.6),
                                    ],
                                    stops: const [0.0, 1.0],
                                    begin: const AlignmentDirectional(-1.0, -1.0),
                                    end: const AlignmentDirectional(1.0, 1.0),
                                  ),
                                ),
                              ),
                            ),
                            // Africa Silhouette
                            Positioned(
                              right: -20.0,
                              top: 20.0,
                              bottom: 20.0,
                              child: Container(
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Icon(
                                  Icons.public,
                                  color: Colors.white.withOpacity(0.3),
                                  size: 80.0,
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: const Icon(
                                          Icons.landscape,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Natural Resources',
                                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: false,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              'Explore Africa\'s rich mineral and energy resources',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.white.withOpacity(0.9),
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      // Add navigation logic
                                    },
                                    text: 'VIEW RESOURCES',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 44.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: Colors.white,
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'SF Pro Display',
                                        color: FlutterFlowTheme.of(context).tertiary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: false,
                                      ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16.0),
                      
                      // Resource Categories
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Resources',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'SF Pro Display',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildResourceChip('Gold', const Color(0xFFFFD700)),
                                  const SizedBox(width: 12.0),
                                  _buildResourceChip('Oil', const Color(0xFF2E7D32)),
                                  const SizedBox(width: 12.0),
                                  _buildResourceChip('Natural Gas', const Color(0xFF1976D2)),
                                  const SizedBox(width: 12.0),
                                  _buildResourceChip('Cocoa', const Color(0xFF8D6E63)),
                                  const SizedBox(width: 12.0),
                                  _buildResourceChip('Diamonds', const Color(0xFF9C27B0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32.0),
                      
                      // Market Intelligence Section
                      _buildNavigationCard(
                        context,
                        title: 'Market Intelligence',
                        subtitle: 'Access real-time economic data and market insights',
                        buttonText: 'VIEW ANALYTICS',
                        iconData: Icons.analytics,
                        color: FlutterFlowTheme.of(context).accent1,
                      ),
                      
                      const SizedBox(height: 16.0),
                      
                      // Market Metrics Preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Economic Indicators',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'SF Pro Display',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMetricItem(
                                  context,
                                  label: 'GDP Growth',
                                  value: '4.2%',
                                  color: FlutterFlowTheme.of(context).success,
                                ),
                                _buildMetricItem(
                                  context,
                                  label: 'Inflation',
                                  value: '9.5%',
                                  color: FlutterFlowTheme.of(context).warning,
                                ),
                                _buildMetricItem(
                                  context,
                                  label: 'FDI',
                                  value: '\$2.5B',
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ],
                            ),
                          ],
                         ),
                       ),
                       
                       const SizedBox(height: 16.0),
                       
                       // Prominent People in Africa Section
                       Container(
                         width: double.infinity,
                         height: 200.0,
                         decoration: BoxDecoration(
                           color: FlutterFlowTheme.of(context).secondary,
                           borderRadius: BorderRadius.circular(16.0),
                           image: const DecorationImage(
                             fit: BoxFit.cover,
                             image: AssetImage('assets/images/Nana-Bediako.jpg'),
                           ),
                         ),
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(16.0),
                             gradient: LinearGradient(
                               colors: [
                                 FlutterFlowTheme.of(context).secondary.withOpacity(0.8),
                                 FlutterFlowTheme.of(context).secondary.withOpacity(0.6),
                               ],
                               stops: const [0.0, 1.0],
                               begin: const AlignmentDirectional(0.0, -1.0),
                               end: const AlignmentDirectional(0, 1.0),
                             ),
                           ),
                           child: Padding(
                             padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Container(
                                       width: 48.0,
                                       height: 48.0,
                                       decoration: BoxDecoration(
                                         color: Colors.white.withOpacity(0.2),
                                         borderRadius: BorderRadius.circular(12.0),
                                       ),
                                       child: const Icon(
                                         Icons.people_outline,
                                         color: Colors.white,
                                         size: 24.0,
                                       ),
                                     ),
                                     const SizedBox(width: 16.0),
                                     Expanded(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             'Prominent People in Africa',
                                             style: FlutterFlowTheme.of(context).titleLarge.override(
                                               fontFamily: 'SF Pro Display',
                                               color: Colors.white,
                                               letterSpacing: 0.0,
                                               fontWeight: FontWeight.bold,
                                               useGoogleFonts: false,
                                             ),
                                           ),
                                           const SizedBox(height: 4.0),
                                           Text(
                                             'Discover influential leaders and innovators across the continent',
                                             style: FlutterFlowTheme.of(context).bodyMedium.override(
                                               fontFamily: 'SF Pro Display',
                                               color: Colors.white.withOpacity(0.9),
                                               letterSpacing: 0.0,
                                               useGoogleFonts: false,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                                 FFButtonWidget(
                                   onPressed: () {
                                     // Add navigation logic
                                   },
                                   text: 'MEET THE LEADERS',
                                   options: FFButtonOptions(
                                     width: double.infinity,
                                     height: 44.0,
                                     padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                     iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                     color: Colors.white,
                                     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                       fontFamily: 'SF Pro Display',
                                       color: FlutterFlowTheme.of(context).secondary,
                                       letterSpacing: 0.0,
                                       fontWeight: FontWeight.w600,
                                       useGoogleFonts: false,
                                     ),
                                     elevation: 0.0,
                                     borderRadius: BorderRadius.circular(8.0),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                       
                       const SizedBox(height: 16.0),
                       
                       // Featured Personalities Preview
                       Container(
                         width: double.infinity,
                         padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                         decoration: BoxDecoration(
                           color: FlutterFlowTheme.of(context).secondaryBackground,
                           borderRadius: BorderRadius.circular(12.0),
                           border: Border.all(
                             color: FlutterFlowTheme.of(context).alternate,
                             width: 1.0,
                           ),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'Featured Personalities',
                               style: FlutterFlowTheme.of(context).titleMedium.override(
                                 fontFamily: 'SF Pro Display',
                                 color: FlutterFlowTheme.of(context).primaryText,
                                 letterSpacing: 0.0,
                                 fontWeight: FontWeight.w600,
                                 useGoogleFonts: false,
                               ),
                             ),
                             const SizedBox(height: 16.0),
                             Row(
                               children: [
                                 Expanded(
                                   child: _buildPersonalityCard(
                                     context,
                                     name: 'Aliko\nDangote',
                                     title: 'Businessman',
                                     amount: '\$13.5B',
                                     subtitle: 'Manufacturing',
                                     color: FlutterFlowTheme.of(context).primary,
                                   ),
                                 ),
                                 const SizedBox(width: 12.0),
                                 Expanded(
                                   child: _buildPersonalityCard(
                                     context,
                                     name: 'Chimamanda\nAdichie',
                                     title: 'Author',
                                     amount: '',
                                     subtitle: 'Literature',
                                     color: FlutterFlowTheme.of(context).accent1,
                                   ),
                                 ),
                               ],
                             ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPersonalityCard(
                                      context,
                                      name: 'Elon\nMusk',
                                      title: 'Entrepreneur',
                                      amount: '\$240B',
                                      subtitle: 'Technology',
                                      color: FlutterFlowTheme.of(context).tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: _buildPersonalityCard(
                                      context,
                                      name: 'Wangari\nMaathai',
                                      title: 'Activist',
                                      amount: '',
                                      subtitle: 'Environment',
                                      color: FlutterFlowTheme.of(context).success,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                            FFButtonWidget(
                              onPressed: () {
                                // Add navigation to prominent people page
                              },
                              text: 'VIEW ALL PERSONALITIES',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'SF Pro Display',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildInvestmentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    required List<Color> gradientColors,
    required IconData iconData,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 32.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      subtitle,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          FFButtonWidget(
            onPressed: () {
              // Add navigation logic
            },
            text: buttonText,
            options: FFButtonOptions(
              width: double.infinity,
              height: 48.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts: false,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  iconData,
                  color: color,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'SF Pro Display',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 16.0,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          FFButtonWidget(
            onPressed: () {
              // Add navigation logic
            },
            text: buttonText,
            options: FFButtonOptions(
              width: double.infinity,
              height: 44.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: color,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'SF Pro Display',
                color: Colors.white,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts: false,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
            fontFamily: 'SF Pro Display',
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
            useGoogleFonts: false,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: FlutterFlowTheme.of(context).titleMedium.override(
            fontFamily: 'SF Pro Display',
            color: color,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            useGoogleFonts: false,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceChip(String text, Color color) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'SF Pro Display',
              color: FlutterFlowTheme.of(context).primaryText,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityCard(
    BuildContext context, {
    required String name,
    required String title,
    required String amount,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent1.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'SF Pro Display',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'SF Pro Display',
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
          ),
          if (amount.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text(
              amount,
              style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: false,
              ),
            ),
          ],
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'SF Pro Display',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}