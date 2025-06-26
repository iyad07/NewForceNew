// community_hub_widget.dart - Updated with modern UI style
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'community_hub_model.dart';
export 'community_hub_model.dart';

class CommunityHubWidget extends StatefulWidget {
  const CommunityHubWidget({super.key});

  @override
  State<CommunityHubWidget> createState() => _CommunityHubWidgetState();
}

class _CommunityHubWidgetState extends State<CommunityHubWidget> {
  late CommunityHubModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityHubModel());
    
    // Start background loading immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.preloadTopics();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1E2022),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF222426), Color(0xFF121416)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(1.0, -0.34),
                end: AlignmentDirectional(-1.0, 0.34),
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                await _model.refreshTopics();
                setState(() {});
              },
              color: Color(0xFFFF8000),
              backgroundColor: Color(0xFF2A2D30),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section with modern UI style
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x2C7E5F1A), Color(0xFF201D1B)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.59, -1.0),
                            end: AlignmentDirectional(-0.59, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Forum Hub',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                          useGoogleFonts: false,
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    'Join the conversation',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SF Pro Display',
                                          useGoogleFonts: false,
                                          color: Color(0xFFB0B3B8),
                                          letterSpacing: 0.0,
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

                  // Topics of the Day Section
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 20.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Topics of the Day',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'SF Pro Display',
                                  useGoogleFonts: false,
                                  color: Color(0x47FF8000),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Topics List with Backend Integration
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
                    child: _buildTopicsList(),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsGrid(List<TopicsRow> topics) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
          child: _buildModernTopicCard(topic),
        );
      },
    );
  }

  // Optimized topics loading with caching
  Future<List<TopicsRow>> _getTopicsOptimized() async {
    return await _model.getTopics();
  }

  Widget _buildTopicsList() {
    // Show cached data immediately if available
    final cachedTopics = _model.cachedTopics;
    
    return FutureBuilder<List<TopicsRow>>(
      future: _getTopicsOptimized(),
      builder: (context, snapshot) {
        // If we have cached data and are loading, show cached data with refresh indicator
        if (cachedTopics != null && cachedTopics.isNotEmpty && !snapshot.hasData) {
          return Column(
            children: [
              // Subtle loading indicator
              Container(
                height: 2.0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8000)),
                ),
              ),
              const SizedBox(height: 8.0),
              _buildTopicsGrid(cachedTopics),
            ],
          );
        }
        // Handle errors with modern UI
        if (snapshot.hasError) {
          debugPrint('Error fetching topics: ${snapshot.error}');
          return Center(
            child: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Color(0xFF2A2D30),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Color(0xFF3A3D41),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: Color(0xFFFF6B6B),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Error loading topics',
                    style: FlutterFlowTheme.of(context)
                        .titleMedium
                        .override(
                          fontFamily: 'SF Pro Display',
                          useGoogleFonts: false,
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Please try again later',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'SF Pro Display',
                          useGoogleFonts: false,
                          color: Color(0xFFB0B3B8),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading indicator with modern UI
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(48.0),
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF8000),
                  ),
                  strokeWidth: 3.0,
                ),
              ),
            ),
          );
        }

        List<TopicsRow> topicsRowList = snapshot.data!;

        // If no data, show empty state with modern UI
        if (topicsRowList.isEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Color(0xFF2A2D30),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Color(0xFF3A3D41),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.forum_outlined,
                    size: 64.0,
                    color: Color(0xFF6C7075),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'No topics available',
                    style: FlutterFlowTheme.of(context)
                        .titleMedium
                        .override(
                          fontFamily: 'SF Pro Display',
                          useGoogleFonts: false,
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Check back later for new discussions',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'SF Pro Display',
                          useGoogleFonts: false,
                          color: Color(0xFFB0B3B8),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Build topics list with modern UI cards
        return _buildTopicsGrid(topicsRowList);
      },
    );
  }

  Widget _buildModernTopicCard(TopicsRow topic) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(
          'topicDetail',
          queryParameters: {
            'topicId': serializeParam(
              topic.id,
              ParamType.int,
            ),
            'topicTitle': serializeParam(
              topic.title,
              ParamType.String,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF2A2D30),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Color(0xFF3A3D41),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Topic Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: topic.imageUrl != null && topic.imageUrl!.isNotEmpty
                        ? Image.network(
                            topic.imageUrl!,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3A3D41),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.forum,
                                  color: Color(0xFF6C7075),
                                  size: 24.0,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF3A3D41),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.forum,
                              color: Color(0xFF6C7075),
                              size: 24.0,
                            ),
                          ),
                  ),
                  
                  // Topic Content
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title ?? 'Untitled Topic',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'SF Pro Display',
                                useGoogleFonts: false,
                                color: Colors.white,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (topic.description != null && topic.description!.isNotEmpty)
                          Text(
                            topic.description!,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'SF Pro Display',
                                  useGoogleFonts: false,
                                  color: Color(0xFFB0B3B8),
                                  letterSpacing: 0.0,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.people_rounded,
                                  color: Color(0xFF6C7075),
                                  size: 16.0,
                                ),
                                Text(
                                  _formatCount(topic.postsCount ?? 0),
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        useGoogleFonts: false,
                                        color: Color(0xFF6C7075),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.chat_bubble_rounded,
                                  color: Color(0xFF6C7075),
                                  size: 16.0,
                                ),
                                Text(
                                  '${topic.postsCount ?? 0}',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: 'SF Pro Display',
                                        useGoogleFonts: false,
                                        color: Color(0xFF6C7075),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                  
                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF6C7075),
                    size: 20.0,
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}