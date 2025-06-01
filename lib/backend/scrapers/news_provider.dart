import 'dart:async';
import 'package:flutter/foundation.dart';
import '../supabase/database/tables/new_force_articles.dart';
import 'news_scraper_service.dart';

/// A provider class for managing news data from various sources
class NewsProvider extends ChangeNotifier {
  List<NewForceArticlesRow> _ghanaWebNews = [];
  List<NewForceArticlesRow> _panAfricanNews = [];
  bool _isLoadingGhanaWeb = false;
  bool _isLoadingPanAfrican = false;
  String _errorMessage = '';
  
  // Cache expiration time in hours
  static const int _cacheExpirationHours = 24;
  
  // Last fetch timestamps
  DateTime? _lastGhanaWebFetch;
  DateTime? _lastPanAfricanFetch;

  /// Get the list of GhanaWeb news articles
  List<NewForceArticlesRow> get ghanaWebNews => _ghanaWebNews;

  /// Get the list of Pan African news articles
  List<NewForceArticlesRow> get panAfricanNews => _panAfricanNews;

  /// Check if any news source is currently loading
  bool get isLoading => _isLoadingGhanaWeb || _isLoadingPanAfrican;
  
  /// Check if GhanaWeb news is loading
  bool get isLoadingGhanaWeb => _isLoadingGhanaWeb;
  
  /// Check if Pan African news is loading
  bool get isLoadingPanAfrican => _isLoadingPanAfrican;

  /// Get any error message
  String get errorMessage => _errorMessage;

  /// Fetch news from all sources
  Future<void> fetchAllNews() async {
    await Future.wait([
      fetchGhanaWebNews(),
      fetchPanAfricanNews(),
    ]);
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
      final yesterday = DateTime.now().subtract(Duration(hours: _cacheExpirationHours));
      
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
  Future<void> fetchGhanaWebNews() async {
    _isLoadingGhanaWeb = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Check if we have recent cached articles
      final cachedArticles = await _loadCachedNews('GhanaWeb');
      
      if (cachedArticles.isNotEmpty && !_shouldRefreshCache(_lastGhanaWebFetch)) {
        print('Using cached GhanaWeb articles');
        _ghanaWebNews = cachedArticles;
      } else {
        print('Fetching fresh GhanaWeb articles');
        final scrapedNews = await NewsScraperService.scrapeGhanaWeb();
        _ghanaWebNews = NewsScraperService.convertToNewForceArticles(scrapedNews);
        
        // Save to database
        await _saveNewsToDatabase(_ghanaWebNews);
        
        // Update last fetch time
        _lastGhanaWebFetch = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'Failed to load GhanaWeb news: $e';
      print(_errorMessage);
    } finally {
      _isLoadingGhanaWeb = false;
      notifyListeners();
    }
  }

  /// Fetch news from Pan African News
  Future<void> fetchPanAfricanNews() async {
    _isLoadingPanAfrican = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Check if we have recent cached articles
      final cachedArticles = await _loadCachedNews('Pan African Visions');
      
      if (cachedArticles.isNotEmpty && !_shouldRefreshCache(_lastPanAfricanFetch)) {
        print('Using cached Pan African Visions articles');
        _panAfricanNews = cachedArticles;
      } else {
        print('Fetching fresh Pan African Visions articles');
        final scrapedNews = await NewsScraperService.scrapePanAfricanNews();
        _panAfricanNews = NewsScraperService.convertToNewForceArticles(scrapedNews);
        
        // Save to database
        await _saveNewsToDatabase(_panAfricanNews);
        
        // Update last fetch time
        _lastPanAfricanFetch = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'Failed to load Pan African news: $e';
      print(_errorMessage);
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
        
        if (existingArticles.isEmpty) {
          // Convert the row to a map for insertion
          final Map<String, dynamic> articleData = article.data;
          await table.insert(articleData);
        }
      }
    } catch (e) {
      print('Error saving articles to database: $e');
    }
  }
}
