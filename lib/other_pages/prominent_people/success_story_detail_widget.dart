import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SuccessStoryDetailModel extends FlutterFlowModel<SuccessStoryDetailWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class SuccessStoryDetailWidget extends StatefulWidget {
  const SuccessStoryDetailWidget({
    super.key,
    required this.story,
  });

  final Map<String, dynamic> story;

  @override
  State<SuccessStoryDetailWidget> createState() =>
      _SuccessStoryDetailWidgetState();
}

class _SuccessStoryDetailWidgetState
    extends State<SuccessStoryDetailWidget> {
  late SuccessStoryDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuccessStoryDetailModel());
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
            'Success Story',
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
                  height: 280.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        FlutterFlowTheme.of(context).tertiary,
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
                      // Image or Success Icon
                      if (widget.story['Image URL'] != null && widget.story['Image URL'].toString().isNotEmpty)
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 3.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration: const Duration(milliseconds: 500),
                              imageUrl: widget.story['Image URL'].toString(),
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 120.0,
                                height: 120.0,
                                color: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 120.0,
                                height: 120.0,
                                color: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Icon(
                            Icons.trending_up_rounded,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      
                      // Title
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                        child: Text(
                          widget.story['Title']?.toString() ?? 'Success Story',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: 'SF Pro Display',
                            color: Colors.white,
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: false,
                          ),
                        ),
                      ),
                      
                      // Sector
                      if (widget.story['Sector'] != null &&
                          widget.story['Sector'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              widget.story['Sector'].toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'SF Pro Display',
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: false,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Content Section
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
                          // Country Card
                          if (widget.story['Country'] != null &&
                              widget.story['Country'].toString().isNotEmpty)
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
                                      Icons.public,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Country',
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
                                      widget.story['Country'].toString(),
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
                          
                          if (widget.story['Country'] != null &&
                              widget.story['Country'].toString().isNotEmpty &&
                              widget.story['Impact Metrics'] != null &&
                              widget.story['Impact Metrics'].toString().isNotEmpty)
                            const SizedBox(width: 12.0),
                          
                          // Impact Metrics Card
                          if (widget.story['Impact Metrics'] != null &&
                              widget.story['Impact Metrics'].toString().isNotEmpty)
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
                                      Icons.analytics,
                                      color: FlutterFlowTheme.of(context).tertiary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Impact',
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
                                      widget.story['Impact Metrics'].toString(),
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
                      
                      // Story Description Section
                      const SizedBox(height: 32.0),
                      Text(
                        'Success Story',
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
                          widget.story['Description']?.toString() ?? 'This is an inspiring success story showcasing innovation and achievement.',
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'SF Pro Display',
                            letterSpacing: 0.0,
                            lineHeight: 1.6,
                            useGoogleFonts: false,
                          ),
                        ),
                      ),
                      
                      // Key Achievements Section (using Impact Metrics as secondary info)
                      const SizedBox(height: 24.0),
                      Text(
                        'Key Impact',
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
                          color: FlutterFlowTheme.of(context).accent1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                widget.story['Impact Metrics']?.toString() ?? 'Significant positive impact on the community and economy.',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'SF Pro Display',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      

                      
                      // Key Achievements Section
                      if (widget.story['Key Achievements'] != null && widget.story['Key Achievements'].toString().isNotEmpty)
                        const SizedBox(height: 20.0),
                      if (widget.story['Key Achievements'] != null && widget.story['Key Achievements'].toString().isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Key Achievements',
                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                widget.story['Key Achievements'].toString(),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.6,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Additional Information Section
                      const SizedBox(height: 24.0),
                      Text(
                        'Additional Details',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'SF Pro Display',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      // Info Cards Grid
                      Row(
                        children: [
                          // Sector Info
                          if (widget.story['Sector'] != null &&
                              widget.story['Sector'].toString().isNotEmpty)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
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
                                        Icon(
                                          Icons.business_center_outlined,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Sector',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'SF Pro Display',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      widget.story['Sector'].toString(),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                          
                          if (widget.story['Sector'] != null &&
                              widget.story['Sector'].toString().isNotEmpty &&
                              widget.story['Country'] != null &&
                              widget.story['Country'].toString().isNotEmpty)
                            const SizedBox(width: 12.0),
                          
                          // Country Info
                          if (widget.story['Country'] != null &&
                              widget.story['Country'].toString().isNotEmpty)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
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
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Location',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'SF Pro Display',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      widget.story['Country'].toString(),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                      
                      // Call to Action Section
                      const SizedBox(height: 32.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 24.0, 20.0, 24.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              FlutterFlowTheme.of(context).secondary,
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(-1.0, 0.0),
                            end: AlignmentDirectional(1.0, 0),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.white,
                              size: 32.0,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Inspired by this success story?',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                fontFamily: 'SF Pro Display',
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Explore more opportunities and success stories from across Africa',
                              textAlign: TextAlign.center,
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