import 'dart:async';
import 'package:flutter/foundation.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';
import 'news_scraper_service.dart';

class NewsProvider extends ChangeNotifier {
  List<NewForceArticlesRow> _africanNews = [];
  List<FeedYourCuriosityTopicsRow> _feedYourCuriosityNews = [];

  Map<String, List<NewForceArticlesRow>> _newsByCountry = {
    'Nigeria': [],
    'Kenya': [],
    'South Africa': [],
    'Ethiopia': [],
    'Ghana': [],
    'General Africa': [],
  };

  bool _isLoadingAfrican = false;
  bool _isLoadingFeedYourCuriosity = false;
  String _errorMessage = '';

  static const int _cacheExpirationHours = 2; // Reduced from 24 to 2 hours

  DateTime? _lastAfricanNewsFetch;
  DateTime? _lastFeedYourCuriosityFetch;

  List<NewForceArticlesRow> get africanNews => _africanNews;
  List<FeedYourCuriosityTopicsRow> get feedYourCuriosityNews =>
      _feedYourCuriosityNews;
  Map<String, List<NewForceArticlesRow>> get newsByCountry => _newsByCountry;

  bool get isLoading => _isLoadingAfrican || _isLoadingFeedYourCuriosity;
  bool get isLoadingAfrican => _isLoadingAfrican;
  bool get isLoadingFeedYourCuriosity => _isLoadingFeedYourCuriosity;

  String get errorMessage => _errorMessage;

  List<NewForceArticlesRow> getNewsByCountry(String country) {
    return _newsByCountry[country] ?? [];
  }

  Future<void> fetchAllNews({bool force = false}) async {
    final needsAfrican = force ||
        _africanNews.isEmpty ||
        _shouldRefreshCache(_lastAfricanNewsFetch);
    final needsFeedYourCuriosity = force ||
        _feedYourCuriosityNews.isEmpty ||
        _shouldRefreshCache(_lastFeedYourCuriosityFetch);

    final futures = <Future>[];

    if (needsAfrican) {
      futures.add(fetchAfricanNews(forceRefresh: force));
    }

    if (needsFeedYourCuriosity) {
      futures.add(fetchFeedYourCuriosity(forceRefresh: force));
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    } else {
      print('Using cached news data for all sources');
    }
  }

  bool _shouldRefreshCache(DateTime? lastFetch) {
    if (lastFetch == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastFetch).inHours;
    return difference >= _cacheExpirationHours;
  }

  Future<List<NewForceArticlesRow>> _loadCachedNews(String? country) async {
    try {
      final table = NewForceArticlesTable();
      final yesterday =
          DateTime.now().subtract(Duration(hours: _cacheExpirationHours));

      var query = table.queryRows(
        queryFn: (q) => q
            .gt('created_at', yesterday.toIso8601String())
            .order('created_at', ascending: false),
      );

      if (country != null && country != 'General Africa') {
        query = table.queryRows(
          queryFn: (q) => q
              .eq('country', country)
              .gt('created_at', yesterday.toIso8601String())
              .order('created_at', ascending: false),
        );
      }

      final cachedArticles = await query;

      print('Found ${cachedArticles.length} cached African news articles');
      return cachedArticles;
    } catch (e) {
      print('Error loading cached African news: $e');
      return [];
    }
  }

