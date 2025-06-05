import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:new_force_new_hope/backend/supabase/database/tables/investement_news_articles.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';

class NewsScraperService {
  static const Map<String, List<String>> _countrySources = {
    'Ghana': ['https://www.ghanaweb.com', 'https://www.graphic.com.gh'],
    'Nigeria': ['https://punchng.com', 'https://www.vanguardngr.com'],
    'Kenya': ['https://www.nation.co.ke', 'https://www.the-star.co.ke'],
    'South Africa': ['https://www.news24.com', 'https://www.iol.co.za'],
    'Ethiopia': ['https://addisstandard.com', 'https://www.ena.et'],
  };

  static Map<String, RegExp> _countryPatterns = {
    'Ghana': RegExp(r'\b(ghana|ghanaian|accra|kumasi|tamale|akufo-addo|mahama|cedi|ashanti|volta|cocoa|black stars)\b', caseSensitive: false),
    'Nigeria': RegExp(r'\b(nigeria|nigerian|lagos|abuja|tinubu|buhari|naira|nollywood|boko haram|nnpc|niger delta)\b', caseSensitive: false),
    'Kenya': RegExp(r'\b(kenya|kenyan|nairobi|mombasa|ruto|kenyatta|shilling|safari|masai|safaricom|m-pesa)\b', caseSensitive: false),
    'South Africa': RegExp(r'\b(south africa|johannesburg|cape town|ramaphosa|zuma|rand|apartheid|anc|kruger)\b', caseSensitive: false),
    'Ethiopia': RegExp(r'\b(ethiopia|ethiopian|addis ababa|abiy ahmed|birr|orthodox|amhara|oromo|tigray)\b', caseSensitive: false),
  };

  static const List<String> _defaultImages = [
    'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1564415315949-7a0c4c73aab4?w=800&h=600&fit=crop'
  ];

  static Map<String, RegExp> _topicPatterns = {
    'African Culture & Lifestyle': RegExp(r'\b(art|culture|heritage|tradition|music|dance|festival|language|history|museum|artist|cultural|traditional|ceremony|ritual)\b', caseSensitive: false),
    'African Agriculture': RegExp(r'\b(agriculture|farming|crop|harvest|farm|food|production|livestock|irrigation|farmer|agricultural|rural|cocoa|coffee|maize|rice)\b', caseSensitive: false),
    'African Technology': RegExp(r'\b(technology|tech|digital|innovation|startup|fintech|mobile|app|software|internet|computer|artificial intelligence|ai|innovation)\b', caseSensitive: false),
    'trade': RegExp(r'\b(trade|export|import|tariff|customs|commerce|trading|market access|business|economy|economic|gdp|growth|development)\b', caseSensitive: false),
    'stocks': RegExp(r'\b(stock|share|equity|market|index|investor|investment|portfolio|dividend|financial|finance|bank|banking|currency|exchange)\b', caseSensitive: false),
    'real estate': RegExp(r'\b(real estate|property|housing|land|building|construction|development|residential|commercial|mortgage|rent)\b', caseSensitive: false),
    'politics': RegExp(r'\b(politics|government|policy|election|vote|campaign|parliament|legislation|political|minister|president|leader|governance)\b', caseSensitive: false),
    'energy': RegExp(r'\b(energy|power|electricity|renewable|solar|wind|hydro|oil|gas|petroleum|coal|nuclear|fuel|grid)\b', caseSensitive: false),
  };

