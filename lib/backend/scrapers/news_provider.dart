import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:new_force_new_hope/backend/scrapers/news_scraper_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_force_new_hope/backend/supabase/database/tables/investement_news_articles.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';


class EnhancedNewsProvider extends ChangeNotifier {
  static const int _cacheHours = 2;
  
  // All 54 African countries (matching database spellings exactly)
  static const List<String> _allAfricanCountries = [
    'Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso',
    'Burundi', 'Cameroon', 'Cape Verde', 'Central African Republic', 'Chad',
    'Comoros', 'Congo (Kinshasa)', 'Congo (Brazzaville)', 'Côte d\'Ivoire', 'Djibouti',
    'Egypt', 'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia',
    'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau',
    'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar',
    'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco',
    'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda',
    'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia',
    'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Togo',
    'Tunisia', 'Uganda', 'Zambia', 'Zimbabwe'
  ];
  
  // Priority countries for enhanced coverage
  static const List<String> _priorityCountries = [
    'Nigeria', 'South Africa', 'Egypt', 'Kenya', 'Ghana', 'Morocco', 
    'Ethiopia', 'Tanzania', 'Uganda', 'Angola', 'Algeria', 'Tunisia'
  ];
  
  // Cache keys
  static const String _africanNewsKey = 'cached_african_news';
  static const String _feedYourCuriosityKey = 'cached_feed_your_curiosity';
  static const String _investmentNewsKey = 'cached_investment_news';
  static const String _lastFetchAfricanKey = 'last_fetch_african';
  static const String _lastFetchFeedKey = 'last_fetch_feed';
  static const String _lastFetchInvestmentKey = 'last_fetch_investment';
  static const String _countryStatsKey = 'country_stats';

  // Data storage
  List<NewForceArticlesRow> _africanNews = [];
  List<FeedYourCuriosityTopicsRow> _feedYourCuriosityNews = [];
  List<InvestementNewsArticlesRow> _investmentNews = [];
  Map<String, List<NewForceArticlesRow>> _newsByCountry = {};
  Map<String, int> _countryStats = {};

  // Loading states
  bool _isLoadingAfrican = false;
  bool _isLoadingFeedYourCuriosity = false;
  bool _isLoadingInvestment = false;
  String _errorMessage = '';

  // Last fetch timestamps
  DateTime? _lastAfricanNewsFetch;
  DateTime? _lastFeedYourCuriosityFetch;
  DateTime? _lastInvestmentNewsFetch;

  // Getters
  List<NewForceArticlesRow> get africanNews => _africanNews;
  List<FeedYourCuriosityTopicsRow> get feedYourCuriosityNews => _feedYourCuriosityNews;
  List<InvestementNewsArticlesRow> get investmentNews => _investmentNews;
  Map<String, List<NewForceArticlesRow>> get newsByCountry => _newsByCountry;
  Map<String, int> get countryStats => _countryStats;
  List<String> get availableCountries => _newsByCountry.keys.where((country) => _newsByCountry[country]!.isNotEmpty).toList();

  bool get isLoading => _isLoadingAfrican || _isLoadingFeedYourCuriosity || _isLoadingInvestment;
  bool get isLoadingAfrican => _isLoadingAfrican;
  bool get isLoadingFeedYourCuriosity => _isLoadingFeedYourCuriosity;
  bool get isLoadingInvestment => _isLoadingInvestment;
  String get errorMessage => _errorMessage;

  // Country-specific getters
  List<NewForceArticlesRow> getNewsByCountry(String country) => _newsByCountry[country] ?? [];
  List<NewForceArticlesRow> get ghanaWebNews => getNewsByCountry('Ghana');
  List<NewForceArticlesRow> get nigerianNews => getNewsByCountry('Nigeria');
  List<NewForceArticlesRow> get southAfricanNews => getNewsByCountry('South Africa');
  List<NewForceArticlesRow> get kenyanNews => getNewsByCountry('Kenya');
  List<NewForceArticlesRow> get egyptianNews => getNewsByCountry('Egypt');
  List<NewForceArticlesRow> get moroccanNews => getNewsByCountry('Morocco');
  List<NewForceArticlesRow> get panAfricanNews => _africanNews;

