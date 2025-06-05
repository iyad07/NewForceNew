import 'package:cached_network_image/cached_network_image.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'new_force_article_details_model.dart';
export 'new_force_article_details_model.dart';

class NewForceArticleDetailsWidget extends StatefulWidget {
  const NewForceArticleDetailsWidget({
    super.key,
    required this.publisher,
    required this.articleImage,
    required this.description,
    required this.newsbody,
    required this.title,
    required this.datecreated,
    required this.newsUrl,
  });

  final String? publisher;
  final String? articleImage;
  final String? description;
  final String? newsbody;
  final String? title;
  final DateTime? datecreated;
  final String? newsUrl;

  @override
  State<NewForceArticleDetailsWidget> createState() =>
      _NewForceArticleDetailsWidgetState();
}

class _NewForceArticleDetailsWidgetState
    extends State<NewForceArticleDetailsWidget> {
  late NewForceArticleDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewForceArticleDetailsModel());
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
            valueOrDefault<String>(widget.title, 'Article'),
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
                                    dateTimeFormat("yMMMd", widget.datecreated),
                                    'Recently',
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
                if (widget.articleImage != null && widget.articleImage!.isNotEmpty)
                  SizedBox(
                    height: 207.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.articleImage!,
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: 200.0,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              height: 200.0,
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
                if (widget.title != null && widget.title!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      widget.title!,
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: 'SFPro',
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
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
                if (widget.newsbody != null && widget.newsbody!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      widget.newsbody!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SFPro',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            lineHeight: 1.5,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                if (widget.newsUrl != null && widget.newsUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await launchURL(widget.newsUrl!);
                      },
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.link,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 16.0,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Read full article',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SFPro',
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ].divide(const SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}