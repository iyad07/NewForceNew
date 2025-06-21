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
      
      final futures = <Future<Map<String, dynamic>?>>[];
      
      for (final element in articleElements.take(15)) {
        futures.add(_extractArticleWithContent(element, url, targetCountry));
      }
      
      final results = await Future.wait(futures);
      
      for (final article in results) {
        if (article != null && article['content'] != null && article['content'].toString().length > 100) {
          articles.add(article);
          if (articles.length >= 10) break;
        }
      }

      return articles;
    } catch (e) {
      print('DEBUG: Error scraping $url: $e');
      return [];
    }
  }

  static Future<http.Response?> _makeRequest(String url) async {
    try {
      return await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
        }
      ).timeout(const Duration(seconds: 15));
    } catch (e) {
      return null;
    }
  }

  static List<dynamic> _findArticleElements(dynamic document) {
    final selectors = [
      'article',
      '.article',
      '.news-item', 
      '.post',
      '.story',
      '.content-item',
      '.news-block',
      'a[href*="news"]',
      'a[href*="article"]',
      '.entry',
      '.blog-post'
    ];

    for (final selector in selectors) {
      final elements = document.querySelectorAll(selector);
      if (elements.length >= 5) return elements;
    }
    
    return document.querySelectorAll('article, .article, .news-item');
  }

  static Future<Map<String, dynamic>?> _extractArticleWithContent(dynamic element, String baseUrl, String targetCountry) async {
    final title = _extractTitle(element);
    if (title.isEmpty || title.length < 10) return null;

    final articleUrl = _extractUrl(element, baseUrl);
    final imageUrl = _extractImageUrl(element, baseUrl);
    final shortDescription = _extractDescription(element, targetCountry, title);
    
    print('DEBUG: Processing article: $title');
    print('DEBUG: Article URL: $articleUrl');
    
    String fullContent = '';
    if (articleUrl.isNotEmpty) {
      fullContent = await _scrapeFullArticleContent(articleUrl);
    }
    
    if (fullContent.isEmpty) {
      fullContent = shortDescription.isNotEmpty ? shortDescription : 'Content not available for this article.';
    }
    
    if (fullContent.length < 50) return null;
    
    print('DEBUG: Content length: ${fullContent.length}');
    
    return {
      'title': title,
      'description': shortDescription.isNotEmpty ? shortDescription : _generateDescription(fullContent),
      'publishers': _getPublisherFromUrl(baseUrl),
      'articleUrl': articleUrl,
      'image': imageUrl,
      'articeImage': imageUrl,
      'articleBody': fullContent,
      'content': fullContent,
      'urlLink': articleUrl,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static Future<String> _scrapeFullArticleContent(String articleUrl) async {
    if (articleUrl.isEmpty) return '';

    try {
      print('DEBUG: Fetching content from: $articleUrl');
      final response = await _makeRequest(articleUrl);
      if (response?.statusCode != 200) {
        print('DEBUG: Failed to fetch article: ${response?.statusCode}');
        return '';
      }

      final document = html_parser.parse(response!.body);
      
      document.querySelectorAll('script, style, nav, header, footer, .ad, .advertisement, .sidebar, .related, .comments, .social-share, .newsletter').forEach((el) => el.remove());

      final contentSelectors = [
        '.article-content',
        '.entry-content', 
        '.post-content',
        '.story-content',
        'article .content',
        '.news-content',
        '.article-body',
        '.main-content',
        '.story-body',
        '.post-body',
        '.article-text',
        '.news-article-content',
        '.entry-body',
        '[data-module="ArticleBody"]',
        '.field-name-body',
        '.content-body'
      ];

      String bestContent = '';
      int maxLength = 0;

      for (final selector in contentSelectors) {
        final contentElement = document.querySelector(selector);
        if (contentElement != null) {
          final paragraphs = contentElement.querySelectorAll('p');
          if (paragraphs.isNotEmpty) {
            final content = paragraphs
                .map((p) => p.text.trim())
                .where((text) => text.isNotEmpty && text.length > 30)
                .join('\n\n');
            
            if (content.length > maxLength) {
              maxLength = content.length;
              bestContent = content;
            }
          }
        }
      }

      if (bestContent.isEmpty) {
        final allParagraphs = document.querySelectorAll('p');
        final mainContent = allParagraphs
            .map((p) => p.text.trim())
            .where((text) => text.isNotEmpty && text.length > 50 && !_isNavigationText(text))
            .take(10)
            .join('\n\n');
        
        if (mainContent.length > bestContent.length) {
          bestContent = mainContent;
        }
      }

      if (bestContent.length > 2000) {
        bestContent = '${bestContent.substring(0, 2000)}...';
      }

      print('DEBUG: Extracted content length: ${bestContent.length}');
      return bestContent;
    } catch (e) {
      print('DEBUG: Error fetching article content: $e');
      return '';
    }
  }

  static bool _isNavigationText(String text) {
    final navKeywords = ['click here', 'read more', 'next page', 'previous', 'menu', 'home', 'contact', 'about', 'privacy', 'terms', 'subscribe', 'newsletter'];
    final lowerText = text.toLowerCase();
    return navKeywords.any((keyword) => lowerText.contains(keyword)) || text.length < 50;
  }

  static String _generateDescription(String content) {
    if (content.isEmpty) return 'No description available';
    
    final sentences = content.split(RegExp(r'[.!?]+'));
    final firstSentence = sentences.firstWhere(
      (sentence) => sentence.trim().length > 20,
      orElse: () => content.substring(0, content.length > 150 ? 150 : content.length),
    ).trim();
    
    return firstSentence.length > 200 ? '${firstSentence.substring(0, 200)}...' : firstSentence;
  }

  static String _extractTitle(dynamic element) {
    final selectors = [
      'h1 a', 'h2 a', 'h3 a', 'h4 a',
      '.title a', '.headline a', 
      'a .title', 'a .headline',
      'a h1', 'a h2', 'a h3',
      'a', 'h1', 'h2', 'h3'
    ];
    
    for (final selector in selectors) {
      final titleElement = element.querySelector(selector);
      if (titleElement != null) {
        final title = titleElement.text.trim();
        if (title.isNotEmpty && title.length > 10) return title;
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
        imageElement.attributes['data-lazy-src'] ??
        imageElement.attributes['data-original'] ?? '';

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
    final selectors = ['p', '.excerpt', '.summary', '.description', '.lead', '.intro'];
    
    for (final selector in selectors) {
      final descElement = element.querySelector(selector);
      if (descElement != null) {
        final desc = descElement.text.trim();
        if (desc.isNotEmpty && desc.length > 20) return desc;
      }
    }
    
    return 'Latest news from $targetCountry - $title';
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
      final text = '${article['title']} ${article['description']} ${article['content']}'.toLowerCase();
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
      'articleBody': article['content'] ?? article['articleBody'] ?? 'No content available',
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
      _createFallbackArticle(
        'President Tinubu Announces New Economic Reforms',
        'Nigerian President Bola Tinubu unveils comprehensive economic reform package aimed at boosting trade and investment.',
        'Nigerian President Bola Tinubu has announced a comprehensive economic reform package designed to stimulate growth and attract foreign investment. The reforms include tax incentives for businesses, streamlined regulatory processes, and infrastructure development initiatives. Speaking at the presidential villa in Abuja, Tinubu emphasized the government\'s commitment to creating a business-friendly environment that will foster economic prosperity for all Nigerians. The package also includes measures to support small and medium enterprises, improve access to credit, and enhance the country\'s competitiveness in global markets.',
        'Vanguard',
        'Nigeria',
        now
      ),
      _createFallbackArticle(
        'Cocoa Production Sets New Records',
        'Ghanaian farmers achieve bumper cocoa harvest with strong export performance and agricultural innovation.',
        'Ghana\'s cocoa industry has achieved record-breaking production levels this season, with farmers reporting exceptional yields across major cocoa-growing regions. The Ghana Cocoa Board attributes this success to improved farming techniques, better seedlings, and favorable weather conditions. Farmers in the Ashanti, Western, and Eastern regions have particularly benefited from new agricultural technologies and training programs. The increased production is expected to boost Ghana\'s foreign exchange earnings significantly, as cocoa remains one of the country\'s primary export commodities. Industry experts predict this trend will continue as more farmers adopt sustainable farming practices.',
        'GhanaWeb',
        'Ghana',
        now
      ),
      _createFallbackArticle(
        'East Africa Leads in Renewable Energy',
        'Kenyan companies pioneer solar and wind energy solutions across the region.',
        'Kenya has emerged as a regional leader in renewable energy development, with several companies launching innovative solar and wind power projects across East Africa. The country\'s commitment to clean energy has attracted significant international investment and technical expertise. Major projects include large-scale solar farms in northern Kenya and wind energy installations along the coast. These initiatives are not only reducing the country\'s carbon footprint but also creating thousands of jobs and improving energy access in rural communities. The government has set ambitious targets to achieve 100% renewable energy by 2030.',
        'Daily Nation',
        'Kenya',
        now
      ),
    ];
    
    for (int i = 0; i < baseArticles.length; i++) {
      final article = baseArticles[i];
      article['tag'] = topics[i % topics.length];
      fallbackArticles.add(article);
    }
    
    return fallbackArticles;
  }

  static Map<String, dynamic> _createFallbackArticle(String title, String description, String content, String publisher, String country, String timestamp) {
    return {
      'title': title,
      'description': description,
      'content': content,
      'publishers': publisher,
      'articleUrl': '',
      'image': _getDefaultImageUrl(),
      'articeImage': _getDefaultImageUrl(),
      'articleBody': content,
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
      _createFallbackArticle(
        'Nigeria Boosts Export Trade Revenue',
        'Nigerian government announces new trade policies to increase export revenue and economic growth.',
        'The Nigerian government has unveiled ambitious trade policies designed to significantly boost export revenue and drive economic growth across multiple sectors. Finance Minister Wale Edun announced comprehensive measures including export incentives, streamlined customs procedures, and enhanced support for exporters. The policies target key sectors such as agriculture, manufacturing, and technology services. Special focus is being placed on non-oil exports to diversify the economy and reduce dependence on petroleum revenues. The government projects these measures will increase export earnings by 40% over the next three years.',
        'Vanguard',
        'Nigeria',
        now
      ),
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