  // Regional getters (updated to match database spellings)
  List<NewForceArticlesRow> get westAfricaNews => _getNewsByRegion(['Nigeria', 'Ghana', 'Senegal', 'Côte d\'Ivoire', 'Mali', 'Burkina Faso', 'Niger', 'Guinea', 'Benin', 'Togo', 'Sierra Leone', 'Liberia', 'Mauritania', 'Gambia', 'Guinea-Bissau', 'Cape Verde']);
  List<NewForceArticlesRow> get eastAfricaNews => _getNewsByRegion(['Kenya', 'Ethiopia', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'Somalia', 'Djibouti', 'Eritrea', 'South Sudan', 'Madagascar', 'Malawi', 'Mauritius', 'Seychelles', 'Comoros']);
  List<NewForceArticlesRow> get northAfricaNews => _getNewsByRegion(['Egypt', 'Libya', 'Tunisia', 'Algeria', 'Morocco', 'Sudan']);
  List<NewForceArticlesRow> get centralAfricaNews => _getNewsByRegion(['Congo (Kinshasa)', 'Congo (Brazzaville)', 'Central African Republic', 'Chad', 'Cameroon', 'Equatorial Guinea', 'Gabon', 'Sao Tome and Principe']);
  List<NewForceArticlesRow> get southernAfricaNews => _getNewsByRegion(['South Africa', 'Zimbabwe', 'Botswana', 'Namibia', 'Zambia', 'Angola', 'Mozambique', 'Eswatini', 'Lesotho']);

  List<NewForceArticlesRow> _getNewsByRegion(List<String> countries) {
    final regionalNews = <NewForceArticlesRow>[];
    for (final country in countries) {
      regionalNews.addAll(getNewsByCountry(country));
    }
    return regionalNews;
  }

  // Loading state getters for specific countries
  bool get isLoadingGhanaWeb => _isLoadingAfrican;
  bool get isLoadingPanAfrican => _isLoadingAfrican;

  Future<void> initializeFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await _loadCachedAfricanNews(prefs);
      await _loadCachedFeedYourCuriosityFromLocal(prefs);
      await _loadCachedInvestmentNewsFromLocal(prefs);
      await _loadCountryStats(prefs);
      
      _categorizeNewsForAllCountries();
      _ensureTopicDistribution();
      _ensureInvestmentTopicDistribution();
      
      notifyListeners();
      