  static Future<List<Map<String, dynamic>>> scrapeAfricaNews() async {
    try {
      final allArticles = <Map<String, dynamic>>[];
      
      for (final entry in _countrySources.entries) {
        final country = entry.key;
        final sources = entry.value;
        
        print('DEBUG: Scraping for $country from ${sources.length} sources');
        
        for (final source in sources) {
          try {
            final articles = await _scrapeCountrySource(source, country);
            print('DEBUG: Got ${articles.length} articles from $source for $country');
            
            for (final article in articles) {
              article['country'] = country;
              allArticles.add(article);
            }
            
            if (allArticles.length >= 50) break;
          } catch (e) {
            print('DEBUG: Failed to scrape $source: $e');
            continue;
          }
        }
        
        if (allArticles.length >= 50) break;
      }

      print('DEBUG: Total scraped articles: ${allArticles.length}');
      final countryDistribution = <String, int>{};
      for (final article in allArticles) {
        final country = article['country'] ?? 'Unknown';
        countryDistribution[country] = (countryDistribution[country] ?? 0) + 1;
      }
      print('DEBUG: Scraped country distribution: $countryDistribution');

      if (allArticles.isEmpty) {
        print('DEBUG: No articles scraped, using fallback');
        return getFallbackAfricanNews();
      }

      return allArticles;
    } catch (e) {
      print('DEBUG: Scraping failed completely: $e');
      return getFallbackAfricanNews();
    }
  }

  static Future<List<Map<String, dynamic>>> _scrapeCountrySource(String url, String targetCountry) async {
    try {
      final response = await _makeRequest(url);
      if (response == null || response.statusCode != 200) return [];

      final document = html_parser.parse(response.body);
      final articles = <Map<String, dynamic>>[];

      final articleElements = _findArticleElements(document);
      
      for (final element in articleElements.take(10)) {
        final article = await _extractArticleData(element, url, targetCountry);
        if (article != null) {
          articles.add(article);
        }
      }

      return articles;
    } catch (e) {
      return [];
    }
  }

  static Future<http.Response?> _makeRequest(String url) async {
    try {
      return await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      return null;
    }
  }

  static List<dynamic> _findArticleElements(dynamic document) {
    final selectors = [
      'article', '.article', '.news-item', '.post', '.story',
      '.content-item', '.news-block', 'a[href*="news"]', 'a[href*="article"]'
    ];

    for (final selector in selectors) {
      final elements = document.querySelectorAll(selector);
      if (elements.length >= 5) return elements;
    }
    
    return document.querySelectorAll('article');
  }

