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

  String _selectedCountry = 'All';
  final List<String> _countries = [
    'All',
    'Nigeria',
    'Kenya',
    'South Africa',
    'Ethiopia',
    'Ghana',
    'General Africa'
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewsFeedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNews();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _fetchNews({bool forceRefresh = false}) async {
    try {
      if (!mounted) return;
      final newsProvider = Provider.of<EnhancedNewsProvider>(context, listen: false);
      
      // Debug information
      print('=== NEWS FETCH DEBUG ===');
      print('Force refresh: $forceRefresh');
      print('Current African news count: ${newsProvider.africanNews.length}');
      print('Is loading: ${newsProvider.isLoading}');
      print('Error message: ${newsProvider.errorMessage}');
      print('Available countries: ${newsProvider.availableCountries.length}');
      
      await newsProvider.fetchAllNews(force: forceRefresh);
      
      // Debug after fetch
      print('After fetch - African news count: ${newsProvider.africanNews.length}');
      print('After fetch - Available countries: ${newsProvider.availableCountries.length}');
      print('========================');
      
    } catch (e) {
      print('Error fetching news: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load news. Please try again.')),
        );
      }
    }
  }

  List<NewForceArticlesRow> _getFilteredNews(EnhancedNewsProvider newsProvider) {
    if (_selectedCountry == 'All') {
      return newsProvider.africanNews;
    } else {
      return newsProvider.getNewsByCountry(_selectedCountry);
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
            IconButton(
              icon: Icon(
                Icons.bug_report,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: () async {
                final newsProvider = Provider.of<EnhancedNewsProvider>(context, listen: false);
                print('=== MANUAL DEBUG INFO ===');
                print('African news: ${newsProvider.africanNews.length}');
                print('Feed curiosity news: ${newsProvider.feedYourCuriosityNews.length}');
                print('Investment news: ${newsProvider.investmentNews.length}');
                print('Available countries: ${newsProvider.availableCountries}');
                print('Is loading: ${newsProvider.isLoading}');
                print('Error: ${newsProvider.errorMessage}');
                print('========================');
                
                // Force clear cache and refresh
                await _fetchNews(forceRefresh: true);
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Consumer<EnhancedNewsProvider>(
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
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final filteredNews = _getFilteredNews(newsProvider);

              return Column(
                children: [
                  // Country filter dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: Color(0x1F000000),
                          offset: Offset(0.0, 1.0),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filter by Country: ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCountry,
                            isExpanded: true,
                            items: _countries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(
                                  country,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              }
                            },
                            underline: Container(
                              height: 1,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // News count indicator
                  if (filteredNews.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '${filteredNews.length} articles found ${_selectedCountry != 'All' ? 'for $_selectedCountry' : ''}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ),

                  // News list
                  Expanded(
                    child: filteredNews.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedCountry == 'All'
                                      ? 'No news available'
                                      : 'No news available for $_selectedCountry',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 16.0,
                                      ),
                                ),
                                SizedBox(height: 16.0),
                                FFButtonWidget(
                                  onPressed: () =>
                                      _fetchNews(forceRefresh: true),
                                  text: 'Refresh',
                                  options: FFButtonOptions(
                                    width: 130.0,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                    elevation: 2.0,
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _fetchNews(forceRefresh: true),
                            color: FlutterFlowTheme.of(context).primary,
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: filteredNews.length,
                              itemBuilder: (context, index) {
                                return _buildNewsItem(filteredNews[index]);
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(NewForceArticlesRow originalArticle) {
    if (originalArticle.data == null) {
      return SizedBox.shrink();
    }

    final article = SafeNewForceArticlesRow(originalArticle.data);
    final String imageUrl = article.articeImage ?? '';
    final bool hasValidImage =
        imageUrl.isNotEmpty && !imageUrl.contains('null');
    final String country =
        article.getField<String>('country') ?? 'General Africa';

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      child: InkWell(
        onTap: () async {
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
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                        if (country != 'General Africa') ...[
                          SizedBox(width: 8.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              country,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      () {
                        try {
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
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? 'No Title',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Text(
                        article.description ?? 'No description available',
                        maxLines: 3,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: 13.0,
                    
                        ),
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
  }
}
