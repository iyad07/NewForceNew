import 'package:cached_network_image/cached_network_image.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'feed_your_curiosity_article_details_model.dart';
export 'feed_your_curiosity_article_details_model.dart';

class FeedYourCuriosityArticleDetailsWidget extends StatefulWidget {
  const FeedYourCuriosityArticleDetailsWidget({
    super.key,
    required this.publisherImage,
    required this.publisher,
    required this.dateCreated,
    required this.articleImage,
    required this.description,
    required this.tag,
    required this.newsbody,
  });

  final String? publisherImage;
  final String? publisher;
  final DateTime? dateCreated;
  final String? articleImage;
  final String? description;
  final String? tag;
  final String? newsbody;

  @override
  State<FeedYourCuriosityArticleDetailsWidget> createState() =>
      _FeedYourCuriosityArticleDetailsWidgetState();
}

class _FeedYourCuriosityArticleDetailsWidgetState
    extends State<FeedYourCuriosityArticleDetailsWidget> {
  late FeedYourCuriosityArticleDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedYourCuriosityArticleDetailsModel());
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
          Icons.article_outlined,
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
                Icons.article_outlined,
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
          Icons.image_outlined,
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
            Icons.image_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 48.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            valueOrDefault<String>(widget.tag, 'Article'),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SFPro',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                valueOrDefault<String>(widget.publisher, 'Unknown Publisher'),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Tiro Bangla',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    dateTimeFormat("yMMMd", widget.dateCreated),
                                    dateTimeFormat("yMMMd", DateTime.now()),
                                  ),
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                        fontFamily: 'SFPro',
                                        fontSize: 10.0,
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
                    valueOrDefault<String>(widget.description, 'No description available'),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SFPro',
                          fontSize: 18.0,
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
                          valueOrDefault<String>(widget.tag, 'General'),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Tiro Bangla',
                                fontSize: 14.0,
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
                    valueOrDefault<String>(widget.newsbody, 'No content available'),
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