  static Future<Map<String, dynamic>?> _extractArticleData(dynamic element, String baseUrl, String targetCountry) async {
    final title = _extractTitle(element);
    if (title.isEmpty || title.length < 10) return null;

    final articleUrl = _extractUrl(element, baseUrl);
    final imageUrl = _extractImageUrl(element, baseUrl);
    final description = _extractDescription(element, targetCountry, title);
    
    if (description.isEmpty) return null;
    
    return {
      'title': title,
      'description': description,
      'publishers': _getPublisherFromUrl(baseUrl),
      'articleUrl': articleUrl,
      'image': imageUrl,
      'articeImage': imageUrl,
      'articleBody': description,
      'content': description,
      'urlLink': articleUrl,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static String _extractTitle(dynamic element) {
    final selectors = ['h1 a', 'h2 a', 'h3 a', '.title a', 'a', 'h1', 'h2', 'h3'];
    
    for (final selector in selectors) {
      final titleElement = element.querySelector(selector);
      if (titleElement != null) {
        final title = titleElement.text.trim();
        if (title.isNotEmpty) return title;
      }
    }
    
    return '';
  }

  static String _extractUrl(dynamic element, String baseUrl) {
    final linkElement = element.querySelector('a');
    var articleUrl = linkElement?.attributes['href'] ?? '';
    
    if (articleUrl.isNotEmpty && !articleUrl.startsWith('http')) {
      final uri = Uri.parse(baseUrl);
      articleUrl = articleUrl.startsWith('/') 
        ? '${uri.scheme}://${uri.host}$articleUrl'
        : '${uri.scheme}://${uri.host}/$articleUrl';
    }
    
    return articleUrl;
  }

  static String _extractImageUrl(dynamic element, String baseUrl) {
    final imageElement = element.querySelector('img');
    if (imageElement == null) return _getDefaultImageUrl();

    var imageUrl = imageElement.attributes['src'] ??
        imageElement.attributes['data-src'] ??
        imageElement.attributes['data-lazy-src'] ?? '';

    if (imageUrl.isEmpty || imageUrl.startsWith('data:')) {
      return _getDefaultImageUrl();
    }

    if (!imageUrl.startsWith('http')) {
      final uri = Uri.parse(baseUrl);
      if (imageUrl.startsWith('//')) {
        imageUrl = '${uri.scheme}:$imageUrl';
      } else if (imageUrl.startsWith('/')) {
        imageUrl = '${uri.scheme}://${uri.host}$imageUrl';
      } else {
        imageUrl = '${uri.scheme}://${uri.host}/$imageUrl';
      }
    }

    return imageUrl;
  }

  static String _extractDescription(dynamic element, String targetCountry, String title) {
    final selectors = ['p', '.excerpt', '.summary', '.description'];
    
    for (final selector in selectors) {
      final descElement = element.querySelector(selector);
      if (descElement != null) {
        final desc = descElement.text.trim();
        if (desc.isNotEmpty) return desc;
      }
    }
    
    return 'Latest news from $targetCountry - $title';
  }

  static Future<String> _getArticleContent(String url) async {
    if (url.isEmpty) return '';

    try {
      final response = await _makeRequest(url);
      if (response?.statusCode != 200) return '';

      final document = html_parser.parse(response!.body);
      
      document.querySelectorAll('script, style, nav, header, footer, .ad, .advertisement').forEach((el) => el.remove());

      final contentSelectors = [
        '.article-content', '.entry-content', '.post-content', '.story-content',
        'article .content', '.news-content', '.article-body', '.main-content'
      ];

      for (final selector in contentSelectors) {
        final contentElement = document.querySelector(selector);
        if (contentElement != null) {
          final paragraphs = contentElement.querySelectorAll('p');
          if (paragraphs.length >= 2) {
            final content = paragraphs
                .map((p) => p.text.trim())
                .where((text) => text.isNotEmpty && text.length > 20)
                .take(5)
                .join('\n\n');
            
            if (content.length > 100) {
              return content.length > 1000 ? '${content.substring(0, 1000)}...' : content;
            }
          }
        }
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  static String _getDefaultImageUrl() {
    final index = DateTime.now().millisecondsSinceEpoch % _defaultImages.length;
    return _defaultImages[index];
  }

  static String _getPublisherFromUrl(String url) {
    final host = Uri.parse(url).host.toLowerCase();
    
    const publisherMap = {
      'ghanaweb': 'GhanaWeb',
      'graphic.com.gh': 'Daily Graphic',
      'punchng': 'Punch Newspapers',
      'vanguardngr': 'Vanguard',
      'nation.co.ke': 'Daily Nation',
      'the-star.co.ke': 'The Star Kenya',
      'news24': 'News24',
      'timeslive.co.za': 'TimesLive',
      'addisstandard': 'Addis Standard',
      'ena.et': 'Ethiopian News Agency',
    };

    for (final entry in publisherMap.entries) {
      if (host.contains(entry.key)) return entry.value;
    }
    
    return 'African News Source';
  }

  static List<Map<String, dynamic>> _categorizeArticles(List<Map<String, dynamic>> articles) {
    final countries = _countrySources.keys.toList();
    
    for (int i = 0; i < articles.length; i++) {
      final article = articles[i];
      final title = article['title'] ?? '';
      final description = article['description'] ?? '';
      final publisher = article['publishers'] ?? '';
      
      String country = _categorizeByCountry(title, description);
      
      if (country == 'General Africa') {
        country = _categorizeByPublisher(publisher);
      }
      
      if (country == 'General Africa') {
        country = countries[i % countries.length];
      }
      
      article['country'] = country;
    }
    
    return articles;
  }

  static String _categorizeByPublisher(String publisher) {
    final publisherLower = publisher.toLowerCase();
    
    if (publisherLower.contains('ghanaweb') || publisherLower.contains('graphic')) {
      return 'Ghana';
    }
    if (publisherLower.contains('punch') || publisherLower.contains('vanguard')) {
      return 'Nigeria';
    }
    if (publisherLower.contains('nation') || publisherLower.contains('star')) {
      return 'Kenya';
    }
    if (publisherLower.contains('news24') || publisherLower.contains('times')) {
      return 'South Africa';
    }
    if (publisherLower.contains('addis') || publisherLower.contains('ena')) {
      return 'Ethiopia';
    }
    
    return 'General Africa';
  }

  static String _categorizeByCountry(String title, String description) {
    final text = '$title $description'.toLowerCase();
    
    for (final entry in _countryPatterns.entries) {
      if (entry.value.hasMatch(text)) {
        return entry.key;
      }
    }
    
    return 'General Africa';
  }

  static Future<List<Map<String, dynamic>>> scrapeInvestmentNews() async {
    print('DEBUG Investment: Starting investment news scraping');
    final articles = await scrapeAfricaNews();
    print('DEBUG Investment: Got ${articles.length} articles from scrapeAfricaNews');
    
    final investmentKeywords = RegExp(r'\b(trade|stock|investment|economy|business|finance|market|banking|gdp|revenue|real estate|property|energy|power|oil|gas|politics|government|policy|commodities|gold|oil|copper|agriculture)\b', caseSensitive: false);
    
    final investmentArticles = articles.where((article) {
      final text = '${article['title']} ${article['description']}'.toLowerCase();
      return investmentKeywords.hasMatch(text);
    }).toList();
    
    print('DEBUG Investment: Filtered to ${investmentArticles.length} investment articles');
    
    if (investmentArticles.length < 30) {
      final additionalArticles = articles.where((article) => !investmentArticles.contains(article)).take(30 - investmentArticles.length);
      investmentArticles.addAll(additionalArticles);
      print('DEBUG Investment: Added ${additionalArticles.length} additional articles for total of ${investmentArticles.length}');
    }
    
    final investmentTopics = ['Trade', 'Stocks', 'Real Estate', 'Energy', 'Politics', 'Commodities'];
    
    for (int i = 0; i < investmentArticles.length; i++) {
      final article = investmentArticles[i];
      final title = article['title'] ?? '';
      final description = article['description'] ?? '';
      final content = article['content'] ?? '';
      
      String assignedTopic = _categorizeByInvestmentTopic(title, description, content);
      
      if (assignedTopic == 'unknown') {
        assignedTopic = investmentTopics[i % investmentTopics.length];
      }
      
      article['tag'] = assignedTopic;
    }
    
    final tagCounts = <String, int>{};
    for (final article in investmentArticles) {
      final tag = article['tag'] ?? 'unknown';
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }
    print('DEBUG Investment: Tag distribution: $tagCounts');
    
    return investmentArticles;
  }

  static String _categorizeByInvestmentTopic(String title, String description, String content) {
    final text = '$title $description $content'.toLowerCase();
    
    if (RegExp(r'\b(trade|export|import|commerce|trading|business|economy|economic|gdp)\b', caseSensitive: false).hasMatch(text)) {
      return 'Trade';
    }
    if (RegExp(r'\b(stock|share|equity|market|index|investor|investment|portfolio|dividend|financial|finance|bank|banking)\b', caseSensitive: false).hasMatch(text)) {
      return 'Stocks';
    }
    if (RegExp(r'\b(real estate|property|housing|land|building|construction|development|residential|commercial)\b', caseSensitive: false).hasMatch(text)) {
      return 'Real Estate';
    }
    if (RegExp(r'\b(energy|power|electricity|renewable|solar|wind|hydro|oil|gas|petroleum|coal|nuclear)\b', caseSensitive: false).hasMatch(text)) {
      return 'Energy';
    }
    if (RegExp(r'\b(politics|government|policy|election|vote|campaign|parliament|legislation|political|minister|president|leader|governance)\b', caseSensitive: false).hasMatch(text)) {
      return 'Politics';
    }
    if (RegExp(r'\b(commodities|gold|silver|copper|platinum|cocoa|coffee|cotton|sugar|wheat|corn|rice|agriculture|mining|metals|crude)\b', caseSensitive: false).hasMatch(text)) {
      return 'Commodities';
    }
    
    return 'unknown';
  }

  static Future<List<Map<String, dynamic>>> scrapeFeedYourCuriosity() async {
    final articles = await scrapeAfricaNews();
    final topics = _topicPatterns.keys.toList();
    
    for (int i = 0; i < articles.length; i++) {
      final article = articles[i];
      final title = article['title'] ?? '';
      final description = article['description'] ?? '';
      final content = article['content'] ?? '';
      
      String assignedTopic = _categorizeByTopic(title, description, content);
      
      if (i < topics.length) {
        assignedTopic = topics[i % topics.length];
      }
      
      article['tag'] = assignedTopic;
    }
    
    return articles;
  }

  static String _categorizeByTopic(String title, String description, String content) {
    final text = '$title $description $content'.toLowerCase();
    
    for (final entry in _topicPatterns.entries) {
      if (entry.value.hasMatch(text)) {
        return entry.key;
      }
    }
    
    final topics = _topicPatterns.keys.toList();
    final hash = text.hashCode.abs();
    return topics[hash % topics.length];
  }

  static List<NewForceArticlesRow> convertToNewForceArticles(List<Map<String, dynamic>> articles) {
    return articles.map((article) => NewForceArticlesRow({
      'title': article['title'] ?? 'No Title',
      'description': article['description'] ?? 'No description available',
      'articleBody': article['articleBody'] ?? article['content'] ?? 'No content available',
      'articleImage': article['image'] ?? _getDefaultImageUrl(),
      'publishers': article['publishers'] ?? 'Unknown Publisher',
      'created_at': article['created_at'] ?? DateTime.now().toIso8601String(),
      'articleUrl': article['articleUrl'] ?? '',
      'country': article['country'] ?? 'General Africa',
    })).toList();
  }

  static List<FeedYourCuriosityTopicsRow> convertToFeedYourCuriosityTopics(List<Map<String, dynamic>> articles) {
    return articles.map((article) => FeedYourCuriosityTopicsRow({
      'title': article['title'] ?? 'No Title',
      'newsDescription': article['description'] ?? 'No description available',
      'newsBody': article['content'] ?? article['articleBody'] ?? 'No content available',
      'image': article['image'] ?? _getDefaultImageUrl(),
      'publisher': article['publishers'] ?? 'Unknown Publisher',
      'created_at': article['created_at'] ?? DateTime.now().toIso8601String(),
      'tag': article['tag'] ?? 'African Technology',
      'publisherImageUrl': article['publisherImageUrl'] ?? ''
    })).toList();
  }

  static List<InvestementNewsArticlesRow> convertToInvestmentNewsArticles(List<Map<String, dynamic>> articles) {
    return articles.map((article) => InvestementNewsArticlesRow({
      'title': article['title'] ?? 'No Title',
      'description': article['description'] ?? 'No description available',
      'newsDescription': article['content'] ?? article['articleBody'] ?? 'No content available',
      'image': article['image'] ?? _getDefaultImageUrl(),
      'publisher': article['publishers'] ?? 'Unknown Publisher',
      'created_at': article['created_at'] ?? DateTime.now().toIso8601String(),
      'tag': article['tag'] ?? 'Trade',
      'publisherImageUrl': article['publisherImageUrl'] ?? '',
    })).toList();
  }

  static List<Map<String, dynamic>> getFallbackAfricanNews() {
    final now = DateTime.now().toIso8601String();
    final topics = _topicPatterns.keys.toList();
    final countries = _countrySources.keys.toList();
    final fallbackArticles = <Map<String, dynamic>>[];
    
    final baseArticles = [
      _createFallbackArticle('President Tinubu Announces New Economic Reforms', 'Nigerian President Bola Tinubu unveils comprehensive economic reform package aimed at boosting trade and investment.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Cocoa Production Sets New Records', 'Ghanaian farmers achieve bumper cocoa harvest with strong export performance and agricultural innovation.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('East Africa Leads in Renewable Energy', 'Kenyan companies pioneer solar and wind energy solutions across the region.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Rand Strengthens Against Dollar', 'South Africa sees currency gains amid economic optimism and improved market conditions.', 'News24', 'South Africa', now),
      _createFallbackArticle('Airlines Expand Technology Services', 'Ethiopian national carrier announces new digital innovations and tech-driven services.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Music Festival Celebrates Heritage', 'Traditional festival showcases diverse musical traditions and artistic expressions.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Housing Development Transforms Cities', 'Major real estate project brings modern residential options to growing urban areas.', 'Punch Newspapers', 'Nigeria', now),
      _createFallbackArticle('Leaders Meet for Regional Integration', 'Government officials discuss enhanced cooperation and policy harmonization.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Stock Markets Show Strong Growth', 'Stock exchanges report increased investor confidence and market expansion.', 'News24', 'South Africa', now),
      _createFallbackArticle('Mobile Banking Revolution Continues', 'Digital payment platforms expand financial inclusion across communities.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Agricultural Innovation Boosts Security', 'New farming techniques and technology improve crop yields significantly.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Solar Power Projects Expand', 'Renewable energy initiatives bring electricity to rural communities.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Heritage Sites Gain Recognition', 'Historical sites receive international protection and tourism boost.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Tech Startups Attract Investment', 'Technology companies secure major funding for expansion plans.', 'News24', 'South Africa', now),
      _createFallbackArticle('Trade Agreements Boost Commerce', 'New partnerships increase economic cooperation between nations.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Property Market Shows Resilience', 'Real estate sector demonstrates growth despite economic challenges.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Digital Payment Systems Expand', 'Fintech innovations drive cashless economy transformation.', 'Punch Newspapers', 'Nigeria', now),
      _createFallbackArticle('Green Energy Creates Jobs', 'Sustainable development initiatives provide employment opportunities.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Youth Entrepreneurs Drive Innovation', 'Young business leaders launch successful ventures in technology.', 'News24', 'South Africa', now),
      _createFallbackArticle('Financial Markets Respond to Policy', 'Investment climate improves with business-friendly reforms.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Mining Adopts Sustainable Practices', 'Resource companies invest in environmental protection.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Educational Technology Bridges Gap', 'E-learning platforms provide quality education access.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Healthcare Innovation Improves Care', 'Medical technology advances enhance treatment quality.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Infrastructure Connects Markets', 'New transportation projects facilitate regional trade.', 'News24', 'South Africa', now),
      _createFallbackArticle('Fashion Industry Showcases Creativity', 'Local designers gain international recognition.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Food Processing Boosts Agriculture', 'Agribusiness investments create farmer opportunities.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Tourism Sector Recovers Strongly', 'Travel industry adapts with new destinations.', 'Punch Newspapers', 'Nigeria', now),
      _createFallbackArticle('Water Management Addresses Scarcity', 'Engineering solutions provide sustainable water access.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('Creative Arts Gain Global Attention', 'Artists and musicians achieve international acclaim.', 'News24', 'South Africa', now),
      _createFallbackArticle('Trade Bloc Reduces Barriers', 'Continental Free Trade Area facilitates business operations.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Smart Cities Transform Planning', 'Technology integration improves public services.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Renewable Manufacturing Expands', 'Local solar panel production reduces imports.', 'Vanguard', 'Nigeria', now),
    ];
    
    for (int i = 0; i < baseArticles.length; i++) {
      final article = baseArticles[i];
      article['tag'] = topics[i % topics.length];
      fallbackArticles.add(article);
    }
    
    return fallbackArticles;
  }

  static Map<String, dynamic> _createFallbackArticle(String title, String description, String publisher, String country, String timestamp) {
    return {
      'title': title,
      'description': description,
      'publishers': publisher,
      'articleUrl': '',
      'image': _getDefaultImageUrl(),
      'articeImage': _getDefaultImageUrl(),
      'articleBody': description,
      'content': description,
      'urlLink': '',
      'country': country,
      'created_at': timestamp,
    };
  }

  static List<Map<String, dynamic>> getFallbackInvestmentNews() {
    final now = DateTime.now().toIso8601String();
    final investmentTopics = ['Trade', 'Stocks', 'Real Estate', 'Energy', 'Politics', 'Commodities'];
    final fallbackArticles = <Map<String, dynamic>>[];
    
    final baseArticles = [
      _createFallbackArticle('Nigeria Boosts Export Trade Revenue', 'Nigerian government announces new trade policies to increase export revenue and economic growth.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Ghana Stock Exchange Shows Growth', 'Ghanaian stock market reports strong performance with increased investor participation.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Kenya Real Estate Market Expands', 'Kenyan property developers launch new residential projects in major cities.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('South Africa Energy Sector Investment', 'South African renewable energy projects attract significant foreign investment.', 'News24', 'South Africa', now),
      _createFallbackArticle('Ethiopia Political Reforms Progress', 'Ethiopian government implements new democratic reforms and governance initiatives.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Ghana Gold Production Increases', 'Ghanaian mining sector reports record gold output and commodity exports.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Nigeria Trade Agreements Signed', 'Nigerian leaders finalize new international trade partnerships and agreements.', 'Punch Newspapers', 'Nigeria', now),
      _createFallbackArticle('Kenya Stock Market Index Rises', 'Kenyan financial markets show strong performance with increased trading volume.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('South Africa Property Investment', 'Commercial real estate sector attracts significant domestic and foreign investment.', 'News24', 'South Africa', now),
      _createFallbackArticle('Ethiopia Solar Energy Projects', 'Renewable energy initiatives expand across Ethiopian regions with government support.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Ghana Political Stability Noted', 'International observers praise Ghanaian democratic institutions and electoral processes.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Nigeria Cocoa Export Surge', 'Nigerian agricultural commodity exports reach new highs in international markets.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Kenya International Trade Growth', 'East African trade hub sees increased cargo and commercial activity.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('South Africa Financial Markets', 'JSE and banking sector demonstrate resilience amid global economic challenges.', 'News24', 'South Africa', now),
      _createFallbackArticle('Ethiopia Infrastructure Development', 'Major construction projects advance real estate and urban development sectors.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Ghana Renewable Energy Drive', 'Solar and wind power installations increase national energy capacity significantly.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Nigeria Electoral Reforms Advance', 'Democratic institutions strengthen with new electoral and governance legislation.', 'Punch Newspapers', 'Nigeria', now),
      _createFallbackArticle('Kenya Coffee Export Success', 'Premium coffee beans command higher prices in international commodity markets.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('South Africa Trade Relations', 'Regional trade partnerships expand with neighboring African countries.', 'News24', 'South Africa', now),
      _createFallbackArticle('Ethiopia Investment Climate', 'Foreign direct investment increases as business environment improves significantly.', 'Addis Standard', 'Ethiopia', now),
      _createFallbackArticle('Ghana Housing Development', 'Affordable housing projects address urban growth and real estate demand.', 'GhanaWeb', 'Ghana', now),
      _createFallbackArticle('Nigeria Power Generation', 'Energy sector reforms boost electricity generation and distribution capacity nationwide.', 'Vanguard', 'Nigeria', now),
      _createFallbackArticle('Kenya Governance Improvements', 'Anti-corruption measures and transparency initiatives gain momentum in government.', 'Daily Nation', 'Kenya', now),
      _createFallbackArticle('South Africa Mining Output', 'Platinum and gold mining operations report increased production and revenue.', 'News24', 'South Africa', now),
    ];
    
    for (int i = 0; i < baseArticles.length; i++) {
      final article = baseArticles[i];
      article['tag'] = investmentTopics[i % investmentTopics.length];
      fallbackArticles.add(article);
    }
    
    return fallbackArticles;
  }
  static List<Map<String, dynamic>> getFallbackFeedYourCuriosityNews() => getFallbackAfricanNews();
}