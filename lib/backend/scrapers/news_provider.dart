import 'dart:async';
import 'package:flutter/foundation.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';
import 'news_scraper_service.dart';

/// A provider class for managing news data from various sources
class NewsProvider extends ChangeNotifier {
  List<NewForceArticlesRow> _ghanaWebNews = [];
  List<NewForceArticlesRow> _panAfricanNews = [];
  List<FeedYourCuriosityTopicsRow> _feedYourCuriosityNews = [];
  bool _isLoadingGhanaWeb = false;
  bool _isLoadingPanAfrican = false;
  bool _isLoadingFeedYourCuriosity = false;
  String _errorMessage = '';

  // Cache expiration time in hours
  static const int _cacheExpirationHours = 24;

  // Last fetch timestamps
  DateTime? _lastGhanaWebFetch;
  DateTime? _lastPanAfricanFetch;
  DateTime? _lastFeedYourCuriosityFetch;

  /// Get the list of GhanaWeb news articles
  List<NewForceArticlesRow> get ghanaWebNews => _ghanaWebNews;

  /// Get the list of Pan African news articles
  List<NewForceArticlesRow> get panAfricanNews => _panAfricanNews;

  /// Get the list of Feed Your Curiosity articles
  List<FeedYourCuriosityTopicsRow> get feedYourCuriosityNews =>
      _feedYourCuriosityNews;

  /// Check if any news source is currently loading
  bool get isLoading =>
      _isLoadingGhanaWeb || _isLoadingPanAfrican || _isLoadingFeedYourCuriosity;

  /// Check if GhanaWeb news is loading
  bool get isLoadingGhanaWeb => _isLoadingGhanaWeb;

  /// Check if Pan African news is loading
  bool get isLoadingPanAfrican => _isLoadingPanAfrican;

  /// Check if Feed Your Curiosity news is loading
  bool get isLoadingFeedYourCuriosity => _isLoadingFeedYourCuriosity;

  /// Get any error message
  String get errorMessage => _errorMessage;

