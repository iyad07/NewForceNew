import 'package:cached_network_image/cached_network_image.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_article_details_model.dart';
export 'home_article_details_model.dart';

class HomeArticleDetailsWidget extends StatefulWidget {
  const HomeArticleDetailsWidget({
    super.key,
    required this.title,
    required this.articleImage,
    this.description,
    this.content,
    this.author,
    this.publishDate,
    this.category,
  });

  final String title;
  final String articleImage;
  final String? description;
  final String? content;
  final String? author;
  final DateTime? publishDate;
  final String? category;

  @override
  State<HomeArticleDetailsWidget> createState() =>
      _HomeArticleDetailsWidgetState();
}

class _HomeArticleDetailsWidgetState extends State<HomeArticleDetailsWidget> {
  late HomeArticleDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeArticleDetailsModel());
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
            'Article Details',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Header with Author Info
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
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
                            child: Image.asset(
                              'assets/images/2c3MyMG6yIofkkulvyLX3I23d8t_(2).png',
                              width: 44.0,
                              height: 44.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                valueOrDefault<String>(widget.author, 'New Force Editorial'),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Tiro Bangla',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                      valueOrDefault<String>(
                                        dateTimeFormat("yMMMd", widget.publishDate),
                                        'Recently',
                                      ),
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            fontFamily: 'SFPro',
                                            fontSize: 10.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    if (widget.category != null && widget.category!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                        child: Container(
                                          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 8.0, 2.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).primary,
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            widget.category!,
                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                  fontFamily: 'SFPro',
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: false,
                                                ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Article Image
                SizedBox(
                  height: 250.0,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: widget.articleImage.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: widget.articleImage,
                                width: double.infinity,
                                height: 250.0,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 50.0,
                                  ),
                                ),
                              )
                            : Image.asset(
                                widget.articleImage,
                                width: double.infinity,
                                height: 250.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                
                // Article Title
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    widget.title,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SFPro',
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                
                // Article Description
                if (widget.description != null && widget.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      widget.description!,
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'SFPro',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                
                // Article Content
                if (widget.content != null && widget.content!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      widget.content!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SFPro',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            lineHeight: 1.5,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                
                // Default content if no content provided
                if (widget.content == null || widget.content!.isEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This article showcases the ongoing efforts and initiatives of the New Force movement in transforming Ghana\'s political and economic landscape.',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'SFPro',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
                                useGoogleFonts: false,
                              ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'The New Force continues to champion progressive policies and innovative solutions that address the core challenges facing Ghana today. Through strategic partnerships, community engagement, and forward-thinking leadership, the movement is building a foundation for sustainable development and prosperity.',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'SFPro',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
                                useGoogleFonts: false,
                              ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Stay connected with the latest updates and developments as we work together to create a new Ghana that works for everyone.',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'SFPro',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ),
                
                // Share and Action Buttons
                /*Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 16.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Share Article',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SFPro',
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bookmark_add,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Save Article',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SFPro',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
              ].divide(const SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}