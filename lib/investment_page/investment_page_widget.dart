import 'package:flutter/material.dart';
import '../backend/supabase/supabase.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../other_pages/countries_list/countries_list_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'investment_page_model.dart';
export 'investment_page_model.dart';

// Custom painter for miniature graph
class MiniGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    final redPaint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    final greenPaint = Paint()
      ..color = const Color(0xFF4ECDC4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    // Create zigzag line pattern similar to the image
    final path1 = Path();
    final path2 = Path();
    final path3 = Path();
    
    // Blue line (top)
    path1.moveTo(0, size.height * 0.3);
    path1.lineTo(size.width * 0.2, size.height * 0.2);
    path1.lineTo(size.width * 0.4, size.height * 0.4);
    path1.lineTo(size.width * 0.6, size.height * 0.1);
    path1.lineTo(size.width * 0.8, size.height * 0.3);
    path1.lineTo(size.width, size.height * 0.2);
    
    // Red line (middle)
    path2.moveTo(0, size.height * 0.6);
    path2.lineTo(size.width * 0.2, size.height * 0.5);
    path2.lineTo(size.width * 0.4, size.height * 0.7);
    path2.lineTo(size.width * 0.6, size.height * 0.4);
    path2.lineTo(size.width * 0.8, size.height * 0.6);
    path2.lineTo(size.width, size.height * 0.5);
    
    // Green line (bottom)
    path3.moveTo(0, size.height * 0.8);
    path3.lineTo(size.width * 0.2, size.height * 0.9);
    path3.lineTo(size.width * 0.4, size.height * 0.7);
    path3.lineTo(size.width * 0.6, size.height * 0.8);
    path3.lineTo(size.width * 0.8, size.height * 0.9);
    path3.lineTo(size.width, size.height * 0.8);
    
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, redPaint);
    canvas.drawPath(path3, greenPaint);
    
    // Add small dots at key points
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.1), 2, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 2, dotPaint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

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
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investment Page',
                      style:
                          FlutterFlowTheme.of(context).headlineLarge.override(
                                fontFamily: 'SF Pro Display',
                                color: Colors.white,
                                fontSize: 28.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: false,
                              ),
                    ),
                    const SizedBox(height: 16.0),
                    // Explore Africa Now Button
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 8.0, 16.0, 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35), // Orange color
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Explore Africa Now',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro Display',
                              color: Colors.white,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation1']!),

              const SizedBox(height: 32.0),

              // Continent Market Trends Section
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continent Market Trends',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'SF Pro Display',
                            color: Colors.white,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: false,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          '+12%',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'SF Pro Display',
                                color: Colors.white,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          'Last 6 Months ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'SF Pro Display',
                                    color: Colors.grey[400],
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                        Text(
                          '+12%',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'SF Pro Display',
                                color: const Color(0xFF4CAF50), // Green color
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Chart placeholder
                    Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: CustomPaint(
                        painter: MiniChartPainter(),
                        size: const Size(double.infinity, 120.0),
                      ),
                    ),
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation2']!),

              const SizedBox(height: 32.0),

              // Business Index and Natural Resources Row
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Row(
                  children: [
                    // Business Index Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed('BusinessIndex');
                        },
                        child: Container(
                          height: 220.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 20.0, 20.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top section with icon and miniature graph
                                Row(
                                  children: [
                                    // Left side - Icon and title
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4A90E2),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Icon(
                                              Icons.business_center,
                                              color: Colors.white,
                                              size: 20.0,
                                            ),
                                          ),
                                          const SizedBox(height: 12.0),
                                          Text(
                                            'Business Index',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily: 'SF Pro Display',
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: false,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Right side - Miniature graph
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 60.0,
                                        child: CustomPaint(
                                          painter: MiniGraphPainter(),
                                          size: const Size(80, 60),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  'Explore diverse sectors from tech startups to financial services.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        color: Colors.grey[400],
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 12.0),
                                Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    'View more',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Natural Resources Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed('naturalResources');
                        },
                        child: Container(
                          height: 220.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/naturalResources.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation3']!),

              const SizedBox(height: 24.0),

              // Influential Figures and Country Profile Row
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Row(
                  children: [
                    // Influential Figures Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed('ProminentPeople');
                        },
                        child: Container(
                          height: 260.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 20.0, 20.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile image placeholder
                                Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/Nana-Bediako.jpg'),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Influential Figures',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        color: const Color(0xFF4A90E2),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Learn from leading entrepreneurs and strategists.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        color: Colors.grey[400],
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 12.0),
                                Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    'View more',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Country Profile Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed('CountriesList');
                        },
                        child: Container(
                          height: 260.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 20.0, 20.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Chart icon and stats
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: CustomPaint(
                                        painter: MiniChartPainter(),
                                        size: const Size(40.0, 40.0),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'GDP Growth',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.grey[400],
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                        Text(
                                          '4.2 %',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                // Additional stats
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Inflation',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.grey[400],
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                        Text(
                                          '9.5 %',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Foreign DFI',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.grey[400],
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                        Text(
                                          '\$ 75 bln',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'SF Pro Display',
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  'Country Profile',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        color: const Color(0xFF9C27B0),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Stay informed with the latest information and metrics on each country.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        color: Colors.grey[400],
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 12.0),
                                Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    'View more',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: false,
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
                ),
              ),

              const SizedBox(height: 32.0),
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
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
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
            onPressed: () {},
            text: buttonText,
            options: FFButtonOptions(
              width: double.infinity,
              height: 48.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
              // Direct navigation to countries list
              context.pushNamed('CountriesList');
            },
            text: buttonText,
            options: FFButtonOptions(
              width: double.infinity,
              height: 44.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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

  Widget _buildCountryPreview(
    String flag,
    String name,
    String gdp,
    Color color, {
    CountryProfilesRow? countryData,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              flag,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'SF Pro Display',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: false,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              gdp,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'SF Pro Display',
                    color: color,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: false,
                  ),
            ),
          ],
        ),
      ),
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

// Custom painter for the mini chart in Country Profile card
class MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Create a simple line chart
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw dots at each point
    final dotPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
