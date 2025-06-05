import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:new_force_new_hope/backend/supabase/database/tables/investement_news_articles.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';
import 'news_scraper_service.dart';

class NewsProvider extends ChangeNotifier {
  static const int _cacheHours = 2;
  static const List<String> _targetCountries = ['Nigeria', 'Kenya', 'South Africa', 'Ethiopia', 'Ghana'];

  List<NewForceArticlesRow> _africanNews = [];
  List<FeedYourCuriosityTopicsRow> _feedYourCuriosityNews = [];
  List<InvestementNewsArticlesRow> _investmentNews = [];
  Map<String, List<NewForceArticlesRow>> _newsByCountry = {};

  bool _isLoadingAfrican = false;
  bool _isLoadingFeedYourCuriosity = false;
  bool _isLoadingInvestment = false;
  String _errorMessage = '';

  DateTime? _lastAfricanNewsFetch;
  DateTime? _lastFeedYourCuriosityFetch;
  DateTime? _lastInvestmentNewsFetch;

  List<NewForceArticlesRow> get africanNews => _africanNews;
  List<FeedYourCuriosityTopicsRow> get feedYourCuriosityNews => _feedYourCuriosityNews;
  List<InvestementNewsArticlesRow> get investmentNews => _investmentNews;
  Map<String, List<NewForceArticlesRow>> get newsByCountry => _newsByCountry;

  bool get isLoading => _isLoadingAfrican || _isLoadingFeedYourCuriosity || _isLoadingInvestment;
  bool get isLoadingAfrican => _isLoadingAfrican;
  bool get isLoadingFeedYourCuriosity => _isLoadingFeedYourCuriosity;
  bool get isLoadingInvestment => _isLoadingInvestment;
  String get errorMessage => _errorMessage;

  List<NewForceArticlesRow> getNewsByCountry(String country) => _newsByCountry[country] ?? [];
  List<NewForceArticlesRow> get ghanaWebNews => getNewsByCountry('Ghana');
  List<NewForceArticlesRow> get panAfricanNews => _africanNews;
  bool get isLoadingGhanaWeb => _isLoadingAfrican;
  bool get isLoadingPanAfrican => _isLoadingAfrican;

