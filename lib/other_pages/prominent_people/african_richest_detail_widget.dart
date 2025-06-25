import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AfricanRichestDetailModel extends FlutterFlowModel<AfricanRichestDetailWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class AfricanRichestDetailWidget extends StatefulWidget {
  const AfricanRichestDetailWidget({
    super.key,
    required this.person,
  });

  final Map<String, dynamic> person;

  @override
  State<AfricanRichestDetailWidget> createState() =>
      _AfricanRichestDetailWidgetState();
}

class _AfricanRichestDetailWidgetState
    extends State<AfricanRichestDetailWidget> {
  late AfricanRichestDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AfricanRichestDetailModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            widget.person['Name']?.toString() ?? 'African Richest',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SF Pro Display',
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              useGoogleFonts: false,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Hero Image Section
                Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        FlutterFlowTheme.of(context).secondary,
                      ],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(0.0, -1.0),
                      end: AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(71.0),
                          child: widget.person['Pics'] != null &&
                                  widget.person['Pics'].toString().isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.person['Pics'].toString(),
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 150.0,
                                    height: 150.0,
                                    color: Colors.white.withOpacity(0.3),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 60.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 150.0,
                                    height: 150.0,
                                    color: Colors.white.withOpacity(0.3),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 60.0,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 150.0,
                                  height: 150.0,
                                  color: Colors.white.withOpacity(0.3),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 60.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      // Name
                      Text(
                        widget.person['Name']?.toString() ?? 'Unknown',
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          fontSize: 28.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      
                      // Net Worth
                      if (widget.person['Networth'] != null &&
                          widget.person['Networth'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            widget.person['Networth'].toString(),
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'SF Pro Display',
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Details Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 24.0, 20.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Info Cards
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Age Card
                          if (widget.person['Age'] != null)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cake,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Age',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'SF Pro Display',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      widget.person['Age'].toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'SF Pro Display',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          if (widget.person['Age'] != null &&
                              widget.person['Networth'] != null)
                            const SizedBox(width: 12.0),
                          
                          // Net Worth Card
                          if (widget.person['Networth'] != null)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: FlutterFlowTheme.of(context).secondary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Net Worth',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'SF Pro Display',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      widget.person['Networth'].toString(),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'SF Pro Display',
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
                      
                      // Biography Section
                      const SizedBox(height: 32.0),
                      Text(
                        'Biography',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'SF Pro Display',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 20.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          widget.person['Descriptions']?.toString() ?? 
                          widget.person['Description']?.toString() ?? 
                          widget.person['Bio']?.toString() ?? 
                          'This prominent African business leader has made significant contributions to the continent\'s economic development and continues to inspire future generations of entrepreneurs.',
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'SF Pro Display',
                            letterSpacing: 0.0,
                            lineHeight: 1.6,
                            useGoogleFonts: false,
                          ),
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
      ),
    );
  }
}