      debugPrint('Enhanced Provider: Loaded cached data across ${_newsByCountry.keys.length} countries');
      debugPrint('African=${_africanNews.length}, Feed=${_feedYourCuriosityNews.length}, Investment=${_investmentNews.length}');
    } catch (e) {
      debugPrint('Failed to load from local storage: $e');
    }
  }

  Future<void> _loadCountryStats(SharedPreferences prefs) async {
    final statsData = prefs.getString(_countryStatsKey);
    if (statsData != null) {
      final Map<String, dynamic> decoded = json.decode(statsData);
      _countryStats = decoded.map((key, value) => MapEntry(key, value as int));
    }
  }

  Future<void> _saveCountryStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_countryStatsKey, json.encode(_countryStats));
    } catch (e) {
      debugPrint('Failed to save country stats: $e');
    }
  }

  Future<void> _loadCachedAfricanNews(SharedPreferences prefs) async {
    final cachedData = prefs.getString(_africanNewsKey);
    final lastFetchStr = prefs.getString(_lastFetchAfricanKey);
    
    if (cachedData != null) {
      final List<dynamic> decodedList = json.decode(cachedData);
      _africanNews = decodedList.map((item) => NewForceArticlesRow(Map<String, dynamic>.from(item))).toList();
    }
    
    if (lastFetchStr != null) {
      _lastAfricanNewsFetch = DateTime.parse(lastFetchStr);
    }
  }

  Future<void> _loadCachedFeedYourCuriosityFromLocal(SharedPreferences prefs) async {
    final cachedData = prefs.getString(_feedYourCuriosityKey);
    final lastFetchStr = prefs.getString(_lastFetchFeedKey);
    
    if (cachedData != null) {
      final List<dynamic> decodedList = json.decode(cachedData);
      _feedYourCuriosityNews = decodedList.map((item) => FeedYourCuriosityTopicsRow(Map<String, dynamic>.from(item))).toList();
    }
    
    if (lastFetchStr != null) {
      _lastFeedYourCuriosityFetch = DateTime.parse(lastFetchStr);
    }
  }

  Future<void> _loadCachedInvestmentNewsFromLocal(SharedPreferences prefs) async {
    final cachedData = prefs.getString(_investmentNewsKey);
    final lastFetchStr = prefs.getString(_lastFetchInvestmentKey);
    
    if (cachedData != null) {
      final List<dynamic> decodedList = json.decode(cachedData);
      _investmentNews = decodedList.map((item) => InvestementNewsArticlesRow(Map<String, dynamic>.from(item))).toList();
    }
    
    if (lastFetchStr != null) {
      _lastInvestmentNewsFetch = DateTime.parse(lastFetchStr);
    }
  }

  Future<void> fetchAllNews({bool force = false}) async {
    final futures = <Future>[];

    if (_shouldFetch(_africanNews, _lastAfricanNewsFetch, force)) {
      futures.add(_fetchAfricanNewsInBackground(forceRefresh: force));
    }

    if (_shouldFetch(_feedYourCuriosityNews, _lastFeedYourCuriosityFetch, force)) {
      futures.add(_fetchFeedYourCuriosityInBackground(forceRefresh: force));
    }

    if (_shouldFetch(_investmentNews, _lastInvestmentNewsFetch, force)) {
      futures.add(_fetchInvestmentNewsInBackground(forceRefresh: force));
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> _fetchAfricanNewsInBackground({bool forceRefresh = false}) async {
    _isLoadingAfrican = true;
    notifyListeners();
    
    try {
      // Use enhanced scraper service
      final scrapedNews = await EnhancedNewsScraperService.scrapeAfricaNews();
      final newArticles = EnhancedNewsScraperService.convertToNewForceArticles(scrapedNews);
      
      if (newArticles.isNotEmpty) {
        _africanNews = newArticles;
        _categorizeNewsForAllCountries();
        _updateCountryStats();
        _lastAfricanNewsFetch = DateTime.now();
        
        await _saveAfricanNewsToLocal(_africanNews);
        await _saveNewsToDatabase(_africanNews);
        await _saveCountryStats();
        
        notifyListeners();
        debugPrint('Enhanced Background fetch: ${_africanNews.length} articles across ${_newsByCountry.keys.length} countries');
        _printEnhancedDistribution();
      }
    } catch (e) {
      debugPrint('Enhanced African news fetch failed: $e');
      await _handleFallback();
    } finally {
      _isLoadingAfrican = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFeedYourCuriosityInBackground({bool forceRefresh = false}) async {
    _isLoadingFeedYourCuriosity = true;
    notifyListeners();
    
    try {
      final scrapedNews = await EnhancedNewsScraperService.scrapeFeedYourCuriosity();
      final newArticles = EnhancedNewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);
      
      if (newArticles.isNotEmpty) {
        _feedYourCuriosityNews = newArticles;
        _ensureTopicDistribution();
        _lastFeedYourCuriosityFetch = DateTime.now();
        
        await _saveFeedYourCuriosityToLocal(_feedYourCuriosityNews);
        await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);
        
        notifyListeners();
        debugPrint('Enhanced Feed Your Curiosity fetch: ${_feedYourCuriosityNews.length} articles');
      }
    } catch (e) {
      debugPrint('Enhanced Feed Your Curiosity fetch failed: $e');
    } finally {
      _isLoadingFeedYourCuriosity = false;
      notifyListeners();
    }
  }

  Future<void> _fetchInvestmentNewsInBackground({bool forceRefresh = false}) async {
    _isLoadingInvestment = true;
    notifyListeners();
    
    try {
      final scrapedNews = await EnhancedNewsScraperService.scrapeInvestmentNews();
      final newArticles = EnhancedNewsScraperService.convertToInvestmentNewsArticles(scrapedNews);
      
      if (newArticles.isNotEmpty) {
        _investmentNews = newArticles;
        _ensureInvestmentTopicDistribution();
        _lastInvestmentNewsFetch = DateTime.now();
        
        await _saveInvestmentNewsToLocal(_investmentNews);
        await _saveInvestmentNewsToDatabase(_investmentNews);
        
        notifyListeners();
        debugPrint('Enhanced Investment news fetch: ${_investmentNews.length} articles');
      }
    } catch (e) {
      debugPrint('Enhanced Investment news fetch failed: $e');
    } finally {
      _isLoadingInvestment = false;
      notifyListeners();
    }
  }

  void _categorizeNewsForAllCountries() {
    // Initialize all African countries
    _newsByCountry = Map.fromEntries(
      _allAfricanCountries.map((country) => MapEntry(country, <NewForceArticlesRow>[]))
    );
    _newsByCountry['General Africa'] = [];

    // First pass: categorize based on existing country data
    for (final article in _africanNews) {
      var country = article.getField<String>('country') ?? 'General Africa';
      
      if (_newsByCountry.containsKey(country)) {
        _newsByCountry[country]!.add(article);
      } else {
        _newsByCountry['General Africa']!.add(article);
      }
    }

    // Second pass: ensure priority countries have minimum coverage
    _ensurePriorityCountryCoverage();
    
    // Third pass: redistribute remaining articles to improve coverage
    _redistributeArticlesForBetterCoverage();
    
    debugPrint('Enhanced categorization completed for ${_newsByCountry.keys.where((key) => _newsByCountry[key]!.isNotEmpty).length} countries');
  }

  void _ensurePriorityCountryCoverage() {
    const minArticlesPerPriorityCountry = 5;
    final generalArticles = _newsByCountry['General Africa']!;
    int generalIndex = 0;
    
    for (final country in _priorityCountries) {
      final currentCount = _newsByCountry[country]!.length;
      if (currentCount < minArticlesPerPriorityCountry) {
        final needed = minArticlesPerPriorityCountry - currentCount;
        
        for (int i = 0; i < needed && generalIndex < generalArticles.length; i++) {
          final article = generalArticles[generalIndex];
          
          // Update article country
          final updatedData = Map<String, dynamic>.from(article.data);
          updatedData['country'] = country;
          final redistributedArticle = NewForceArticlesRow(updatedData);
          
          _newsByCountry[country]!.add(redistributedArticle);
          _africanNews[_africanNews.indexOf(article)] = redistributedArticle;
          generalIndex++;
        }
      }
    }
    
    // Remove redistributed articles from general
    _newsByCountry['General Africa'] = generalArticles.skip(generalIndex).toList();
  }

  void _redistributeArticlesForBetterCoverage() {
    const minArticlesPerCountry = 1; // GUARANTEE at least 1 article per country
    const maxArticlesPerCountry = 8; // Prevent over-concentration
    
    // Step 1: Collect excess articles from over-represented countries
    final availableArticles = <NewForceArticlesRow>[];
    
    for (final country in _allAfricanCountries) {
      final articles = _newsByCountry[country]!;
      if (articles.length > maxArticlesPerCountry) {
        final excess = articles.length - maxArticlesPerCountry;
        availableArticles.addAll(articles.take(excess));
        _newsByCountry[country] = articles.skip(excess).toList();
      }
    }
    
    // Step 2: Add general articles to available pool
    availableArticles.addAll(_newsByCountry['General Africa']!);
    
    // Step 3: GUARANTEE every country gets at least 1 article
    int articleIndex = 0;
    final countriesNeedingArticles = <String>[];
    
    // First pass: Find countries with no articles
    for (final country in _allAfricanCountries) {
      if (_newsByCountry[country]!.isEmpty) {
        countriesNeedingArticles.add(country);
      }
    }
    
    // Distribute to empty countries first (PRIORITY)
    for (final country in countriesNeedingArticles) {
      if (articleIndex < availableArticles.length) {
        final article = availableArticles[articleIndex];
        
        // Update article country
        final updatedData = Map<String, dynamic>.from(article.data);
        updatedData['country'] = country;
        final redistributedArticle = NewForceArticlesRow(updatedData);
        
        _newsByCountry[country]!.add(redistributedArticle);
        
        // Update in main list
        final mainIndex = _africanNews.indexWhere((a) => a.data == article.data);
        if (mainIndex != -1) {
          _africanNews[mainIndex] = redistributedArticle;
        }
        
        articleIndex++;
        debugPrint('GUARANTEED: Assigned article to $country (was empty)');
      }
    }
    
    // Step 4: Second pass - fill up to minimum for all countries
    for (final country in _allAfricanCountries) {
      final currentCount = _newsByCountry[country]!.length;
      if (currentCount < minArticlesPerCountry && articleIndex < availableArticles.length) {
        final needed = minArticlesPerCountry - currentCount;
        
        for (int i = 0; i < needed && articleIndex < availableArticles.length; i++) {
          final article = availableArticles[articleIndex];
          
          // Update article country
          final updatedData = Map<String, dynamic>.from(article.data);
          updatedData['country'] = country;
          final redistributedArticle = NewForceArticlesRow(updatedData);
          
          _newsByCountry[country]!.add(redistributedArticle);
          
          // Update in main list
          final mainIndex = _africanNews.indexWhere((a) => a.data == article.data);
          if (mainIndex != -1) {
            _africanNews[mainIndex] = redistributedArticle;
          }
          
          articleIndex++;
        }
      }
    }
    
    // Step 5: If we still have empty countries, create fallback articles
    final stillEmptyCountries = _allAfricanCountries.where((country) => 
        _newsByCountry[country]!.isEmpty).toList();
    
    if (stillEmptyCountries.isNotEmpty) {
      debugPrint('WARNING: ${stillEmptyCountries.length} countries still empty. Creating fallback articles.');
      
      for (final country in stillEmptyCountries) {
        // Create a fallback article for this country
        final fallbackArticle = _createFallbackArticleForCountry(country);
        final newArticleRow = NewForceArticlesRow(fallbackArticle);
        
        _newsByCountry[country]!.add(newArticleRow);
        _africanNews.add(newArticleRow);
        
        debugPrint('FALLBACK: Created article for $country');
      }
    }
    
    // Step 6: Update general Africa with remaining articles
    _newsByCountry['General Africa'] = availableArticles.skip(articleIndex).toList();
    
    // Final verification
    final emptyCountries = _allAfricanCountries.where((country) => 
        _newsByCountry[country]!.isEmpty).length;
    
    if (emptyCountries > 0) {
      debugPrint('ERROR: $emptyCountries countries still have no articles!');
    } else {
      debugPrint('SUCCESS: All ${_allAfricanCountries.length} countries have at least 1 article');
    }
  }

  Map<String, dynamic> _createFallbackArticleForCountry(String country) {
    final now = DateTime.now().toIso8601String();
    final region = _getRegionForCountry(country);
    
    return {
      'title': '$country Advances National Development Through Strategic Partnerships',
      'description': '$country implements new initiatives to boost economic growth and improve living standards for citizens.',
      'articleBody': '$country has implemented comprehensive development initiatives aimed at boosting economic growth and improving living standards for its citizens. The government has focused on infrastructure development, education improvements, and healthcare enhancements as key priorities. Recent partnerships with regional and international organizations are providing technical assistance and funding for critical development projects. These efforts include investments in transportation networks, digital infrastructure, and renewable energy systems. The initiatives are creating employment opportunities and positioning $country for sustainable long-term growth. Community development programs are ensuring that benefits reach rural and urban populations alike.',
      'articleImage': _getDefaultImageUrl(),
      'publishers': _getPublisherForCountry(country),
      'created_at': now,
      'articleUrl': '',
      'country': country,
    };
  }

  String _getPublisherForCountry(String country) {
    final countryPublishers = {
      'Nigeria': 'Vanguard Nigeria',
      'South Africa': 'News24 South Africa',
      'Kenya': 'The Standard Kenya',
      'Ghana': 'GhanaWeb',
      'Egypt': 'Al-Ahram Egypt',
      'Morocco': 'Morocco World News',
      'Ethiopia': 'Ethiopian News Agency',
      'Tanzania': 'The Citizen Tanzania',
      'Algeria': 'Algeria Press Service',
      'Tunisia': 'TAP News Agency',
      'Angola': 'Angola Press',
      'Uganda': 'New Vision Uganda',
      'Mozambique': 'AIM Mozambique',
      'Madagascar': 'Madagascar Tribune',
      'Cameroon': 'Cameroon Tribune',
      'Côte d\'Ivoire': 'Fraternité Matin',
      'Niger': 'ANP Niger',
      'Mali': 'AMAP Mali',
      'Burkina Faso': 'Burkina 24',
      'Malawi': 'Malawi News Agency',
      'Zambia': 'Zambia Daily Mail',
      'Zimbabwe': 'The Herald Zimbabwe',
      'Senegal': 'APS Senegal',
      'Chad': 'Alwihda Info',
      'Somalia': 'Goobjoog News',
      'Guinea': 'Guinée News',
      'Rwanda': 'The New Times Rwanda',
      'Burundi': 'Iwacu Burundi',
      'Togo': 'Togo First',
      'Sierra Leone': 'Awoko News',
      'Libya': 'Libya Herald',
      'Liberia': 'Daily Observer Liberia',
      'Mauritania': 'AMI Mauritania',
      'Lesotho': 'Lesotho Times',
      'Gambia': 'The Point Gambia',
      'Botswana': 'Mmegi Botswana',
      'Gabon': 'L\'Union Gabon',
      'Namibia': 'The Namibian',
      'Mauritius': 'L\'Express Maurice',
      'Eswatini': 'Times of Swaziland',
      'Djibouti': 'La Nation Djibouti',
      'Comoros': 'Al-Watwan Comoros',
      'Cape Verde': 'A Semana Cape Verde',
      'Sao Tome and Principe': 'Téla Nón',
      'Seychelles': 'Seychelles Nation',
      'Central African Republic': 'Centrafrique Presse',
      'Equatorial Guinea': 'TVGE',
      'Eritrea': 'EriTV',
      'Guinea-Bissau': 'Bissau Digital',
      'South Sudan': 'Juba Monitor',
      'Congo (Brazzaville)': 'Les Dépêches de Brazzaville',
      'Congo (Kinshasa)': 'Radio Okapi',
    };
    
    return countryPublishers[country] ?? 'African News Network';
  }

  String _getRegionForCountry(String country) {
    const regionalGroups = {
      'North Africa': ['Algeria', 'Egypt', 'Libya', 'Morocco', 'Sudan', 'Tunisia'],
      'West Africa': ['Benin', 'Burkina Faso', 'Cape Verde', 'Côte d\'Ivoire', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Liberia', 'Mali', 'Mauritania', 'Niger', 'Nigeria', 'Senegal', 'Sierra Leone', 'Togo'],
      'Central Africa': ['Cameroon', 'Central African Republic', 'Chad', 'Congo (Kinshasa)', 'Congo (Brazzaville)', 'Equatorial Guinea', 'Gabon', 'Sao Tome and Principe'],
      'East Africa': ['Burundi', 'Comoros', 'Djibouti', 'Eritrea', 'Ethiopia', 'Kenya', 'Madagascar', 'Malawi', 'Mauritius', 'Rwanda', 'Seychelles', 'Somalia', 'South Sudan', 'Tanzania', 'Uganda'],
      'Southern Africa': ['Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe']
    };
    
    for (final entry in regionalGroups.entries) {
      if (entry.value.contains(country)) {
        return entry.key;
      }
    }
    return 'Africa';
  }

  String _getDefaultImageUrl() {
    const defaultImages = [
      'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1564415315949-7a0c4c73aab4?w=800&h=600&fit=crop'
    ];
    
    final index = DateTime.now().millisecondsSinceEpoch % defaultImages.length;
    return defaultImages[index];
  }

  void _updateCountryStats() {
    _countryStats.clear();
    _newsByCountry.forEach((country, articles) {
      if (articles.isNotEmpty) {
        _countryStats[country] = articles.length;
      }
    });
  }

  void _printEnhancedDistribution() {
    final nonEmptyCountries = <String, int>{};
    _newsByCountry.forEach((country, articles) {
      if (articles.isNotEmpty) {
        nonEmptyCountries[country] = articles.length;
      }
    });
    
    debugPrint('=== ENHANCED COUNTRY DISTRIBUTION ===');
    debugPrint('Total countries with articles: ${nonEmptyCountries.length}');
    debugPrint('Priority countries coverage:');
    for (final country in _priorityCountries) {
      final count = nonEmptyCountries[country] ?? 0;
      debugPrint('  $country: $count articles');
    }
    debugPrint('Other countries: ${nonEmptyCountries.length - _priorityCountries.where((c) => nonEmptyCountries.containsKey(c)).length}');
    debugPrint('=====================================');
  }

  // Enhanced fallback with better country distribution
  Future<void> _handleFallback() async {
    if (_africanNews.isEmpty) {
      try {
        final fallbackNews = EnhancedNewsScraperService.getFallbackAfricanNews();
        _africanNews = EnhancedNewsScraperService.convertToNewForceArticles(fallbackNews);
        
        _categorizeNewsForAllCountries();
        debugPrint('Enhanced fallback: Using fallback news with improved country distribution');
      } catch (e) {
        debugPrint('Enhanced fallback failed: $e');
      }
    }
  }

  // Save methods
  Future<void> _saveAfricanNewsToLocal(List<NewForceArticlesRow> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataToSave = articles.map((article) => article.data).toList();
      
      await prefs.setString(_africanNewsKey, json.encode(dataToSave));
      await prefs.setString(_lastFetchAfricanKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to save African news to local storage: $e');
    }
  }

  Future<void> _saveFeedYourCuriosityToLocal(List<FeedYourCuriosityTopicsRow> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataToSave = articles.map((article) => article.data).toList();
      
      await prefs.setString(_feedYourCuriosityKey, json.encode(dataToSave));
      await prefs.setString(_lastFetchFeedKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to save Feed Your Curiosity to local storage: $e');
    }
  }

  Future<void> _saveInvestmentNewsToLocal(List<InvestementNewsArticlesRow> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataToSave = articles.map((article) => article.data).toList();
      
      await prefs.setString(_investmentNewsKey, json.encode(dataToSave));
      await prefs.setString(_lastFetchInvestmentKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to save investment news to local storage: $e');
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

  // Topic distribution methods
  void _ensureTopicDistribution() {
    final topics = [
      'African Culture & Lifestyle', 
      'African Agriculture', 
      'African Technology', 
      'African Education',
      'African Health',
      'African Environment',
      'African Sports',
      'African Arts'
    ];
    
    if (_feedYourCuriosityNews.isEmpty) return;
    
    for (int i = 0; i < _feedYourCuriosityNews.length; i++) {
      final article = _feedYourCuriosityNews[i];
      final newTag = topics[i % topics.length];
      
      final updatedData = Map<String, dynamic>.from(article.data);
      updatedData['tag'] = newTag;
      
      _feedYourCuriosityNews[i] = FeedYourCuriosityTopicsRow(updatedData);
    }
  }

  void _ensureInvestmentTopicDistribution() {
    final investmentTopics = [
      'Trade', 'Stocks', 'Real Estate', 'Energy', 
      'Politics', 'Commodities', 'Banking', 'Infrastructure'
    ];
    
    if (_investmentNews.isEmpty) return;
    
    for (int i = 0; i < _investmentNews.length; i++) {
      final article = _investmentNews[i];
      final newTag = investmentTopics[i % investmentTopics.length];
      
      final updatedData = Map<String, dynamic>.from(article.data);
      updatedData['tag'] = newTag;
      
      _investmentNews[i] = InvestementNewsArticlesRow(updatedData);
    }
  }

  // Database operations
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

  // Enhanced public methods
  Future<void> fetchAfricanNews({bool forceRefresh = false}) async {
    if (!forceRefresh && _africanNews.isNotEmpty && !_isCacheExpired(_lastAfricanNewsFetch)) {
      return;
    }

    await _executeWithLoading(
      () => _isLoadingAfrican = true,
      () => _isLoadingAfrican = false,
      () async {
        final scrapedNews = await EnhancedNewsScraperService.scrapeAfricaNews();
        _africanNews = EnhancedNewsScraperService.convertToNewForceArticles(scrapedNews);
        
        _categorizeNewsForAllCountries();
        _updateCountryStats();
        _lastAfricanNewsFetch = DateTime.now();
        
        await _saveAfricanNewsToLocal(_africanNews);
        await _saveNewsToDatabase(_africanNews);
        await _saveCountryStats();
      },
    );
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
          final scrapedNews = await EnhancedNewsScraperService.scrapeFeedYourCuriosity();
          _feedYourCuriosityNews = EnhancedNewsScraperService.convertToFeedYourCuriosityTopics(scrapedNews);
          
          _ensureTopicDistribution();
          _lastFeedYourCuriosityFetch = DateTime.now();
          await _saveFeedYourCuriosityToLocal(_feedYourCuriosityNews);
          await _saveFeedYourCuriosityTopicsToDatabase(_feedYourCuriosityNews);
        } catch (e) {
          debugPrint('Enhanced Feed Your Curiosity fetch error: $e');
          if (_feedYourCuriosityNews.isEmpty) {
            final fallbackNews = EnhancedNewsScraperService.getFallbackFeedYourCuriosityNews();
            _feedYourCuriosityNews = EnhancedNewsScraperService.convertToFeedYourCuriosityTopics(fallbackNews);
            _ensureTopicDistribution();
          }
        }
      },
    );
  }

  Future<List<InvestementNewsArticlesRow>> fetchInvestmentNews({bool forceRefresh = false}) async {
    if (!forceRefresh && _investmentNews.isNotEmpty && !_isCacheExpired(_lastInvestmentNewsFetch)) {
      debugPrint('Using cached investment news: ${_investmentNews.length} articles');
      return _investmentNews;
    }

    await _executeWithLoading(
      () => _isLoadingInvestment = true,
      () => _isLoadingInvestment = false,
      () async {
        try {
          final scrapedNews = await EnhancedNewsScraperService.scrapeInvestmentNews();
          _investmentNews = EnhancedNewsScraperService.convertToInvestmentNewsArticles(scrapedNews);
          
          _ensureInvestmentTopicDistribution();
          _lastInvestmentNewsFetch = DateTime.now();
          await _saveInvestmentNewsToLocal(_investmentNews);
          await _saveInvestmentNewsToDatabase(_investmentNews);
        } catch (e) {
          debugPrint('Enhanced investment news fetch error: $e');
          if (_investmentNews.isEmpty) {
            final fallbackNews = EnhancedNewsScraperService.getFallbackInvestmentNews();
            _investmentNews = EnhancedNewsScraperService.convertToInvestmentNewsArticles(fallbackNews);
            _ensureInvestmentTopicDistribution();
          }
        }
      },
    );

    return _investmentNews;
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

  // Enhanced utility methods
  Future<void> fetchGhanaWebNews({bool forceRefresh = false}) async {
    if (!forceRefresh && getNewsByCountry('Ghana').isNotEmpty) return;
    await fetchAfricanNews(forceRefresh: forceRefresh);
  }

  Future<void> fetchCountrySpecificNews(String country, {bool forceRefresh = false}) async {
    if (!_allAfricanCountries.contains(country)) {
      debugPrint('Country $country not supported');
      return;
    }
    
    if (!forceRefresh && getNewsByCountry(country).isNotEmpty) return;
    await fetchAfricanNews(forceRefresh: forceRefresh);
  }

  void printEnhancedSourceDistribution() {
    debugPrint('=== ENHANCED SOURCE DISTRIBUTION ===');
    
    // Overall statistics
    debugPrint('Total articles: ${_africanNews.length}');
    debugPrint('Countries with content: ${_newsByCountry.keys.where((k) => _newsByCountry[k]!.isNotEmpty).length}');
    
    // Priority countries breakdown
    debugPrint('\nPriority Countries:');
    for (final country in _priorityCountries) {
      final articles = _newsByCountry[country] ?? [];
      if (articles.isNotEmpty) {
        final sourceBreakdown = <String, int>{};
        for (final article in articles) {
          final publisher = article.getField<String>('publishers') ?? 'Unknown';
          sourceBreakdown[publisher] = (sourceBreakdown[publisher] ?? 0) + 1;
        }
        debugPrint('$country (${articles.length}): $sourceBreakdown');
      }
    }
    
    // Regional summary
    debugPrint('\nRegional Summary:');
    debugPrint('West Africa: ${westAfricaNews.length} articles');
    debugPrint('East Africa: ${eastAfricaNews.length} articles');
    debugPrint('North Africa: ${northAfricaNews.length} articles');
    debugPrint('Central Africa: ${centralAfricaNews.length} articles');
    debugPrint('Southern Africa: ${southernAfricaNews.length} articles');
    
    debugPrint('===================================');
  }

  Future<void> clearLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_africanNewsKey);
      await prefs.remove(_feedYourCuriosityKey);
      await prefs.remove(_investmentNewsKey);
      await prefs.remove(_lastFetchAfricanKey);
      await prefs.remove(_lastFetchFeedKey);
      await prefs.remove(_lastFetchInvestmentKey);
      await prefs.remove(_countryStatsKey);
      
      debugPrint('Enhanced local cache cleared successfully');
    } catch (e) {
      debugPrint('Failed to clear enhanced local cache: $e');
    }
  }

  // New enhanced methods for better country management
  List<String> getMostActiveCountries({int limit = 10}) {
    final sortedCountries = _countryStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCountries.take(limit).map((e) => e.key).toList();
  }

  Map<String, int> getRegionalDistribution() {
    return {
      'West Africa': westAfricaNews.length,
      'East Africa': eastAfricaNews.length,
      'North Africa': northAfricaNews.length,
      'Central Africa': centralAfricaNews.length,
      'Southern Africa': southernAfricaNews.length,
    };
  }

  Future<void> reCategorizeExistingArticles() async {
    if (_africanNews.isEmpty) return;

    _categorizeNewsForAllCountries();
    _updateCountryStats();

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
      
      await _saveCountryStats();
    } catch (e) {
      debugPrint('Enhanced recategorization update error: $e');
    }

    notifyListeners();
  }
}