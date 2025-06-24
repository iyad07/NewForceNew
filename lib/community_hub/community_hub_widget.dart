import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Community Hub',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'SF Pro Display',
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  'Join the conversation on topics that matter to Africa',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro Display',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: _buildTopicsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<TopicsRow>> _getTopicsOrderedByLatestPost() async {
    try {
      // Get all active topics
      final topics = await TopicsTable().queryRows(
        queryFn: (q) => q.eq('is_active', true),
      );

      // For each topic, get the latest post timestamp
      final topicsWithLatestPost = <Map<String, dynamic>>[];
      
      for (final topic in topics) {
        final latestPosts = await CommunityPostsTable().queryRows(
          queryFn: (q) => q
              .eq('topic_id', topic.id)
              .order('created_at', ascending: false)
              .limit(1),
        );
        
        final latestPostTime = latestPosts.isNotEmpty 
            ? latestPosts.first.createdAt 
            : topic.createdAt; // Fallback to topic creation time
            
        topicsWithLatestPost.add({
          'topic': topic,
          'latest_post_time': latestPostTime,
        });
      }
      
      // Sort by latest post time (most recent first)
      topicsWithLatestPost.sort((a, b) => 
          (b['latest_post_time'] as DateTime).compareTo(a['latest_post_time'] as DateTime));
      
      // Return sorted topics
      return topicsWithLatestPost.map((item) => item['topic'] as TopicsRow).toList();
    } catch (e) {
      debugPrint('Error fetching topics ordered by latest post: $e');
      // Fallback to original query
      return TopicsTable().queryRows(
        queryFn: (q) => q.eq('is_active', true).order('created_at', ascending: false),
      );
    }
  }

  Widget _buildTopicsList() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
      child: FutureBuilder<List<TopicsRow>>(
        future: _getTopicsOrderedByLatestPost(),
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            debugPrint('Error fetching topics: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Error loading topics',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).error,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Please try again later',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show loading indicator while data is being fetched
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }

          List<TopicsRow> topicsRowList = snapshot.data!;

          // If no data, show empty state
          if (topicsRowList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.forum_outlined,
                    size: 64.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'No topics available',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Check back later for new discussions',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro Display',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: topicsRowList.length,
            itemBuilder: (context, index) {
              final topic = topicsRowList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildTopicCard(topic),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(TopicsRow topic) {
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
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: const Color(0x1A000000),
              offset: const Offset(
                0.0,
                2.0,
              ),
            )
          ],
          ),
          child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Topic Image
            SizedBox(
              width: 85.0,
              height: 85.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(0.0),
                ),
                child: topic.imageUrl != null && topic.imageUrl!.isNotEmpty
                    ? Image.network(
                        topic.imageUrl!,
                        width: 85.0,
                        height: 85.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 85.0,
                            height: 85.0,
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.forum,
                              size: 40.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 85.0,
                        height: 85.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.forum,
                          size: 40.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
              ),
            ),
            // Topic Content
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 8.0, 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        topic.title ?? 'Untitled Topic',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'SF Pro Display',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    if (topic.description != null && topic.description!.isNotEmpty)
                      Flexible(
                        child: Text(
                          topic.description!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'SF Pro Display',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 3.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${topic.postsCount ?? 0} posts',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'SF Pro Display',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}