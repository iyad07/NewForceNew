import 'package:cached_network_image/cached_network_image.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'investment_topics_article_details_model.dart';
export 'investment_topics_article_details_model.dart';

class InvestmentTopicsArticleDetailsWidget extends StatefulWidget {
  const InvestmentTopicsArticleDetailsWidget({
    super.key,
    required this.publlisher,
    required this.publisherImage,
    required this.timeCreated,
    required this.articleImage,
    required this.articleDescription,
    required this.tag,
    required this.articleNews,
  });

  final String? publlisher;
  final String? publisherImage;
  final String? timeCreated;
  final String? articleImage;
  final String? articleDescription;
  final String? tag;
  final String? articleNews;

  @override
  State<InvestmentTopicsArticleDetailsWidget> createState() =>
      _InvestmentTopicsArticleDetailsWidgetState();
}

class _InvestmentTopicsArticleDetailsWidgetState
    extends State<InvestmentTopicsArticleDetailsWidget> {
  late InvestmentTopicsArticleDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentTopicsArticleDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildPublisherImage() {
    final imageUrl = widget.publisherImage;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.trending_up_rounded,
          color: FlutterFlowTheme.of(context).primaryBackground,
          size: 24.0,
        ),
      );
    }

    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).accent1,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 44.0,
            height: 44.0,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: FlutterFlowTheme.of(context).accent1,
              child: Icon(
                Icons.image,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: FlutterFlowTheme.of(context).accent1,
              child: Icon(
                Icons.trending_up_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    final imageUrl = widget.articleImage;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200.0,
        color: FlutterFlowTheme.of(context).accent1,
        child: Icon(
          Icons.assessment_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 48.0,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(0.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 200.0,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: FlutterFlowTheme.of(context).accent1,
          child: Center(
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: FlutterFlowTheme.of(context).accent1,
          child: Icon(
            Icons.assessment_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 48.0,
          ),
        ),
      ),
    );
  }

  String _formatTimeCreated(String? timeCreated) {
    if (timeCreated == null || timeCreated.isEmpty) {
      return dateTimeFormat("yMMMd", DateTime.now());
    }
    
    try {
      final date = DateTime.parse(timeCreated);
      return dateTimeFormat("yMMMd", date);
    } catch (e) {
      return timeCreated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildPublisherImage(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  widget.publlisher,
                                  'Investment Publisher',
                                ),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Tiro Bangla',
                                  letterSpacing: 0.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  _formatTimeCreated(widget.timeCreated),
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                    fontFamily: 'SFPro',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 207.0,
                  child: Stack(
                    children: [
                      _buildArticleImage(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.articleDescription,
                      'Investment news and market insights',
                    ),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'SFPro',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget.tag,
                            'Investment',
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Tiro Bangla',
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ]
                        .divide(const SizedBox(width: 8.0))
                        .addToStart(const SizedBox(width: 16.0))
                        .addToEnd(const SizedBox(width: 16.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.articleNews?.isNotEmpty == true ? widget.articleNews : 'No content available for this article.',
                      'No content available for this article.',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SFPro',
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 12.0)),
            ),
          ),
        ),
      ),
    );
  }
}