import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/backend/supabase/supabase.dart';
import '/backend/scrapers/news_provider.dart';
import '/backend/scrapers/news_scraper_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'feedyour_curiosity_topics_model.dart';

export 'feedyour_curiosity_topics_model.dart';

/// Widget for displaying Feed Your Curiosity articles filtered by tag
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
    
    // Fetch articles after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchArticles(forceRefresh: false);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Fetch articles from the news provider
  void _fetchArticles({required bool forceRefresh}) {
    final newsProvider = Provider.of<EnhancedNewsProvider>(context, listen: false);
    newsProvider.fetchFeedYourCuriosity(forceRefresh: forceRefresh);
  }

  /// Handle refresh action
  Future<void> _onRefresh() async {
    _fetchArticles(forceRefresh: true);
  }

  /// Navigate to article details page
  void _navigateToArticleDetails(Map<String, dynamic> article) {
    context.pushNamed(
      'feedYourCuriosityArticleDetails',
      queryParameters: {
        'publisherImage': serializeParam(
          article['image'],
          ParamType.String,
        ),
        'publisher': serializeParam(
          article['publishers'],
          ParamType.String,
        ),
        'dateCreated': serializeParam(
          DateTime.tryParse(article['created_at'] ?? '') ?? DateTime.now(),
          ParamType.DateTime,
        ),
        'articleImage': serializeParam(
          article['image'],
          ParamType.String,
        ),
        'description': serializeParam(
          article['description'],
          ParamType.String,
        ),
        'tag': serializeParam(
          article['tag'],
          ParamType.String,
        ),
        'newsbody': serializeParam(
          article['content'],
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
  }

  /// Navigate to database article details page
  void _navigateToDbArticleDetails(FeedYourCuriosityTopicsRow article) {
    context.pushNamed(
      'feedYourCuriosityArticleDetails',
      queryParameters: {
        'publisherImage': serializeParam(
          article.publisherImageUrl,
          ParamType.String,
        ),
        'publisher': serializeParam(
          article.publisher,
          ParamType.String,
        ),
        'dateCreated': serializeParam(
          article.createdAt,
          ParamType.DateTime,
        ),
        'articleImage': serializeParam(
          article.image,
          ParamType.String,
        ),
        'description': serializeParam(
          article.newsDescription,
          ParamType.String,
        ),
        'tag': serializeParam(
          article.tag,
          ParamType.String,
        ),
        'newsbody': serializeParam(
          article.newsBody,
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
  }

  /// Share article content
  void _shareArticle(String title, String description) {
    Share.share('$title\n\n$description');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArticlesList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          onPressed: () => context.safePop(),
        ),
        title: Text(
          widget.tag ?? 'Articles',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'SFPro',
            color: Colors.white,
            fontSize: 22.0,
            letterSpacing: 0.0,
            useGoogleFonts: false,
          ),
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
    );
  }

  /// Build the articles list with loading and error states
  Widget _buildArticlesList() {
    return Consumer<EnhancedNewsProvider>(
      builder: (context, newsProvider, _) {
        final allArticles = newsProvider.feedYourCuriosityNews;
        // Filter articles by tag with enhanced matching
        final filteredArticles = _filterDatabaseArticles(allArticles, widget.tag);
        
        // Always get fallback articles for consistent display
        final fallbackData = EnhancedNewsScraperService.getFallbackFeedYourCuriosityNews();
        final fallbackFiltered = _filterFallbackArticles(fallbackData);

        _debugPrintArticleInfo(allArticles, filteredArticles);

        // Show loading state with fallback articles
        if (newsProvider.isLoadingFeedYourCuriosity) {
          return _buildLoadingState();
        }

        // Prioritize fallback articles over database articles
        if (fallbackFiltered.isNotEmpty) {
          return _buildFallbackArticlesList(fallbackFiltered);
        }
        
        // Show database articles as backup if no fallback articles found
        if (filteredArticles.isNotEmpty) {
          return _buildArticlesListView(filteredArticles);
        }
        
        // Only show empty state if both fallback and database articles are empty
        return _buildEmptyState(allArticles, newsProvider);
      },
    );
  }

  /// Build loading state with fallback articles
  Widget _buildLoadingState() {
    final fallbackData = EnhancedNewsScraperService.getFallbackFeedYourCuriosityNews();
    final fallbackFiltered = _filterFallbackArticles(fallbackData);

    return Column(
      children: [
        _buildLoadingIndicator(),
        if (fallbackFiltered.isNotEmpty)
          _buildFallbackArticlesList(fallbackFiltered)
        else
          _buildSimpleLoadingMessage(),
      ],
    );
  }

  /// Filter fallback articles based on tag with flexible matching
  List<Map<String, dynamic>> _filterFallbackArticles(List<Map<String, dynamic>> articles) {
    if (widget.tag == null) return articles.take(6).toList();
    
    final tagLower = widget.tag!.toLowerCase();
    
    // Enhanced tag mappings for specific matches - each topic should only show its relevant articles
    final tagMappings = {
      // General African topics - show mix only for very general searches
      'africa': ['african culture & lifestyle', 'african agriculture', 'african technology'],
      'african': ['african culture & lifestyle', 'african agriculture', 'african technology'],
      
      // Culture & Lifestyle specific
      'african culture & lifestyle': ['african culture & lifestyle'],
      'culture': ['african culture & lifestyle'],
      'lifestyle': ['african culture & lifestyle'],
      'tradition': ['african culture & lifestyle'],
      'music': ['african culture & lifestyle'],
      'art': ['african culture & lifestyle'],
      'fashion': ['african culture & lifestyle'],
      'wedding': ['african culture & lifestyle'],
      'storytelling': ['african culture & lifestyle'],
      'languages': ['african culture & lifestyle'],
      'cuisine': ['african culture & lifestyle'],
      'food': ['african culture & lifestyle'], // Food is primarily cultural
      
      // Agriculture specific
      'african agriculture': ['african agriculture'],
      'agriculture': ['african agriculture'],
      'farming': ['african agriculture'],
      'crops': ['african agriculture'],
      'climate': ['african agriculture'],
      'urban farming': ['african agriculture'],
      'grains': ['african agriculture'],
      'precision agriculture': ['african agriculture'],
      'aquaculture': ['african agriculture'],
      'agroforestry': ['african agriculture'],
      'sustainable': ['african agriculture'], // Primarily agricultural context
      
      // Technology specific
      'african technology': ['african technology'],
      'technology': ['african technology'],
      'tech': ['african technology'],
      'innovation': ['african technology'],
      'digital': ['african technology'],
      'mobile': ['african technology'],
      'fintech': ['african technology'],
      'startup': ['african technology'],
      'mobile money': ['african technology'],
      'solar': ['african technology'],
      'ai': ['african technology'],
      'blockchain': ['african technology'],
      'edtech': ['african technology'],
      'healthtech': ['african technology'],
      
      // Cross-category terms (only for very specific cases)
      'business': ['african agriculture', 'african technology'], // Business spans both
      'women': ['african agriculture'], // Women in agriculture context
    };
    
    List<Map<String, dynamic>> filtered = [];
    
    // Debug: Print what we're looking for
    print('DEBUG: Filtering fallback articles for tag: $tagLower');
    print('DEBUG: Available fallback articles: ${articles.length}');
    for (int i = 0; i < articles.length && i < 3; i++) {
      print('DEBUG: Article $i tag: "${articles[i]['tag']}" title: "${articles[i]['title']}"');
    }
    
    // 1. Try exact tag mapping first
    if (tagMappings.containsKey(tagLower)) {
      final mappedTags = tagMappings[tagLower]!;
      print('DEBUG: Using mapped tags: $mappedTags');
      
      filtered = articles.where((article) {
        final articleTagLower = article['tag']?.toString().toLowerCase() ?? '';
        final matches = mappedTags.contains(articleTagLower);
        if (matches) {
          print('DEBUG: MATCH found - Article tag: "$articleTagLower" matches mapped tags');
        }
        return matches;
      }).toList();
      
      print('DEBUG: After tag mapping, filtered count: ${filtered.length}');
    }
    
    // 2. Try partial matching if no exact mapping
    if (filtered.isEmpty) {
      print('DEBUG: Trying partial matching...');
      filtered = articles.where((article) {
        final articleTag = article['tag']?.toString().toLowerCase() ?? '';
        final matches = articleTag.contains(tagLower) || tagLower.contains(articleTag);
        if (matches) {
          print('DEBUG: PARTIAL MATCH - Article tag: "$articleTag" with search: "$tagLower"');
        }
        return matches;
      }).toList();
      print('DEBUG: After partial matching, filtered count: ${filtered.length}');
    }
    
    // 3. Try keyword matching
    if (filtered.isEmpty) {
      print('DEBUG: Trying keyword matching...');
      final keywords = tagLower.split(' ');
      filtered = articles.where((article) {
        final articleTag = article['tag']?.toString().toLowerCase() ?? '';
        final articleTitle = article['title']?.toString().toLowerCase() ?? '';
        final articleDesc = article['description']?.toString().toLowerCase() ?? '';
        return keywords.any((keyword) => 
          keyword.length > 2 && (
            articleTag.contains(keyword) ||
            articleTitle.contains(keyword) ||
            articleDesc.contains(keyword)
          )
        );
      }).toList();
      print('DEBUG: After keyword matching, filtered count: ${filtered.length}');
    }
    
    // 4. Fallback: distribute articles from each category
    if (filtered.isEmpty) {
      print('DEBUG: Using fallback distribution...');
      final categories = ['african culture & lifestyle', 'african agriculture', 'african technology'];
      for (final category in categories) {
        final categoryArticles = articles.where((article) => 
          article['tag']?.toString().toLowerCase() == category
        ).take(2).toList();
        filtered.addAll(categoryArticles);
        print('DEBUG: Added ${categoryArticles.length} articles from category: $category');
      }
    }
    
    print('DEBUG: Final filtered count: ${filtered.length}');
    for (int i = 0; i < filtered.length && i < 3; i++) {
      print('DEBUG: Final $i: "${filtered[i]['tag']}" - "${filtered[i]['title']}"');
    }
    
    return filtered.take(6).toList();
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: SpinKitRipple(
              color: FlutterFlowTheme.of(context).primary,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Loading latest articles...',
            style: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'SFPro',
              color: FlutterFlowTheme.of(context).secondaryText,
              useGoogleFonts: false,
            ),
          ),
        ],
      ),
    );
  }

  /// Build simple loading message when no fallback articles
  Widget _buildSimpleLoadingMessage() {
    return Center(
      child: Text(
        'Fetching articles for ${widget.tag}...',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'SFPro',
          color: FlutterFlowTheme.of(context).secondaryText,
          useGoogleFonts: false,
        ),
      ),
    );
  }

  /// Build fallback articles list
  Widget _buildFallbackArticlesList(List<Map<String, dynamic>> fallbackArticles) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.0),
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fallbackArticles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 1.0),
      itemBuilder: (context, index) {
        final article = fallbackArticles[index];
        return _buildFallbackArticleCard(article);
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(List<FeedYourCuriosityTopicsRow> allArticles, EnhancedNewsProvider newsProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'No articles found for ${widget.tag}.',
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
              onPressed: () => _fetchArticles(forceRefresh: true),
              child: const Text('Force Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build articles list view
  Widget _buildArticlesListView(List<FeedYourCuriosityTopicsRow> articles) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 1.0),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(article);
      },
    );
  }

  /// Build fallback article card
  Widget _buildFallbackArticleCard(Map<String, dynamic> article) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _navigateToArticleDetails(article),
        child: _buildArticleContainer(
          imageUrl: article['image'] ?? '',
          title: article['title'] ?? 'No Title',
          description: (article['description'] ?? 'No description available')
              .toString()
              .maybeHandleOverflow(maxChars: 100, replacement: '…'),
          timeText: 'Just now',
          onShare: () => _shareArticle(
            article['title'] ?? '',
            article['description'] ?? '',
          ),
        ),
      ),
    );
  }

  /// Build database article card
  Widget _buildArticleCard(FeedYourCuriosityTopicsRow article) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _navigateToDbArticleDetails(article),
        child: _buildArticleContainer(
          imageUrl: article.image ?? '',
          title: article.newsDescription ?? 'No Title',
          description: (article.newsDescription ?? 'No description available')
              .maybeHandleOverflow(maxChars: 100, replacement: '…'),
          timeText: dateTimeFormat('relative', article.createdAt),
          onShare: () => _shareArticle(
            article.newsDescription ?? '',
            article.newsDescription ?? '',
          ),
        ),
      ),
    );
  }

  /// Build reusable article container
  Widget _buildArticleContainer({
    required String imageUrl,
    required String title,
    required String description,
    required String timeText,
    required VoidCallback onShare,
  }) {
    return Container(
      width: 350.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x2B202529),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildArticleContent(imageUrl, title, description),
            _buildArticleFooter(timeText, onShare),
          ],
        ),
      ),
    );
  }

  /// Build article content (image and text)
  Widget _buildArticleContent(String imageUrl, String title, String description) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleImage(imageUrl),
          const SizedBox(width: 5.0),
          Flexible(
            child: _buildArticleText(title, description),
          ),
        ],
      ),
    );
  }

  /// Build article image with loading and error states
  Widget _buildArticleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 151.0,
        height: 143.0,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/app_launcher_icon.png',
          width: 151.0,
          height: 143.0,
          fit: BoxFit.cover,
        ),
        placeholder: (context, url) => Container(
          width: 151.0,
          height: 143.0,
          color: FlutterFlowTheme.of(context).secondaryBackground,
          child: Center(
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: SpinKitRipple(
                color: FlutterFlowTheme.of(context).primary,
                size: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build article text content
  Widget _buildArticleText(String title, String description) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 0.0, 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
            child: Text(
              title,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'SFPro',
                fontSize: 15.0,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              description,
              maxLines: 4,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                fontFamily: 'SFPro',
                fontSize: 13.0,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build article footer with time and share button
  Widget _buildArticleFooter(String timeText, VoidCallback onShare) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(2.0, 8.0, 8.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 16.0,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                child: Text(
                  timeText,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'SFPro',
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onShare,
            child: Icon(
              Icons.share,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  /// Filter database articles with enhanced matching logic
  List<FeedYourCuriosityTopicsRow> _filterDatabaseArticles(
    List<FeedYourCuriosityTopicsRow> articles,
    String? tag,
  ) {
    if (tag == null || tag.isEmpty) return articles;
    
    final tagLower = tag.toLowerCase().trim();
    
    print('DEBUG: _filterDatabaseArticles called with tag: "$tagLower"');
    print('DEBUG: Total articles to filter: ${articles.length}');
    
    // Enhanced tag mappings for database articles - updated to match actual fallback article tags
    final tagMappings = {
      'africa': ['african culture & lifestyle', 'african agriculture', 'african technology'],
      'african': ['african culture & lifestyle', 'african agriculture', 'african technology'],
      'culture': ['african culture & lifestyle'],
      'lifestyle': ['african culture & lifestyle'],
      'agriculture': ['african agriculture'],
      'farming': ['african agriculture'],
      'technology': ['african technology'],
      'tech': ['african technology'],
      'business': ['african agriculture', 'african technology'],
      'innovation': ['african technology'],
      'tradition': ['african culture & lifestyle'],
      'food': ['african culture & lifestyle', 'african agriculture'],
      'music': ['african culture & lifestyle'],
      'art': ['african culture & lifestyle'],
      'fashion': ['african culture & lifestyle'],
      'digital': ['african technology'],
      'mobile': ['african technology'],
      'fintech': ['african technology'],
      'startup': ['african technology'],
      'crops': ['african agriculture'],
      'climate': ['african agriculture'],
      'sustainable': ['african agriculture', 'african technology'],
      'wedding': ['african culture & lifestyle'],
      'storytelling': ['african culture & lifestyle'],
      'languages': ['african culture & lifestyle'],
      'cuisine': ['african culture & lifestyle'],
      'urban farming': ['african agriculture'],
      'grains': ['african agriculture'],
      'precision agriculture': ['african agriculture'],
      'women': ['african agriculture'],
      'aquaculture': ['african agriculture'],
      'agroforestry': ['african agriculture'],
      'mobile money': ['african technology'],
      'solar': ['african technology'],
      'ai': ['african technology'],
      'blockchain': ['african technology'],
      'edtech': ['african technology'],
      'healthtech': ['african technology'],
      // Add more specific mappings
      'african culture & lifestyle': ['african culture & lifestyle'],
      'african agriculture': ['african agriculture'],
      'african technology': ['african technology'],
    };
    
    List<FeedYourCuriosityTopicsRow> filtered = [];
    
    // Print available article tags for debugging
    if (articles.isNotEmpty) {
      print('DEBUG: Available article tags:');
      final uniqueTags = articles.map((a) => a.tag?.toLowerCase()?.trim()).where((t) => t != null).toSet();
      for (final availableTag in uniqueTags) {
        print('DEBUG:   - "$availableTag"');
      }
    }
    
    // 1. Try exact match first
    filtered = articles.where((article) {
      final articleTagLower = article.tag?.toLowerCase()?.trim();
      final matches = articleTagLower == tagLower;
      if (matches) {
        print('DEBUG: EXACT MATCH found - Article tag: "$articleTagLower" == search tag: "$tagLower"');
      }
      return matches;
    }).toList();
    
    print('DEBUG: After exact match, filtered count: ${filtered.length}');
    
    // 2. Try mapped tags
    if (filtered.isEmpty && tagMappings.containsKey(tagLower)) {
      final mappedTags = tagMappings[tagLower]!;
      print('DEBUG: Using mapped tags for "$tagLower": $mappedTags');
      
      filtered = articles.where((article) {
        final articleTagLower = article.tag?.toLowerCase()?.trim();
        final matches = mappedTags.contains(articleTagLower);
        if (matches) {
          print('DEBUG: MAPPED MATCH found - Article tag: "$articleTagLower" in mapped tags: $mappedTags');
        }
        return matches;
      }).toList();
    }
    
    print('DEBUG: After mapped tags, filtered count: ${filtered.length}');
    
    // 3. Try partial matching
    if (filtered.isEmpty) {
      print('DEBUG: Trying partial matching...');
      filtered = articles.where((article) {
        final articleTag = article.tag?.toLowerCase()?.trim() ?? '';
        final matches = articleTag.contains(tagLower) || tagLower.contains(articleTag);
        if (matches) {
          print('DEBUG: PARTIAL MATCH found - Article tag: "$articleTag" with search: "$tagLower"');
        }
        return matches;
      }).toList();
    }
    
    print('DEBUG: After partial matching, filtered count: ${filtered.length}');
    
    // 4. Try keyword matching with title and description
    if (filtered.isEmpty) {
      print('DEBUG: Trying keyword matching...');
      final keywords = tagLower.split(' ').where((k) => k.length > 2).toList();
      print('DEBUG: Keywords to search: $keywords');
      
      filtered = articles.where((article) {
        final articleTag = article.tag?.toLowerCase()?.trim() ?? '';
        final articleTitle = article.title?.toLowerCase()?.trim() ?? '';
        final articleDesc = article.newsDescription?.toLowerCase()?.trim() ?? '';
        
        final matches = keywords.any((keyword) => 
          articleTag.contains(keyword) ||
          articleTitle.contains(keyword) ||
          articleDesc.contains(keyword)
        );
        
        if (matches) {
          print('DEBUG: KEYWORD MATCH found - Article: "$articleTag" / "$articleTitle"');
        }
        
        return matches;
      }).toList();
    }
    
    print('DEBUG: Final filtered count: ${filtered.length}');
    
    return filtered;
  }

  /// Debug print article information
  void _debugPrintArticleInfo(
    List<FeedYourCuriosityTopicsRow> allArticles,
    List<FeedYourCuriosityTopicsRow> filteredArticles,
  ) {
    print('DEBUG: Total articles: ${allArticles.length}');
    print('DEBUG: Looking for tag: ${widget.tag}');
    print('DEBUG: Filtered articles: ${filteredArticles.length}');

    if (allArticles.isNotEmpty) {
      print('DEBUG: Available tags: ${allArticles.map((a) => a.tag).toSet().toList()}');
      for (int i = 0; i < allArticles.length && i < 5; i++) {
        print('DEBUG: Article $i tag: ${allArticles[i].tag}');
      }
    }
    
    if (filteredArticles.isNotEmpty) {
      print('DEBUG: Filtered article tags: ${filteredArticles.map((a) => a.tag).toList()}');
      for (int i = 0; i < filteredArticles.length && i < 5; i++) {
        print('DEBUG: Filtered $i: ${filteredArticles[i].tag} - ${filteredArticles[i].title}');
      }
    }
    
    // Additional debug for fallback articles
    if (filteredArticles.isEmpty) {
      final fallbackData = EnhancedNewsScraperService.getFallbackFeedYourCuriosityNews();
      final fallbackFiltered = _filterFallbackArticles(fallbackData);
      print('DEBUG: Fallback articles available: ${fallbackData.length}');
      print('DEBUG: Fallback articles filtered: ${fallbackFiltered.length}');
      for (int i = 0; i < fallbackFiltered.length && i < 3; i++) {
        print('DEBUG: Fallback $i: ${fallbackFiltered[i]['tag']} - ${fallbackFiltered[i]['title']}');
      }
    }
  }
}