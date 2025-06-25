import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'event_details_model.dart';
export 'event_details_model.dart';

class EventDetailsWidget extends StatefulWidget {
  const EventDetailsWidget({
    super.key,
    required this.eventTitle,
    required this.eventLocation,
    required this.eventCategory,
    required this.eventDescription,
  });

  final String eventTitle;
  final String eventLocation;
  final String eventCategory;
  final String eventDescription;

  static String routeName = 'EventDetails';
  static String routePath = '/eventDetails';

  @override
  State<EventDetailsWidget> createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<EventDetailsWidget>
    with TickerProviderStateMixin {
  late EventDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EventDetailsModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
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
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
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

  Color _getCategoryColor() {
    switch (widget.eventCategory.toLowerCase()) {
      case 'agriculture':
        return Colors.green;
      case 'energy':
        return FlutterFlowTheme.of(context).primary;
      case 'investment':
        return FlutterFlowTheme.of(context).secondary;
      case 'market update':
        return Colors.blue;
      case 'business':
        return Colors.orange;
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Event Details',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SF Pro Display',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts: false,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Header Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context).alternate.withOpacity(0.1),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Badge
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                            decoration: BoxDecoration(
                              color: _getCategoryColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              widget.eventCategory,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'SF Pro Display',
                                    color: _getCategoryColor(),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          
                          // Event Title
                          Text(
                            widget.eventTitle,
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
                          const SizedBox(height: 12.0),
                          
                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 20.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.eventLocation,
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                  
                  const SizedBox(height: 24.0),
                  
                  // Event Details Section
                  Text(
                    'Event Details',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  // Description Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                      child: Text(
                        widget.eventDescription.isNotEmpty 
                            ? widget.eventDescription 
                            : 'This ${widget.eventCategory.toLowerCase()} event in ${widget.eventLocation} presents exciting opportunities for networking, learning, and business development. Join industry leaders and experts as they discuss the latest trends, innovations, and investment opportunities in the African market.',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'SF Pro Display',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              lineHeight: 1.5,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
                  
                  const SizedBox(height: 24.0),
                  
                  // Event Information Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Date',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Text(
                                'Coming Soon',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondary.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: FlutterFlowTheme.of(context).secondary,
                                size: 24.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Duration',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Text(
                                '2-3 Days',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
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
      ),
    );
  }
}