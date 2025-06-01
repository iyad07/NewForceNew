import 'dart:async';
import 'package:flutter/foundation.dart';
import '../supabase/database/tables/new_force_articles.dart';
import 'news_scraper_service.dart';

/// A provider class for managing news data from various sources
class NewsProvider extends ChangeNotifier {
  List<NewForceArticlesRow> _ghanaWebNews = [];
  List<NewForceArticlesRow> _panAfricanNews = [];
  bool _isLoading = false;
  String _errorMessage = '';

  /// Get the list of GhanaWeb news articles
  List<NewForceArticlesRow> get ghanaWebNews => _ghanaWebNews;

  /// Get the list of Pan African news articles
  List<NewForceArticlesRow> get panAfricanNews => _panAfricanNews;

  /// Check if news is currently loading
  bool get isLoading => _isLoading;

  /// Get any error message
  String get errorMessage => _errorMessage;

  /// Fetch news from all sources
  Future<void> fetchAllNews() async {
    await Future.wait([
      fetchGhanaWebNews(),
      fetchPanAfricanNews(),
    ]);
  }

  /// Fetch news from GhanaWeb
  Future<void> fetchGhanaWebNews() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final scrapedNews = await NewsScraperService.scrapeGhanaWeb();
      _ghanaWebNews = NewsScraperService.convertToNewForceArticles(scrapedNews);
      
      // Save to database
      await _saveNewsToDatabase(_ghanaWebNews);
    } catch (e) {
      _errorMessage = 'Failed to load GhanaWeb news: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch news from Pan African News
  Future<void> fetchPanAfricanNews() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final scrapedNews = await NewsScraperService.scrapePanAfricanNews();
      _panAfricanNews = NewsScraperService.convertToNewForceArticles(scrapedNews);
      
      // Save to database
      await _saveNewsToDatabase(_panAfricanNews);
    } catch (e) {
      _errorMessage = 'Failed to load Pan African news: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
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
