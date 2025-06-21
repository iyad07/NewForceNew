import 'package:cached_network_image/cached_network_image.dart';

import '/backend/supabase/supabase.dart';
import '/backend/scrapers/news_provider.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'investment_topic_model.dart';
export 'investment_topic_model.dart';

class InvestmentTopicWidget extends StatefulWidget {
  const InvestmentTopicWidget({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  State<InvestmentTopicWidget> createState() => _InvestmentTopicWidgetState();
}

class _InvestmentTopicWidgetState extends State<InvestmentTopicWidget>
    with TickerProviderStateMixin {
  late InvestmentTopicModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InvestmentTopicModel());

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
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchInvestmentNews(forceRefresh: false);
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
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 30.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            title: Text(
              valueOrDefault<String>(
                widget.name,
                '0',
              ),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'SFPro',
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
              await newsProvider.fetchInvestmentNews(forceRefresh: true);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Consumer<NewsProvider>(
                    builder: (context, newsProvider, _) {
                      final allArticles = newsProvider.investmentNews;
                      final filteredArticles = allArticles
                          .where((article) => article.tag == widget.name)
                          .toList();
                      
                      print('DEBUG Investment: Total articles: ${allArticles.length}');
                      print('DEBUG Investment: Looking for tag: ${widget.name}');
                      print('DEBUG Investment: Filtered articles: ${filteredArticles.length}');
                      
                      if (allArticles.isNotEmpty) {
                        print('DEBUG Investment: Available tags: ${allArticles.map((a) => a.tag).toSet().toList()}');
                      }
                      
                      if (newsProvider.isLoadingInvestment) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: SpinKitRipple(
                              color: FlutterFlowTheme.of(context).primary,
                              size: 50.0,
                            ),
                          ),
                        );
                      }
                      
                      if (filteredArticles.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  'No investment articles found for ${widget.name}.',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total articles: ${allArticles.length}',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                                Text(
                                  'Available tags: ${allArticles.map((a) => a.tag).toSet().join(", ")}',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await newsProvider.fetchInvestmentNews(forceRefresh: true);
                                  },
                                  child: const Text('Force Refresh'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: filteredArticles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 1.0),
                        itemBuilder: (context, listViewIndex) {
                          final listViewInvestementNewsArticlesRow = filteredArticles[listViewIndex];
                          
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  'investmentTopicsArticleDetails',
                                  queryParameters: {
                                    'publlisher': serializeParam(
                                      listViewInvestementNewsArticlesRow.publisher,
                                      ParamType.String,
                                    ),
                                    'publisherImage': serializeParam(
                                      listViewInvestementNewsArticlesRow.publisherImageUrl,
                                      ParamType.String,
                                    ),
                                    'timeCreated': serializeParam(
                                      listViewInvestementNewsArticlesRow.createdAt.toString(),
                                      ParamType.String,
                                    ),
                                    'articleImage': serializeParam(
                                      listViewInvestementNewsArticlesRow.image,
                                      ParamType.String,
                                    ),
                                    'articleDescription': serializeParam(
                                      listViewInvestementNewsArticlesRow.description,
                                      ParamType.String,
                                    ),
                                    'tag': serializeParam(
                                      listViewInvestementNewsArticlesRow.tag,
                                      ParamType.String,
                                    ),
                                    'articleNews': serializeParam(
                                      listViewInvestementNewsArticlesRow.newsDescription,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 170.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0x95191919),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x2B202529),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: listViewInvestementNewsArticlesRow.image!,
                                                  width: 110.0,
                                                  height: 110.0,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    'assets/images/app_launcher_icon.png',
                                                    width: 110.0,
                                                    height: 110.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  placeholder: (context, url) => Container(
                                                    width: 110.0,
                                                    height: 110.0,
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        child: SpinKitRipple(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewInvestementNewsArticlesRow.title,
                                                          '0',
                                                        ),
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                              fontFamily: 'SFPro',
                                                              fontSize: 13.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: false,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 6.0),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          valueOrDefault<String>(
                                                            listViewInvestementNewsArticlesRow.description,
                                                            '0',
                                                          ).maybeHandleOverflow(
                                                            maxChars: 100,
                                                            replacement: '…',
                                                          ),
                                                          minFontSize: 9.0,
                                                          maxLines: 4,
                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                fontFamily: 'SFPro',
                                                                fontSize: 11.0,
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
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                valueOrDefault<String>(
                                                  listViewInvestementNewsArticlesRow.publisher,
                                                  '0',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: 'Tiro Bangla',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                            Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  await Share.share(
                                                    '',
                                                    sharePositionOrigin: getWidgetBoundingBox(context),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    Icons.share,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    size: 20.0,
                                                  ),
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
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                          );
                        },
                      );
                    },
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