  Future<void> fetchAllNews({bool force = false}) async {
    final futures = <Future>[];

    if (_shouldFetch(_africanNews, _lastAfricanNewsFetch, force)) {
      futures.add(fetchAfricanNews(forceRefresh: force));
    }

    if (_shouldFetch(_feedYourCuriosityNews, _lastFeedYourCuriosityFetch, force)) {
      futures.add(fetchFeedYourCuriosity(forceRefresh: force));
    }

    if (_shouldFetch(_investmentNews, _lastInvestmentNewsFetch, force)) {
      futures.add(fetchInvestmentNews(forceRefresh: force));
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  bool _shouldFetch(List data, DateTime? lastFetch, bool force) {
    if (force) {
      debugPrint('Force refresh requested');
      return true;
    }
    if (data.isEmpty) {
      debugPrint('No data available, fetching');
      return true;
    }
    if (_isCacheExpired(lastFetch)) {
      debugPrint('Cache expired, fetching');
      return true;
    }
    debugPrint('Using cached data');
    return false;
  }

  bool _isCacheExpired(DateTime? lastFetch) {
    if (lastFetch == null) return true;
    final now = DateTime.now();
    final difference = now.difference(lastFetch);
    final isExpired = difference.inHours >= _cacheHours;
    
    if (isExpired) {
      debugPrint('Cache expired: ${difference.inHours} hours old (max: $_cacheHours)');
    } else {
      debugPrint('Cache valid: ${difference.inMinutes} minutes old');
    }
    
    return isExpired;
  }

  Future<void> fetchAfricanNews({bool forceRefresh = false}) async {
    if (!forceRefresh && _africanNews.isNotEmpty && !_isCacheExpired(_lastAfricanNewsFetch)) {
      return;
    }

    await _executeWithLoading(
      () => _isLoadingAfrican = true,
      () => _isLoadingAfrican = false,
      () async {
        final cachedArticles = await _loadCachedNews();
        
        if (cachedArticles.isNotEmpty && !forceRefresh) {
          _africanNews = cachedArticles;
        } else {
          await _fetchAndProcessAfricanNews();
        }
        
        _categorizeNews();
        _lastAfricanNewsFetch = DateTime.now();
      },
    );
  }

  Future<void> _executeWithLoading(
    VoidCallback setLoading,
    VoidCallback clearLoading,
    Future<void> Function() operation,
  ) async {
    setLoading();
    _errorMessage = '';
    notifyListeners();

    try {
      await operation();
    } catch (e) {
      _errorMessage = 'Failed to load news: $e';
      await _handleFallback();
    } finally {
      clearLoading();
      notifyListeners();
    }
  }

  Future<void> _fetchAndProcessAfricanNews() async {
    final scrapedNews = await NewsScraperService.scrapeAfricaNews();
    _africanNews = NewsScraperService.convertToNewForceArticles(scrapedNews);
    await _saveNewsToDatabase(_africanNews);
  }

  Future<void> _handleFallback() async {
    if (_africanNews.isEmpty) {
      try {
        final fallbackNews = NewsScraperService.getFallbackAfricanNews();
        _africanNews = NewsScraperService.convertToNewForceArticles(fallbackNews);
        
        final countries = _targetCountries.toList();
        for (int i = 0; i < _africanNews.length; i++) {
          final article = _africanNews[i];
          final assignedCountry = countries[i % countries.length];
          
          final updatedData = Map<String, dynamic>.from(article.data);
          updatedData['country'] = assignedCountry;
          _africanNews[i] = NewForceArticlesRow(updatedData);
        }
        
        _categorizeNews();
        debugPrint('Using fallback news with forced country distribution');
      } catch (e) {
        debugPrint('Fallback failed: $e');
      }
    }
  }

  Future<List<NewForceArticlesRow>> _loadCachedNews([String? country]) async {
    try {
      final table = NewForceArticlesTable();
      final cutoffTime = DateTime.now().subtract(Duration(hours: _cacheHours));

      var query = table.queryRows(
        queryFn: (q) => q
            .gt('created_at', cutoffTime.toIso8601String())
            .order('created_at', ascending: false),
      );

      if (country != null && country != 'General Africa') {
        query = table.queryRows(
          queryFn: (q) => q
              .eq('country', country)
              .gt('created_at', cutoffTime.toIso8601String())
              .order('created_at', ascending: false),
        );
      }

      return await query;
    } catch (e) {
      return [];
    }
  }

  void _categorizeNews() {
    _newsByCountry = Map.fromEntries(
      [..._targetCountries, 'General Africa'].map((country) => MapEntry(country, <NewForceArticlesRow>[]))
    );

    final countries = _targetCountries.toList();
    
    for (int i = 0; i < _africanNews.length; i++) {
      final article = _africanNews[i];
      var country = article.getField<String>('country') ?? 'General Africa';
      
      if (country == 'General Africa' || !_newsByCountry.containsKey(country)) {
        country = countries[i % countries.length];
        
        final updatedData = Map<String, dynamic>.from(article.data);
        updatedData['country'] = country;
        _africanNews[i] = NewForceArticlesRow(updatedData);
      }
      
      _newsByCountry[country]!.add(_africanNews[i]);
    }
    
    final minArticlesPerCountry = 3;
    for (final country in countries) {
      final currentCount = _newsByCountry[country]!.length;
      if (currentCount < minArticlesPerCountry) {
        final deficit = minArticlesPerCountry - currentCount;
        final availableArticles = _newsByCountry.values
            .where((articles) => articles.length > minArticlesPerCountry)
            .expand((articles) => articles)
            .take(deficit)
            .toList();
        
        for (final article in availableArticles) {
          final updatedData = Map<String, dynamic>.from(article.data);
          updatedData['country'] = country;
          final redistributedArticle = NewForceArticlesRow(updatedData);
          _newsByCountry[country]!.add(redistributedArticle);
        }
      }
    }
    
    debugPrint('Final country distribution: ${_newsByCountry.map((k, v) => MapEntry(k, v.length))}');
  }

  Future<void> _saveNewsToDatabase(List<NewForceArticlesRow> articles) async {
    try {
      final table = NewForceArticlesTable();

      for (final article in articles) {
        final existingArticles = await table.queryRows(
          queryFn: (q) => q.eq('title', article.title ?? ''),
        );

        if (existingArticles.isEmpty) {
          await table.insert(article.data);
        }
      }
    } catch (e) {
      debugPrint('Database save error: $e');
    }
  }

  Future<void> fetchFeedYourCuriosity({bool forceRefresh = false}) async {
    if (!forceRefresh && _feedYourCuriosityNews.isNotEmpty && !_isCacheExpired(_lastFeedYourCuriosityFetch)) {
      debugPrint('Using cached Feed Your Curiosity articles: ${_feedYourCuriosityNews.length}');
      return;
    }

    await _executeWithLoading(
      () => _isLoadingFeedYourCuriosity = true,
      () => _isLoadingFeedYourCuriosity = false,
      () async {
        try {
          final cachedTopics = await _loadCachedFeedYourCuriosityTopics();
          
          if (cachedTopics.isNotEmpty && !forceRefresh) {
            debugPrint('Loading ${cachedTopics.length} cached topics from database');
            _feedYourCuriosityNews = cachedTopics;
          } else {
            debugPrint('Fetching fresh Feed Your Curiosity news');
            await _fetchAndProcessFeedYourCuriosityNews().timeout(
              const Duration(seconds: 45),
              onTimeout: () async {
                debugPrint('Fetch timeout, using fallback');
                final fallbackNews = NewsScraperService.getFallbackAfricanNews();
                _feedYourCuriosityNews = NewsScraperService.convertToFeedYourCuriosityTopics(fallbackNews);
              },
            );
          }
          
          _ensureTopicDistribution();
          _lastFeedYourCuriosityFetch = DateTime.now();
        } catch (e) {
          debugPrint('Feed Your Curiosity fetch error: $e');
          if (_feedYourCuriosityNews.isEmpty) {
            final fallbackNews = NewsScraperService.getFallbackAfricanNews();
            _feedYourCuriosityNews = NewsScraperService.convertToFeedYourCuriosityTopics(fallbackNews);
            _ensureTopicDistribution();
          }
        }
      },
    );
  }

  void _ensureTopicDistribution() {
    final topics = ['African Culture & Lifestyle', 'African Agriculture', 'African Technology', 'trade', 'stocks', 'real estate', 'politics', 'energy'];
    
    if (_feedYourCuriosityNews.isEmpty) return;
    
    final topicCounts = <String, int>{};
    for (final article in _feedYourCuriosityNews) {
      final tag = article.tag ?? 'African Technology';
      topicCounts[tag] = (topicCounts[tag] ?? 0) + 1;
    }
    
    debugPrint('Initial topic distribution: $topicCounts');
    
    for (int i = 0; i < _feedYourCuriosityNews.length; i++) {
      final article = _feedYourCuriosityNews[i];
      final newTag = topics[i % topics.length];
      
      final updatedData = Map<String, dynamic>.from(article.data);
      updatedData['tag'] = newTag;
      
      _feedYourCuriosityNews[i] = FeedYourCuriosityTopicsRow(updatedData);
    }
    
    final finalCounts = <String, int>{};
    for (final article in _feedYourCuriosityNews) {
      final tag = article.tag ?? 'African Technology';
      finalCounts[tag] = (finalCounts[tag] ?? 0) + 1;
    }
    
    debugPrint('Final topic distribution: $finalCounts');
  }

  Future<void> _fetchAndProcessFeedYourCuriosityNews() async {
    try {
      final scrapedNews = await NewsScraperService.scrapeFeedYourCuriosity();
      _feedYourCuriosityNews = NewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);
      await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);
    } catch (e) {
      debugPrint('Error processing Feed Your Curiosity news: $e');
      final fallbackNews = NewsScraperService.getFallbackAfricanNews();
      _feedYourCuriosityNews = NewsScraperService.convertToFeedYourCuriosityTopics(fallbackNews);
    }
  }