  /// Load news from database only without scraping websites
  Future<void> loadCachedNewsOnly() async {
    _isLoadingGhanaWeb = true;
    _isLoadingPanAfrican = true;
    _isLoadingFeedYourCuriosity = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Load GhanaWeb news from database
      final ghanaWebArticles = await _loadCachedNews('GhanaWeb');
      _ghanaWebNews = ghanaWebArticles;

      // Load Pan African news from database
      final panAfricanArticles = await _loadCachedNews('Pan African Visions');
      _panAfricanNews = panAfricanArticles;

      // Load Feed Your Curiosity news from database
      final feedYourCuriosityTopics =
          await _loadCachedFeedYourCuriosityTopics();
      _feedYourCuriosityNews = feedYourCuriosityTopics;

      // Update last fetch times to now
      _lastGhanaWebFetch = DateTime.now();
      _lastPanAfricanFetch = DateTime.now();
      _lastFeedYourCuriosityFetch = DateTime.now();
    } catch (e) {
      _errorMessage = 'Failed to load news from database: $e';
      print(_errorMessage);
    } finally {
      _isLoadingGhanaWeb = false;
      _isLoadingPanAfrican = false;
      _isLoadingFeedYourCuriosity = false;
      notifyListeners();
    }
  }

  /// Fetch news from all sources
  /// If force is true, it will fetch fresh data regardless of cache status
  Future<void> fetchAllNews({bool force = false}) async {
    // Determine which sources need fetching
    // If force is true, fetch all sources regardless of cache status
    final needsGhanaWeb = force ||
        _ghanaWebNews.isEmpty ||
        _shouldRefreshCache(_lastGhanaWebFetch);
    final needsPanAfrican = force ||
        _panAfricanNews.isEmpty ||
        _shouldRefreshCache(_lastPanAfricanFetch);
    final needsFeedYourCuriosity = force ||
        _feedYourCuriosityNews.isEmpty ||
        _shouldRefreshCache(_lastFeedYourCuriosityFetch);

    // Create a list of futures to run in parallel
    final futures = <Future>[];

    if (needsGhanaWeb) {
      futures.add(fetchGhanaWebNews(forceRefresh: force));
    }

    if (needsPanAfrican) {
      futures.add(fetchPanAfricanNews(forceRefresh: force));
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

  /// Check if we need to refresh the cache
  bool _shouldRefreshCache(DateTime? lastFetch) {
    if (lastFetch == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastFetch).inHours;
    return difference >= _cacheExpirationHours;
  }

  /// Load cached news from database
  Future<List<NewForceArticlesRow>> _loadCachedNews(String publisher) async {
    try {
      final table = NewForceArticlesTable();
      final yesterday =
          DateTime.now().subtract(Duration(hours: _cacheExpirationHours));

      // Query for recent articles from this publisher
      final cachedArticles = await table.queryRows(
        queryFn: (q) => q
            .eq('publishers', publisher)
            .gt('created_at', yesterday.toIso8601String())
            .order('created_at', ascending: false),
      );

      print('Found ${cachedArticles.length} cached $publisher articles');
      return cachedArticles;
    } catch (e) {
      print('Error loading cached $publisher news: $e');
      return [];
    }
  }

  /// Fetch news from GhanaWeb
  /// If forceRefresh is true, it will fetch fresh data regardless of cache status
  Future<void> fetchGhanaWebNews({bool forceRefresh = false}) async {
    // If forcing refresh, reset last fetch time
    if (forceRefresh) {
      _lastGhanaWebFetch = null;
    }

    // If we already have data and it's not expired, don't fetch again
    if (!forceRefresh &&
        _ghanaWebNews.isNotEmpty &&
        !_shouldRefreshCache(_lastGhanaWebFetch)) {
      print('Using in-memory GhanaWeb articles');
      return;
    }

    _isLoadingGhanaWeb = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // If forceRefresh is true, always scrape fresh data
      if (forceRefresh) {
        print('Force refreshing: Fetching fresh GhanaWeb articles');
        final scrapedNews = await NewsScraperService.scrapeGhanaWeb();
        _ghanaWebNews =
            NewsScraperService.convertToNewForceArticles(scrapedNews);

        // Save to database
        await _saveNewsToDatabase(_ghanaWebNews);

        // Update last fetch time
        _lastGhanaWebFetch = DateTime.now();
      } else {
        // Check if we have recent cached articles in the database
        final cachedArticles = await _loadCachedNews('GhanaWeb');

        if (cachedArticles.isNotEmpty) {
          print('Using cached GhanaWeb articles from database');
          _ghanaWebNews = cachedArticles;
          // Update last fetch time to reflect when we loaded from cache
          _lastGhanaWebFetch = DateTime.now();
        } else {
          print('Fetching fresh GhanaWeb articles');
          final scrapedNews = await NewsScraperService.scrapeGhanaWeb();
          _ghanaWebNews =
              NewsScraperService.convertToNewForceArticles(scrapedNews);

          // Save to database
          await _saveNewsToDatabase(_ghanaWebNews);

          // Update last fetch time
          _lastGhanaWebFetch = DateTime.now();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load GhanaWeb news: $e';
      print(_errorMessage);
      // If we have existing data, keep using it even if refresh failed
      if (_ghanaWebNews.isEmpty) {
        // Try to get fallback data if we have nothing
        try {
          final fallbackNews = NewsScraperService.getFallbackGhanaWebNews();
          _ghanaWebNews =
              NewsScraperService.convertToNewForceArticles(fallbackNews);
        } catch (fallbackError) {
          print('Failed to load fallback GhanaWeb news: $fallbackError');
        }
      }
    } finally {
      _isLoadingGhanaWeb = false;
      notifyListeners();
    }
  }

  /// Fetch news from Pan African News
  /// If forceRefresh is true, it will fetch fresh data regardless of cache status
  Future<void> fetchPanAfricanNews({bool forceRefresh = false}) async {
    // If forcing refresh, reset last fetch time
    if (forceRefresh) {
      _lastPanAfricanFetch = null;
    }

    // If we already have data and it's not expired, don't fetch again
    if (!forceRefresh &&
        _panAfricanNews.isNotEmpty &&
        !_shouldRefreshCache(_lastPanAfricanFetch)) {
      print('Using in-memory Pan African Visions articles');
      return;
    }

    _isLoadingPanAfrican = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // If forceRefresh is true, always scrape fresh data
      if (forceRefresh) {
        print('Force refreshing: Fetching fresh Pan African Visions articles');
        final scrapedNews = await NewsScraperService.scrapePanAfricanNews();
        _panAfricanNews =
            NewsScraperService.convertToNewForceArticles(scrapedNews);

        // Save to database
        await _saveNewsToDatabase(_panAfricanNews);

        // Update last fetch time
        _lastPanAfricanFetch = DateTime.now();
      } else {
        // Check if we have recent cached articles in the database
        final cachedArticles = await _loadCachedNews('Pan African Visions');

        if (cachedArticles.isNotEmpty) {
          print('Using cached Pan African Visions articles from database');
          _panAfricanNews = cachedArticles;
          // Update last fetch time to reflect when we loaded from cache
          _lastPanAfricanFetch = DateTime.now();
        } else {
          print('Fetching fresh Pan African Visions articles');
          final scrapedNews = await NewsScraperService.scrapePanAfricanNews();
          _panAfricanNews =
              NewsScraperService.convertToNewForceArticles(scrapedNews);

          // Save to database
          await _saveNewsToDatabase(_panAfricanNews);

          // Update last fetch time
          _lastPanAfricanFetch = DateTime.now();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load Pan African news: $e';
      print(_errorMessage);
      // If we have existing data, keep using it even if refresh failed
      if (_panAfricanNews.isEmpty) {
        // Try to get fallback data if we have nothing
        try {
          final fallbackNews = NewsScraperService.getFallbackPanAfricanNews();
          _panAfricanNews =
              NewsScraperService.convertToNewForceArticles(fallbackNews);
        } catch (fallbackError) {
          print('Failed to load fallback Pan African news: $fallbackError');
        }
      }
    } finally {
      _isLoadingPanAfrican = false;
      notifyListeners();
    }
  }

  /// Save news articles to the database
  Future<void> _saveNewsToDatabase(List<NewForceArticlesRow> articles) async {
    try {
      final table = NewForceArticlesTable();

      for (final article in articles) {
        // Check if article with same title already exists
        final existingArticles = await table.queryRows(
          queryFn: (q) => q.eq('title', article.title ?? ''),
        );

        // Convert the row to a map for database operations
        final Map<String, dynamic> articleData = article.data;

        if (existingArticles.isEmpty) {
          // Insert new article if it doesn't exist
          print('Inserting new article: ${article.title}');
          await table.insert(articleData);
        } else {
          // Update existing article with fresh data
          print('Updating existing article: ${article.title}');
          final existingId = existingArticles.first.id;
          // Update the existing article with the new data
          await table.update(
            data: articleData,
            matchingRows: (q) => q.eq('id', existingId),
          );
        }
      }
      print('Database update completed: ${articles.length} articles processed');
    } catch (e) {
      print('Error saving articles to database: $e');
    }
  }

  /// Load cached Feed Your Curiosity topics from database
  Future<List<FeedYourCuriosityTopicsRow>>
      _loadCachedFeedYourCuriosityTopics() async {
    try {
      final table = FeedYourCuriosityTopicsTable();
      final yesterday =
          DateTime.now().subtract(Duration(hours: _cacheExpirationHours));

      // Query for recent articles
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

  /// Save Feed Your Curiosity topics to the database
  Future<void> _saveFeedYourCuriosityTopicsToDatabase(
      List<FeedYourCuriosityTopicsRow> topics) async {
    try {
      final table = FeedYourCuriosityTopicsTable();

      for (final topic in topics) {
        // Check if topic with same title already exists
        final existingTopics = await table.queryRows(
          queryFn: (q) => q.eq('title', topic.title ?? ''),
        );

        if (existingTopics.isEmpty) {
          // Convert the row to a map for insertion
          final Map<String, dynamic> topicData = topic.data;
          await table.insert(topicData);
        }
      }
    } catch (e) {
      print('Error saving Feed Your Curiosity topics to database: $e');
    }
  }

  /// Fetch news for Feed Your Curiosity section
  /// If forceRefresh is true, it will fetch fresh data regardless of cache status
  Future<void> fetchFeedYourCuriosity({bool forceRefresh = false}) async {
    // If forcing refresh, reset last fetch time
    if (forceRefresh) {
      _lastFeedYourCuriosityFetch = null;
    }

    // If we already have data and it's not expired, don't fetch again
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
      // If forceRefresh is true, always scrape fresh data
      if (forceRefresh) {
        print('Force refreshing: Fetching fresh Feed Your Curiosity topics');
        final scrapedNews = await NewsScraperService.scrapeFeedYourCuriosity();
        _feedYourCuriosityNews =
            NewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);

        // Save to database
        await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);

        // Update last fetch time
        _lastFeedYourCuriosityFetch = DateTime.now();
      } else {
        // Check if we have recent cached topics in the database
        final cachedTopics = await _loadCachedFeedYourCuriosityTopics();

        if (cachedTopics.isNotEmpty) {
          print('Using cached Feed Your Curiosity topics from database');
          _feedYourCuriosityNews = cachedTopics;
          // Update last fetch time to reflect when we loaded from cache
          _lastFeedYourCuriosityFetch = DateTime.now();
        } else {
          print('Fetching fresh Feed Your Curiosity topics');
          final scrapedNews =
              await NewsScraperService.scrapeFeedYourCuriosity();
          _feedYourCuriosityNews =
              NewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);

          // Save to database
          await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);

          // Update last fetch time
          _lastFeedYourCuriosityFetch = DateTime.now();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load Feed Your Curiosity topics: $e';
      print(_errorMessage);
      // If we have existing data, keep using it even if refresh failed
      if (_feedYourCuriosityNews.isEmpty) {
        // Try to get fallback data if we have nothing
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
}