  Future<void> fetchAfricanNews({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _lastAfricanNewsFetch = null;
    }

    if (!forceRefresh &&
        _africanNews.isNotEmpty &&
        !_shouldRefreshCache(_lastAfricanNewsFetch)) {
      print('Using in-memory African articles');
      return;
    }

    _isLoadingAfrican = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final cachedArticles = await _loadCachedNews(null);

      if (cachedArticles.isNotEmpty) {
        print('Using cached African articles from database');
        _africanNews = cachedArticles;
        _categorizeNews();
        _lastAfricanNewsFetch = DateTime.now();
      } else {
        print('Fetching fresh African articles');

        // Test categorization before scraping
        NewsScraperService.testCategorization();

        final scrapedNews = await NewsScraperService.scrapeAfricaNews();
        _africanNews =
            NewsScraperService.convertToNewForceArticles(scrapedNews);

        await _saveNewsToDatabase(_africanNews);
        _categorizeNews();
        _lastAfricanNewsFetch = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'Failed to load African news: $e';
      print(_errorMessage);

      if (_africanNews.isEmpty) {
        try {
          final fallbackNews = NewsScraperService.getFallbackAfricanNews();
          _africanNews =
              NewsScraperService.convertToNewForceArticles(fallbackNews);
          _categorizeNews();
        } catch (fallbackError) {
          print('Failed to load fallback African news: $fallbackError');
        }
      }
    } finally {
      _isLoadingAfrican = false;
      notifyListeners();
    }
  }

  void _categorizeNews() {
    _newsByCountry = {
      'Nigeria': [],
      'Kenya': [],
      'South Africa': [],
      'Ethiopia': [],
      'Ghana': [],
      'General Africa': [],
    };

    print('🏁 Starting news categorization...');

    for (final article in _africanNews) {
      final title = article.getField<String>('title') ?? 'No Title';
      final description = article.getField<String>('description') ?? '';

      // Re-categorize using current algorithm instead of stored country
      final country =
          NewsScraperService.categorizeByCountry(title, description);

      // Update the article's country field
      article.setField('country', country);

      if (_newsByCountry.containsKey(country)) {
        _newsByCountry[country]!.add(article);
      } else {
        print('❌ Unknown country: $country, adding to General Africa');
        _newsByCountry['General Africa']!.add(article);
      }
    }

    final categoryCounts = _newsByCountry.map((k, v) => MapEntry(k, v.length));
    print('📊 Final categorization: $categoryCounts');

    // Print some examples
    _newsByCountry.forEach((country, articles) {
      if (articles.isNotEmpty) {
        print('🏷️ $country examples:');
        for (int i = 0; i < (articles.length > 2 ? 2 : articles.length); i++) {
          final title = articles[i].getField<String>('title') ?? 'No Title';
          print('   • $title');
        }
      }
    });

    print('✅ Categorization complete\n');
  }

  Future<void> _saveNewsToDatabase(List<NewForceArticlesRow> articles) async {
    try {
      final table = NewForceArticlesTable();

      for (final article in articles) {
        final existingArticles = await table.queryRows(
          queryFn: (q) => q.eq('title', article.title ?? ''),
        );

        if (existingArticles.isEmpty) {
          final Map<String, dynamic> articleData = article.data;
          await table.insert(articleData);
        }
      }
    } catch (e) {
      print('Error saving articles to database: $e');
    }
  }

  Future<List<FeedYourCuriosityTopicsRow>>
      _loadCachedFeedYourCuriosityTopics() async {
    try {
      final table = FeedYourCuriosityTopicsTable();
      final yesterday =
          DateTime.now().subtract(Duration(hours: _cacheExpirationHours));

      final cachedTopics = await table.queryRows(
        queryFn: (q) => q
            .gt('created_at', yesterday.toIso8601String())
            .order('created_at', ascending: false),
      );

      print('Found ${cachedTopics.length} cached Feed Your Curiosity topics');
      return cachedTopics;
    } catch (e) {
      print('Error loading cached Feed Your Curiosity topics: $e');
      return [];
    }
  }

  Future<void> _saveFeedYourCuriosityTopicsToDatabase(
      List<FeedYourCuriosityTopicsRow> topics) async {
    try {
      final table = FeedYourCuriosityTopicsTable();

      for (final topic in topics) {
        final existingTopics = await table.queryRows(
          queryFn: (q) => q.eq('title', topic.title ?? ''),
        );

        if (existingTopics.isEmpty) {
          final Map<String, dynamic> topicData = topic.data;
          await table.insert(topicData);
        }
      }
    } catch (e) {
      print('Error saving Feed Your Curiosity topics to database: $e');
    }
  }

