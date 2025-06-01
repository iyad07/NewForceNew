import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/home_page/new_force_article_details/new_force_article_details_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../../../backend/scrapers/news_provider.dart';
import '../../../backend/supabase/database/tables/new_force_articles.dart';
import '../../../backend/supabase/database/tables/safe_new_force_articles.dart';
import 'news_feed_model.dart';

export 'news_feed_model.dart';

class NewsFeedWidget extends StatefulWidget {
  const NewsFeedWidget({Key? key}) : super(key: key);

  @override
  _NewsFeedWidgetState createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  late NewsFeedModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewsFeedModel());

    // Initialize the news provider and fetch news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNews();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Fetch news from all sources
  Future<void> _fetchNews({bool forceRefresh = false}) async {
    try {
      if (!mounted) return;
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      await newsProvider.fetchAllNews(force: forceRefresh);
    } catch (e) {
      print('Error fetching news: $e');
      // If we're still mounted, show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load news. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text(
            'African News Feed',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: () => _fetchNews(forceRefresh: true),
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              if (newsProvider.isLoading) {
                return Center(
                  child: SpinKitPulse(
                    color: FlutterFlowTheme.of(context).primary,
                    size: 50.0,
                  ),
                );
              }

              if (newsProvider.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading news',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              //fontFamily: 'SFPro',
                              fontSize: 16.0,
                            ),
                      ),
                      SizedBox(height: 16.0),
                      FFButtonWidget(
                        onPressed: () => _fetchNews(forceRefresh: true),
                        text: 'Retry',
                        options: FFButtonOptions(
                          width: 130.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                          elevation: 2.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Get references to the news lists with null safety
              final ghanaWebNews = newsProvider.ghanaWebNews ?? [];
              final panAfricanNews = newsProvider.panAfricanNews ?? [];

              final allNews = [...ghanaWebNews, ...panAfricanNews];

              if (allNews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No news available',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              //fontFamily: 'SFPro',
                              fontSize: 16.0,
                            ),
                      ),
                      SizedBox(height: 16.0),
                      FFButtonWidget(
                        onPressed: () => _fetchNews(forceRefresh: true),
                        text: 'Refresh',
                        options: FFButtonOptions(
                          width: 130.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                          elevation: 2.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _fetchNews(forceRefresh: true),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 8.0),
                        child: Text(
                          'GhanaWeb News',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      _buildNewsList(ghanaWebNews),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 8.0),
                        child: Text(
                          'Pan African News',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      _buildNewsList(panAfricanNews),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList(List<NewForceArticlesRow> newsList) {
    // Handle empty list case
    if (newsList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No articles available',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        // Ensure we don't access an invalid index
        if (index >= newsList.length) {
          return SizedBox.shrink();
        }

        // Get the article and convert to SafeNewForceArticlesRow
        final originalArticle = newsList[index];

        // Skip articles with null data
        if (originalArticle.data == null) {
          return SizedBox.shrink();
        }

        // Create a safe wrapper for the article
        final article = SafeNewForceArticlesRow(originalArticle.data);

        // Extra validation for image URL to prevent empty string errors
        final String imageUrl = article.articeImage ?? '';
        final bool hasValidImage = imageUrl.isNotEmpty && !imageUrl.contains('null');

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
          child: InkWell(
            onTap: () async {
              // Navigate to the article details page using the Navigator directly
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewForceArticleDetailsWidget(
                    publisher: article.publishers,
                    articleImage: article.articeImage,
                    description: article.description,
                    newsbody: article.articleBody,
                    title: article.title,
                    datecreated: article.createdAt,
                    newsUrl: article.articleUrl,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x32000000),
                    offset: Offset(0.0, 2.0),
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: hasValidImage
                        ? CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 500),
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/app_launcher_icon.png',
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/app_launcher_icon.png',
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.publishers ?? 'Unknown Publisher',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          // SafeNewForceArticlesRow handles null createdAt values
                          () {
                            try {
                              // SafeNewForceArticlesRow.createdAt is never null (returns DateTime.now() as fallback)
                              return timeago.format(article.createdAt);
                            } catch (e) {
                              print('Error formatting time: $e');
                              return 'Recently';
                            }
                          }(),
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? 'No Title',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            article.description ?? 'No description available',
                            maxLines: 3,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