  Future<List<FeedYourCuriosityTopicsRow>> _loadCachedFeedYourCuriosityTopics() async {
    try {
      final table = FeedYourCuriosityTopicsTable();
      final cutoffTime = DateTime.now().subtract(Duration(hours: _cacheHours));

      return await table.queryRows(
        queryFn: (q) => q
            .gt('created_at', cutoffTime.toIso8601String())
            .order('created_at', ascending: false),
      );
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveFeedYourCuriosityTopicsToDatabase(List<FeedYourCuriosityTopicsRow> topics) async {
    try {
      final table = FeedYourCuriosityTopicsTable();

      for (final topic in topics) {
        final existingTopics = await table.queryRows(
          queryFn: (q) => q.eq('title', topic.title ?? ''),
        );

        if (existingTopics.isEmpty) {
          await table.insert(topic.data);
        }
      }
    } catch (e) {
      debugPrint('Feed Your Curiosity save error: $e');
    }
  }

  Future<List<InvestementNewsArticlesRow>> fetchInvestmentNews({bool forceRefresh = false}) async {
    debugPrint('=== INVESTMENT NEWS FETCH START ===');
    debugPrint('Force refresh: $forceRefresh');
    debugPrint('Current investment news count: ${_investmentNews.length}');
    debugPrint('Cache expired: ${_isCacheExpired(_lastInvestmentNewsFetch)}');
    
    if (!forceRefresh && _investmentNews.isNotEmpty && !_isCacheExpired(_lastInvestmentNewsFetch)) {
      debugPrint('Using cached investment news: ${_investmentNews.length} articles');
      return _investmentNews;
    }

    await _executeWithLoading(
      () => _isLoadingInvestment = true,
      () => _isLoadingInvestment = false,
      () async {
        try {
          final cachedArticles = await _loadCachedInvestmentNews();
          
          if (cachedArticles.isNotEmpty && !forceRefresh) {
            debugPrint('Loading ${cachedArticles.length} cached investment articles from database');
            _investmentNews = cachedArticles;
          } else {
            debugPrint('Fetching fresh investment news');
            await _fetchAndProcessInvestmentNews().timeout(
              const Duration(seconds: 45),
              onTimeout: () async {
                debugPrint('Investment fetch timeout, using fallback');
                final fallbackNews = NewsScraperService.getFallbackInvestmentNews();
                _investmentNews = NewsScraperService.convertToInvestmentNewsArticles(fallbackNews);
              },
            );
          }
          
          _ensureInvestmentTopicDistribution();
          _lastInvestmentNewsFetch = DateTime.now();
          
          debugPrint('Final investment news count: ${_investmentNews.length}');
          final tagCounts = <String, int>{};
          for (final article in _investmentNews) {
            final tag = article.tag ?? 'unknown';
            tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
          }
          debugPrint('Investment tag distribution: $tagCounts');
        } catch (e) {
          debugPrint('Investment news fetch error: $e');
          if (_investmentNews.isEmpty) {
            final fallbackNews = NewsScraperService.getFallbackInvestmentNews();
            _investmentNews = NewsScraperService.convertToInvestmentNewsArticles(fallbackNews);
            _ensureInvestmentTopicDistribution();
          }
        }
      },
    );

    debugPrint('=== INVESTMENT NEWS FETCH END ===');
    return _investmentNews;
  }

  void _ensureInvestmentTopicDistribution() {
    final investmentTopics = ['Trade', 'Stocks', 'Real Estate', 'Energy', 'Politics', 'Commodities'];
    
    if (_investmentNews.isEmpty) return;
    
    final topicCounts = <String, int>{};
    for (final article in _investmentNews) {
      final tag = article.tag ?? 'Trade';
      topicCounts[tag] = (topicCounts[tag] ?? 0) + 1;
    }
    
    debugPrint('Initial investment topic distribution: $topicCounts');
    
    for (int i = 0; i < _investmentNews.length; i++) {
      final article = _investmentNews[i];
      final newTag = investmentTopics[i % investmentTopics.length];
      
      final updatedData = Map<String, dynamic>.from(article.data);
      updatedData['tag'] = newTag;
      
      _investmentNews[i] = InvestementNewsArticlesRow(updatedData);
    }
    
    final finalCounts = <String, int>{};
    for (final article in _investmentNews) {
      final tag = article.tag ?? 'Trade';
      finalCounts[tag] = (finalCounts[tag] ?? 0) + 1;
    }
    
    debugPrint('Final investment topic distribution: $finalCounts');
  }

  Future<void> _fetchAndProcessInvestmentNews() async {
    try {
      debugPrint('Starting investment news scraping...');
      final scrapedNews = await NewsScraperService.scrapeInvestmentNews();
      debugPrint('Scraped ${scrapedNews.length} investment articles');
      
      _investmentNews = NewsScraperService.convertToInvestmentNewsArticles(scrapedNews);
      debugPrint('Converted to ${_investmentNews.length} investment news rows');
      
      await _saveInvestmentNewsToDatabase(_investmentNews);
      debugPrint('Saved investment news to database');
    } catch (e) {
      debugPrint('Error processing investment news: $e');
      final fallbackNews = NewsScraperService.getFallbackInvestmentNews();
      _investmentNews = NewsScraperService.convertToInvestmentNewsArticles(fallbackNews);
      debugPrint('Using fallback investment news: ${_investmentNews.length} articles');
    }
  }

  Future<List<InvestementNewsArticlesRow>> _loadCachedInvestmentNews() async {
    try {
      final table = InvestementNewsArticlesTable();
      final cutoffTime = DateTime.now().subtract(Duration(hours: _cacheHours));

      return await table.queryRows(
        queryFn: (q) => q
            .gt('created_at', cutoffTime.toIso8601String())
            .order('created_at', ascending: false),
      );
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveInvestmentNewsToDatabase(List<InvestementNewsArticlesRow> articles) async {
    try {
      final table = InvestementNewsArticlesTable();
      
      for (final article in articles) {
        final existingArticles = await table.queryRows(
          queryFn: (q) => q.eq('title', article.title ?? ''),
        );

        if (existingArticles.isEmpty) {
          await table.insert(article.data);
        }
      }
    } catch (e) {
      debugPrint('Investment news save error: $e');
    }
  }

  Future<void> reCategorizeExistingArticles() async {
    if (_africanNews.isEmpty) return;

    _categorizeNews();

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
    } catch (e) {
      debugPrint('Recategorization update error: $e');
    }

    notifyListeners();
  }

  Future<void> fetchGhanaWebNews({bool forceRefresh = false}) async {
    if (!forceRefresh && getNewsByCountry('Ghana').isNotEmpty) return;
    await fetchAfricanNews(forceRefresh: forceRefresh);
  }

  void printSourceDistribution() {
    final sourceCount = <String, int>{};
    
    for (final article in _africanNews) {
      final publisher = article.getField<String>('publishers') ?? 'Unknown';
      sourceCount[publisher] = (sourceCount[publisher] ?? 0) + 1;
    }

    _newsByCountry.forEach((country, articles) {
      if (articles.isNotEmpty) {
        final sourceBreakdown = <String, int>{};
        for (final article in articles) {
          final publisher = article.getField<String>('publishers') ?? 'Unknown';
          sourceBreakdown[publisher] = (sourceBreakdown[publisher] ?? 0) + 1;
        }
        debugPrint('$country: $sourceBreakdown');
      }
    });
    
    debugPrint('Overall distribution: $sourceCount');
  }
}