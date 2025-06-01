import 'package:cached_network_image/cached_network_image.dart';

import '/backend/supabase/supabase.dart';
import '/backend/scrapers/news_provider.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'feedyour_curiosity_topics_model.dart';
export 'feedyour_curiosity_topics_model.dart';

class FeedyourCuriosityTopicsWidget extends StatefulWidget {
  const FeedyourCuriosityTopicsWidget({
    super.key,
    required this.tag,
  });

  final String? tag;

  @override
  State<FeedyourCuriosityTopicsWidget> createState() =>
      _FeedyourCuriosityTopicsWidgetState();
}

class _FeedyourCuriosityTopicsWidgetState
    extends State<FeedyourCuriosityTopicsWidget> {
  late FeedyourCuriosityTopicsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedyourCuriosityTopicsModel());
    // Fetch Feed Your Curiosity articles when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchFeedYourCuriosity();
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            title: Text(
              valueOrDefault<String>(
                widget.tag,
                '0',
              ),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'SFPro',
                    color: Colors.white,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: () async {
              final newsProvider = Provider.of<NewsProvider>(context, listen: false);
              await newsProvider.fetchFeedYourCuriosity(forceRefresh: true);
            },
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<NewsProvider>(
                  builder: (context, newsProvider, _) {
                    // Filter articles by tag
                    final filteredArticles = newsProvider.feedYourCuriosityNews
                        .where((article) => article.tag == widget.tag)
                        .toList();
                    
                    // Show loading indicator if still loading
                    if (newsProvider.isLoadingFeedYourCuriosity) {
                      return Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: SpinKitRipple(
                            color: FlutterFlowTheme.of(context).primary,
                            size: 40.0,
                          ),
                        ),
                      );
                    }
                    
                    // If no articles found for this tag, show a message
                    if (filteredArticles.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No articles found for ${widget.tag}. Pull down to refresh.',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    
                    List<FeedYourCuriosityTopicsRow>
                        listViewFeedYourCuriosityTopicsRowList = filteredArticles;

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        12.0,
                        0,
                        12.0,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewFeedYourCuriosityTopicsRowList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 1.0),
                      itemBuilder: (context, listViewIndex) {
                        final listViewFeedYourCuriosityTopicsRow =
                            listViewFeedYourCuriosityTopicsRowList[
                                listViewIndex];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 12.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                'feedYourCuriosityArticleDetails',
                                queryParameters: {
                                  'publisherImage': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow
                                        .publisherImageUrl,
                                    ParamType.String,
                                  ),
                                  'publisher': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow
                                        .publisher,
                                    ParamType.String,
                                  ),
                                  'dateCreated': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow
                                        .createdAt,
                                    ParamType.DateTime,
                                  ),
                                  'articleImage': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow.image,
                                    ParamType.String,
                                  ),
                                  'description': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow
                                        .newsDescription,
                                    ParamType.String,
                                  ),
                                  'tag': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow.tag,
                                    ParamType.String,
                                  ),
                                  'newsbody': serializeParam(
                                    listViewFeedYourCuriosityTopicsRow.newsBody,
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            child: Container(
                              width: 350.0,
                              height: 206.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x2B202529),
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 8.0, 8.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  listViewFeedYourCuriosityTopicsRow
                                                      .image!,
                                              width: 151.0,
                                              height: 143.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 4.0, 0.0, 4.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 5.0, 0.0, 5.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        listViewFeedYourCuriosityTopicsRow
                                                            .title,
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily: 'SFPro',
                                                            fontSize: 15.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                false,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 4.0, 0.0, 0.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        listViewFeedYourCuriosityTopicsRow
                                                            .newsDescription,
                                                        '0',
                                                      ).maybeHandleOverflow(
                                                        maxChars: 100,
                                                        replacement: '…',
                                                      ),
                                                      maxLines: 4,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelSmall
                                                          .override(
                                                            fontFamily: 'SFPro',
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                false,
                                                          ),
                                                    ),
                                                  ),
                                                ].divide(const SizedBox(
                                                    height: 5.0)),
                                              ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(width: 5.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              2.0, 8.0, 8.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 20.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    dateTimeFormat(
                                                        "yMMMd",
                                                        listViewFeedYourCuriosityTopicsRow
                                                            .createdAt),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            'Tiro Bangla',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Builder(
                                                builder: (context) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await Share.share(
                                                        '',
                                                        sharePositionOrigin:
                                                            getWidgetBoundingBox(
                                                                context),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 5.0)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