  Future<void> fetchFeedYourCuriosity({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _lastFeedYourCuriosityFetch = null;
    }

    if (!forceRefresh &&
        _feedYourCuriosityNews.isNotEmpty &&
        !_shouldRefreshCache(_lastFeedYourCuriosityFetch)) {
      print('Using in-memory Feed Your Curiosity topics');
      return;
    }

    _isLoadingFeedYourCuriosity = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final cachedTopics = await _loadCachedFeedYourCuriosityTopics();

      if (cachedTopics.isNotEmpty) {
        print('Using cached Feed Your Curiosity topics from database');
        _feedYourCuriosityNews = cachedTopics;
        _lastFeedYourCuriosityFetch = DateTime.now();
      } else {
        print('Fetching fresh Feed Your Curiosity topics');
        final scrapedNews = await NewsScraperService.scrapeFeedYourCuriosity();
        _feedYourCuriosityNews =
            NewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);

        await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);
        _lastFeedYourCuriosityFetch = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'Failed to load Feed Your Curiosity topics: $e';
      print(_errorMessage);

      if (_feedYourCuriosityNews.isEmpty) {
        try {
          final fallbackNews =
              NewsScraperService.getFallbackFeedYourCuriosityNews();
          _feedYourCuriosityNews =
              NewsScraperService.convertToFeedYourCuriosityTopics(fallbackNews);
        } catch (fallbackError) {
          print(
              'Failed to load fallback Feed Your Curiosity topics: $fallbackError');
        }
      }
    } finally {
      _isLoadingFeedYourCuriosity = false;
      notifyListeners();
    }
  }

  // Legacy getters for backward compatibility
  List<NewForceArticlesRow> get ghanaWebNews => getNewsByCountry('Ghana');
  List<NewForceArticlesRow> get panAfricanNews => _africanNews;
  bool get isLoadingGhanaWeb => _isLoadingAfrican;
  bool get isLoadingPanAfrican => _isLoadingAfrican;

  // Force re-categorization of existing articles
  Future<void> reCategorizeExistingArticles() async {
    print('🔄 Starting re-categorization of existing articles...');

    if (_africanNews.isNotEmpty) {
      print('📰 Re-categorizing ${_africanNews.length} cached articles...');
      _categorizeNews();

      // Update the database with new categorizations
      try {
        final table = NewForceArticlesTable();
        for (final article in _africanNews) {
          final id = article.getField<int>('id');
          final newCountry = article.getField<String>('country');

          if (id != null && newCountry != null) {
            await table.update(
              data: {'country': newCountry},
              matchingRows: (q) => q.eq('id', id),
            );
          }
        }
        print('✅ Database updated with new categorizations');
      } catch (e) {
        print('❌ Error updating database: $e');
      }

      notifyListeners();
    } else {
      print('❌ No articles to re-categorize');
    }
  }

  // Debug method to manually test categorization
  void testCategorizationNow() {
    print('\n🔍 TESTING CATEGORIZATION...');
    NewsScraperService.testCategorization();

    // Test with fallback data
    final fallbackNews = NewsScraperService.getFallbackAfricanNews();
    print('\n📰 TESTING WITH FALLBACK DATA:');

    for (final article in fallbackNews) {
      final title = article['title'] ?? '';
      final description = article['description'] ?? '';
      final expectedCountry = article['country'] ?? '';
      final actualCountry =
          NewsScraperService.categorizeByCountry(title, description);

      print('Title: $title');
      print('Expected: $expectedCountry | Actual: $actualCountry');
      print('✓ Match: ${expectedCountry == actualCountry}');
      print('---');
    }
    print('🔍 CATEGORIZATION TEST COMPLETE\n');
  }
}
