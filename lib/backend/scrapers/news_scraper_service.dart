import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:new_force_new_hope/backend/supabase/database/tables/investement_news_articles.dart';
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';

class EnhancedNewsScraperService {
  // GNews API configuration
  static const String _gnewsApiKey = '7d696cbfd7a14686ae8fd572a29ee718'; // Replace with your actual API key
  static const String _gnewsBaseUrl = 'https://gnews.io/api/v4';
  
  // AfricaNews RSS feeds
  static const List<String> _africaNewsRssFeeds = [
    'https://www.africanews.com/feed/',
    'https://allafrica.com/tools/headlines/rdf/latest/headlines.rdf',
    'https://www.news24.com/feeds/rss/africa/news',
    'https://africa.cgtn.com/rss/africa.xml',
  ];

  // Complete list of all 54 African countries (matching database spellings)
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

  // Country-specific keywords for better categorization (updated to match database spellings)
  static final Map<String, List<String>> _countryKeywords = {
    'Algeria': ['algeria', 'algerian', 'algiers', 'bouteflika', 'tebboune', 'dinar'],
    'Angola': ['angola', 'angolan', 'luanda', 'dos santos', 'lourenco', 'kwanza'],
    'Benin': ['benin', 'beninese', 'porto-novo', 'cotonou', 'talon', 'franc cfa'],
    'Botswana': ['botswana', 'motswana', 'gaborone', 'masisi', 'pula'],
    'Burkina Faso': ['burkina faso', 'burkinabe', 'ouagadougou', 'kabore', 'franc cfa'],
    'Burundi': ['burundi', 'burundian', 'gitega', 'bujumbura', 'ndayishimiye', 'franc'],
    'Cameroon': ['cameroon', 'cameroonian', 'yaounde', 'douala', 'biya', 'franc cfa'],
    'Cape Verde': ['cape verde', 'cabo verde', 'praia', 'neves', 'escudo'],
    'Central African Republic': ['central african republic', 'car', 'bangui', 'touadera', 'franc cfa'],
    'Chad': ['chad', 'chadian', 'n\'djamena', 'deby', 'franc cfa'],
    'Comoros': ['comoros', 'comorian', 'moroni', 'azali', 'franc'],
    'Congo (Kinshasa)': ['congo kinshasa', 'drc', 'democratic republic congo', 'kinshasa', 'tshisekedi', 'franc'],
    'Congo (Brazzaville)': ['congo brazzaville', 'republic congo', 'brazzaville', 'sassou nguesso', 'franc cfa'],
    'Côte d\'Ivoire': ['ivory coast', 'cote d\'ivoire', 'côte d\'ivoire', 'abidjan', 'yamoussoukro', 'ouattara', 'franc cfa'],
    'Djibouti': ['djibouti', 'djiboutian', 'guelleh', 'franc'],
    'Egypt': ['egypt', 'egyptian', 'cairo', 'sisi', 'pound'],
    'Equatorial Guinea': ['equatorial guinea', 'malabo', 'obiang', 'franc cfa'],
    'Eritrea': ['eritrea', 'eritrean', 'asmara', 'afwerki', 'nakfa'],
    'Eswatini': ['eswatini', 'swaziland', 'mbabane', 'mswati', 'lilangeni'],
    'Ethiopia': ['ethiopia', 'ethiopian', 'addis ababa', 'abiy ahmed', 'birr'],
    'Gabon': ['gabon', 'gabonese', 'libreville', 'bongo', 'franc cfa'],
    'Gambia': ['gambia', 'gambian', 'banjul', 'barrow', 'dalasi'],
    'Ghana': ['ghana', 'ghanaian', 'accra', 'akufo-addo', 'cedi'],
    'Guinea': ['guinea', 'guinean', 'conakry', 'conde', 'franc'],
    'Guinea-Bissau': ['guinea-bissau', 'bissau', 'embalo', 'franc cfa'],
    'Kenya': ['kenya', 'kenyan', 'nairobi', 'ruto', 'shilling'],
    'Lesotho': ['lesotho', 'maseru', 'majoro', 'loti'],
    'Liberia': ['liberia', 'liberian', 'monrovia', 'weah', 'dollar'],
    'Libya': ['libya', 'libyan', 'tripoli', 'dbeibeh', 'dinar'],
    'Madagascar': ['madagascar', 'malagasy', 'antananarivo', 'rajoelina', 'ariary'],
    'Malawi': ['malawi', 'malawian', 'lilongwe', 'chakwera', 'kwacha'],
    'Mali': ['mali', 'malian', 'bamako', 'goita', 'franc cfa'],
    'Mauritania': ['mauritania', 'mauritanian', 'nouakchott', 'ghazouani', 'ouguiya'],
    'Mauritius': ['mauritius', 'mauritian', 'port louis', 'jugnauth', 'rupee'],
    'Morocco': ['morocco', 'moroccan', 'rabat', 'casablanca', 'mohammed vi', 'dirham'],
    'Mozambique': ['mozambique', 'mozambican', 'maputo', 'nyusi', 'metical'],
    'Namibia': ['namibia', 'namibian', 'windhoek', 'geingob', 'dollar'],
    'Niger': ['niger', 'nigerien', 'niamey', 'bazoum', 'franc cfa'],
    'Nigeria': ['nigeria', 'nigerian', 'abuja', 'lagos', 'tinubu', 'naira'],
    'Rwanda': ['rwanda', 'rwandan', 'kigali', 'kagame', 'franc'],
    'Sao Tome and Principe': ['sao tome', 'principe', 'carvalho', 'dobra'],
    'Senegal': ['senegal', 'senegalese', 'dakar', 'sall', 'franc cfa'],
    'Seychelles': ['seychelles', 'seychellois', 'victoria', 'ramkalawan', 'rupee'],
    'Sierra Leone': ['sierra leone', 'freetown', 'bio', 'leone'],
    'Somalia': ['somalia', 'somalian', 'mogadishu', 'mohamud', 'shilling'],
    'South Africa': ['south africa', 'south african', 'cape town', 'johannesburg', 'ramaphosa', 'rand'],
    'South Sudan': ['south sudan', 'juba', 'kiir', 'pound'],
    'Sudan': ['sudan', 'sudanese', 'khartoum', 'burhan', 'pound'],
    'Tanzania': ['tanzania', 'tanzanian', 'dodoma', 'dar es salaam', 'hassan', 'shilling'],
    'Togo': ['togo', 'togolese', 'lome', 'gnassingbe', 'franc cfa'],
    'Tunisia': ['tunisia', 'tunisian', 'tunis', 'saied', 'dinar'],
    'Uganda': ['uganda', 'ugandan', 'kampala', 'museveni', 'shilling'],
    'Zambia': ['zambia', 'zambian', 'lusaka', 'hichilema', 'kwacha'],
    'Zimbabwe': ['zimbabwe', 'zimbabwean', 'harare', 'mnangagwa', 'dollar']
  };

  // Regional groupings for better organization (updated to match database spellings)
  static const Map<String, List<String>> _regionalGroups = {
    'North Africa': ['Algeria', 'Egypt', 'Libya', 'Morocco', 'Sudan', 'Tunisia'],
    'West Africa': ['Benin', 'Burkina Faso', 'Cape Verde', 'Côte d\'Ivoire', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Liberia', 'Mali', 'Mauritania', 'Niger', 'Nigeria', 'Senegal', 'Sierra Leone', 'Togo'],
    'Central Africa': ['Cameroon', 'Central African Republic', 'Chad', 'Congo (Kinshasa)', 'Congo (Brazzaville)', 'Equatorial Guinea', 'Gabon', 'Sao Tome and Principe'],
    'East Africa': ['Burundi', 'Comoros', 'Djibouti', 'Eritrea', 'Ethiopia', 'Kenya', 'Madagascar', 'Malawi', 'Mauritius', 'Rwanda', 'Seychelles', 'Somalia', 'South Sudan', 'Tanzania', 'Uganda'],
    'Southern Africa': ['Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Mozambique', 'Namibia', 'South Africa', 'Zambia', 'Zimbabwe']
  };

  static const List<String> _defaultImages = [
    'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1564415315949-7a0c4c73aab4?w=800&h=600&fit=crop'
  ];

  // Enhanced scraping method for all African countries
  static Future<List<Map<String, dynamic>>> scrapeAfricaNews() async {
    try {
      print('DEBUG: Starting enhanced Africa news scraping for all 54 countries');
      final allArticles = <Map<String, dynamic>>[];
      
      // Scrape from GNews API
      final gnewsArticles = await _scrapeFromGNews();
      allArticles.addAll(gnewsArticles);
      print('DEBUG: Got ${gnewsArticles.length} articles from GNews');
      
      // Scrape from AfricaNews RSS feeds
      final rssArticles = await _scrapeFromRSSFeeds();
      allArticles.addAll(rssArticles);
      print('DEBUG: Got ${rssArticles.length} articles from RSS feeds');
      
      // Categorize articles by country
      final categorizedArticles = _categorizeArticlesByCountry(allArticles);
      print('DEBUG: Categorized ${categorizedArticles.length} articles across countries');
      
      // Ensure distribution across all countries
      final distributedArticles = _ensureCountryDistribution(categorizedArticles);
      print('DEBUG: Final distribution: ${distributedArticles.length} articles');
      
      return distributedArticles;
    } catch (e) {
      print('DEBUG: Enhanced scraping failed: $e');
      return getFallbackAfricanNews();
    }
  }

  // Scrape news from GNews API
  static Future<List<Map<String, dynamic>>> _scrapeFromGNews() async {
    final articles = <Map<String, dynamic>>[];
    
    try {
      // Search for Africa-related news
      final queries = [
        'Africa',
        'African Union',
        'Nigeria economy',
        'South Africa politics',
        'Kenya development',
        'Ghana business',
        'Egypt news',
        'Morocco trade',
        'Ethiopia growth',
        'Tanzania investment'
      ];
      
      for (final query in queries) {
        try {
          final url = '$_gnewsBaseUrl/search?q=$query&lang=en&country=any&max=10&apikey=$_gnewsApiKey';
          final response = await http.get(Uri.parse(url));
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final gnewsArticles = data['articles'] as List? ?? [];
            
            for (final article in gnewsArticles) {
              articles.add({
                'title': article['title'] ?? 'No Title',
                'description': article['description'] ?? 'No description available',
                'content': article['content'] ?? article['description'] ?? 'No content available',
                'publishers': article['source']?['name'] ?? 'GNews Source',
                'articleUrl': article['url'] ?? '',
                'image': article['image'] ?? _getDefaultImageUrl(),
                'created_at': article['publishedAt'] ?? DateTime.now().toIso8601String(),
                'country': 'General Africa', // Will be categorized later
              });
            }
          }
        } catch (e) {
          print('DEBUG: GNews query failed for "$query": $e');
          continue;
        }
        
        // Add delay to respect API rate limits
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('DEBUG: GNews scraping failed: $e');
    }
    
    return articles;
  }

  // Scrape news from RSS feeds
  static Future<List<Map<String, dynamic>>> _scrapeFromRSSFeeds() async {
    final articles = <Map<String, dynamic>>[];
    
    for (final feedUrl in _africaNewsRssFeeds) {
      try {
        final response = await http.get(
          Uri.parse(feedUrl),
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; NewsBot/1.0)',
            'Accept': 'application/rss+xml, application/xml, text/xml',
          }
        ).timeout(const Duration(seconds: 15));
        
        if (response.statusCode == 200) {
          final document = xml.XmlDocument.parse(response.body);
          final items = document.findAllElements('item');
          
          for (final item in items.take(20)) {
            try {
              final title = item.findElements('title').first.text.trim();
              final description = _getElementText(item, 'description');
              final link = _getElementText(item, 'link');
              final pubDate = _getElementText(item, 'pubDate');
              final category = _getElementText(item, 'category');
              
              // Try to get full content
              String content = await _fetchFullContent(link);
              if (content.isEmpty) {
                content = description;
              }
              
              articles.add({
                'title': title,
                'description': description,
                'content': content,
                'publishers': _getPublisherFromUrl(feedUrl),
                'articleUrl': link,
                'image': _getDefaultImageUrl(),
                'created_at': _parseDate(pubDate),
                'country': 'General Africa', // Will be categorized later
                'category': category,
              });
            } catch (e) {
              print('DEBUG: Failed to parse RSS item: $e');
              continue;
            }
          }
        }
      } catch (e) {
        print('DEBUG: RSS feed failed for $feedUrl: $e');
        continue;
      }
    }
    
    return articles;
  }

  // Enhanced country categorization using the mapping utility
  static List<Map<String, dynamic>> _categorizeArticlesByCountry(List<Map<String, dynamic>> articles) {
    for (final article in articles) {
      final text = '${article['title']} ${article['description']} ${article['content']}'.toLowerCase();
      String assignedCountry = 'General Africa';
      
      // Check for specific country keywords using the mapping utility
      for (final country in _allAfricanCountries) {
        final keywords = _countryKeywords[country] ?? [country.toLowerCase()];
        
        for (final keyword in keywords) {
          if (text.contains(keyword.toLowerCase())) {
            // Use the mapping utility to normalize the country name
            assignedCountry = country; // Already normalized in our list
            break;
          }
        }
        
        if (assignedCountry != 'General Africa') break;
      }
      
      // Additional check for alternative country names
      if (assignedCountry == 'General Africa') {
        // Check for alternative names that might appear in news
        final alternativeChecks = {
          'democratic republic of congo': 'Congo (Kinshasa)',
          'drc': 'Congo (Kinshasa)',
          'congo kinshasa': 'Congo (Kinshasa)',
          'dr congo': 'Congo (Kinshasa)',
          'republic of congo': 'Congo (Brazzaville)',
          'congo brazzaville': 'Congo (Brazzaville)',
          'ivory coast': 'Côte d\'Ivoire',
          'cote d\'ivoire': 'Côte d\'Ivoire',
          'swaziland': 'Eswatini',
          'cabo verde': 'Cape Verde',
        };
        
        for (final entry in alternativeChecks.entries) {
          if (text.contains(entry.key)) {
            assignedCountry = entry.value;
            break;
          }
        }
      }
      
      article['country'] = assignedCountry;
    }
    
    return articles;
  }

  // Ensure distribution across all African countries
  static List<Map<String, dynamic>> _ensureCountryDistribution(List<Map<String, dynamic>> articles) {
    final countryDistribution = <String, List<Map<String, dynamic>>>{};
    
    // Initialize all countries
    for (final country in _allAfricanCountries) {
      countryDistribution[country] = [];
    }
    countryDistribution['General Africa'] = [];
    
    // Distribute existing articles
    for (final article in articles) {
      final country = article['country'] ?? 'General Africa';
      countryDistribution[country]!.add(article);
    }
    
    // Ensure minimum articles per major country
    final majorCountries = ['Nigeria', 'South Africa', 'Egypt', 'Kenya', 'Ghana', 'Morocco', 'Ethiopia', 'Tanzania', 'Uganda', 'Angola'];
    final minArticlesPerMajorCountry = 3;
    
    final generalArticles = countryDistribution['General Africa']!;
    int generalIndex = 0;
    
    for (final country in majorCountries) {
      final currentCount = countryDistribution[country]!.length;
      if (currentCount < minArticlesPerMajorCountry) {
        final needed = minArticlesPerMajorCountry - currentCount;
        
        // Reassign articles from general pool
        for (int i = 0; i < needed && generalIndex < generalArticles.length; i++) {
          final article = generalArticles[generalIndex];
          article['country'] = country;
          countryDistribution[country]!.add(article);
          generalIndex++;
        }
      }
    }
    
    // Create final list
    final finalArticles = <Map<String, dynamic>>[];
    countryDistribution.forEach((country, articles) {
      finalArticles.addAll(articles);
    });
    
    // Log distribution
    final distribution = <String, int>{};
    countryDistribution.forEach((country, articles) {
      if (articles.isNotEmpty) {
        distribution[country] = articles.length;
      }
    });
    print('DEBUG: Country distribution: $distribution');
    
    return finalArticles;
  }

  // Enhanced investment news scraping
  static Future<List<Map<String, dynamic>>> scrapeInvestmentNews() async {
    print('DEBUG Investment: Starting enhanced investment news scraping');
    
    try {
      // Get general Africa news first
      final generalArticles = await scrapeAfricaNews();
      
      // Filter for investment-related content
      final investmentKeywords = RegExp(
        r'\b(investment|economy|business|finance|market|banking|trade|stock|gdp|revenue|real estate|property|energy|power|oil|gas|politics|government|policy|commodities|gold|mining|agriculture|infrastructure|development|growth|forex|currency|bond|equity|venture capital|private equity|ipo|merger|acquisition)\b',
        caseSensitive: false
      );
      
      final investmentArticles = generalArticles.where((article) {
        final text = '${article['title']} ${article['description']} ${article['content']}'.toLowerCase();
        return investmentKeywords.hasMatch(text);
      }).toList();
      
      // Get additional investment-specific content from GNews
      final additionalInvestmentNews = await _scrapeInvestmentFromGNews();
      investmentArticles.addAll(additionalInvestmentNews);
      
      // Categorize by investment topics
      final investmentTopics = ['Trade', 'Stocks', 'Real Estate', 'Energy', 'Politics', 'Commodities', 'Banking', 'Infrastructure'];
      
      for (int i = 0; i < investmentArticles.length; i++) {
        final article = investmentArticles[i];
        article['tag'] = _categorizeByInvestmentTopic(article) ?? investmentTopics[i % investmentTopics.length];
      }
      
      print('DEBUG Investment: Generated ${investmentArticles.length} investment articles');
      return investmentArticles;
    } catch (e) {
      print('DEBUG Investment: Enhanced scraping failed: $e');
      return getFallbackInvestmentNews();
    }
  }

  // Investment-specific GNews scraping
  static Future<List<Map<String, dynamic>>> _scrapeInvestmentFromGNews() async {
    final articles = <Map<String, dynamic>>[];
    
    try {
      final investmentQueries = [
        'Africa investment',
        'African stocks',
        'Africa trade',
        'African economy',
        'Africa business',
        'African markets',
        'Africa infrastructure',
        'African energy',
        'Africa real estate',
        'African banking'
      ];
      
      for (final query in investmentQueries) {
        try {
          final url = '$_gnewsBaseUrl/search?q=$query&lang=en&country=any&max=5&apikey=$_gnewsApiKey';
          final response = await http.get(Uri.parse(url));
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final gnewsArticles = data['articles'] as List? ?? [];
            
            for (final article in gnewsArticles) {
              articles.add({
                'title': article['title'] ?? 'No Title',
                'description': article['description'] ?? 'No description available',
                'content': article['content'] ?? article['description'] ?? 'No content available',
                'publishers': article['source']?['name'] ?? 'Investment News Source',
                'articleUrl': article['url'] ?? '',
                'image': article['image'] ?? _getDefaultImageUrl(),
                'created_at': article['publishedAt'] ?? DateTime.now().toIso8601String(),
                'country': 'General Africa',
              });
            }
          }
        } catch (e) {
          print('DEBUG: Investment GNews query failed for "$query": $e');
          continue;
        }
        
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('DEBUG: Investment GNews scraping failed: $e');
    }
    
    return articles;
  }

  // Enhanced topic categorization for Feed Your Curiosity
  static Future<List<Map<String, dynamic>>> scrapeFeedYourCuriosity() async {
    final articles = await scrapeAfricaNews();
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
    
    for (int i = 0; i < articles.length; i++) {
      final article = articles[i];
      article['tag'] = _categorizeByTopic(article) ?? topics[i % topics.length];
    }
    
    return articles;
  }

  // Helper methods
  static String _getElementText(xml.XmlElement parent, String tagName) {
    try {
      return parent.findElements(tagName).first.text.trim();
    } catch (e) {
      return '';
    }
  }

  static String _parseDate(String dateString) {
    try {
      if (dateString.isEmpty) return DateTime.now().toIso8601String();
      final date = DateTime.parse(dateString);
      return date.toIso8601String();
    } catch (e) {
      return DateTime.now().toIso8601String();
    }
  }

  static Future<String> _fetchFullContent(String url) async {
    if (url.isEmpty) return '';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; NewsBot/1.0)',
        }
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        
        // Remove unwanted elements
        document.querySelectorAll('script, style, nav, header, footer, .ad, .advertisement').forEach((el) => el.remove());
        
        // Extract content
        final contentSelectors = [
          '.article-content',
          '.entry-content',
          '.post-content',
          '.story-content',
          'article',
          '.content'
        ];
        
        for (final selector in contentSelectors) {
          final contentElement = document.querySelector(selector);
          if (contentElement != null) {
            final paragraphs = contentElement.querySelectorAll('p');
            if (paragraphs.length > 2) {
              return paragraphs
                  .map((p) => p.text.trim())
                  .where((text) => text.isNotEmpty && text.length > 30)
                  .take(5)
                  .join('\n\n');
            }
          }
        }
      }
    } catch (e) {
      // Silently fail and return empty content
    }
    
    return '';
  }

  static String? _categorizeByInvestmentTopic(Map<String, dynamic> article) {
    final text = '${article['title']} ${article['description']} ${article['content']}'.toLowerCase();
    
    if (RegExp(r'\b(trade|export|import|commerce|trading|business|economy|economic|gdp)\b').hasMatch(text)) {
      return 'Trade';
    }
    if (RegExp(r'\b(stock|share|equity|market|index|investor|investment|portfolio|dividend|financial|finance|bank|banking)\b').hasMatch(text)) {
      return 'Stocks';
    }
    if (RegExp(r'\b(real estate|property|housing|land|building|construction|development|residential|commercial)\b').hasMatch(text)) {
      return 'Real Estate';
    }
    if (RegExp(r'\b(energy|power|electricity|renewable|solar|wind|hydro|oil|gas|petroleum|coal|nuclear)\b').hasMatch(text)) {
      return 'Energy';
    }
    if (RegExp(r'\b(politics|government|policy|election|vote|campaign|parliament|legislation|political|minister|president|leader|governance)\b').hasMatch(text)) {
      return 'Politics';
    }
    if (RegExp(r'\b(commodities|gold|silver|copper|platinum|cocoa|coffee|cotton|sugar|wheat|corn|rice|agriculture|mining|metals|crude)\b').hasMatch(text)) {
      return 'Commodities';
    }
    if (RegExp(r'\b(infrastructure|roads|bridges|airports|ports|transportation|logistics|telecommunications|internet|broadband)\b').hasMatch(text)) {
      return 'Infrastructure';
    }
    
    return null;
  }

  static String? _categorizeByTopic(Map<String, dynamic> article) {
    final text = '${article['title']} ${article['description']} ${article['content']}'.toLowerCase();
    
    if (RegExp(r'\b(culture|heritage|tradition|music|dance|festival|language|history|museum|artist|cultural|traditional|ceremony|ritual|art)\b').hasMatch(text)) {
      return 'African Culture & Lifestyle';
    }
    if (RegExp(r'\b(agriculture|farming|crop|harvest|farm|food|production|livestock|irrigation|farmer|agricultural|rural|cocoa|coffee|maize|rice)\b').hasMatch(text)) {
      return 'African Agriculture';
    }
    if (RegExp(r'\b(technology|tech|digital|innovation|startup|fintech|mobile|app|software|internet|computer|artificial intelligence|ai|innovation)\b').hasMatch(text)) {
      return 'African Technology';
    }
    if (RegExp(r'\b(education|school|university|student|teacher|learning|academic|research|scholarship|literacy|curriculum)\b').hasMatch(text)) {
      return 'African Education';
    }
    if (RegExp(r'\b(health|healthcare|medical|hospital|doctor|medicine|treatment|disease|wellness|clinic|nursing|pharmacy)\b').hasMatch(text)) {
      return 'African Health';
    }
    if (RegExp(r'\b(environment|climate|conservation|wildlife|forest|ecosystem|sustainability|renewable|carbon|pollution|biodiversity)\b').hasMatch(text)) {
      return 'African Environment';
    }
    if (RegExp(r'\b(sports|football|soccer|cricket|rugby|athletics|olympics|championship|tournament|player|team|match)\b').hasMatch(text)) {
      return 'African Sports';
    }
    
    return null;
  }

  static String _getDefaultImageUrl() {
    final index = DateTime.now().millisecondsSinceEpoch % _defaultImages.length;
    return _defaultImages[index];
  }

  static String _getPublisherFromUrl(String url) {
    final host = Uri.parse(url).host.toLowerCase();
    
    if (host.contains('africanews')) return 'AfricaNews';
    if (host.contains('allafrica')) return 'AllAfrica';
    if (host.contains('news24')) return 'News24';
    if (host.contains('cgtn')) return 'CGTN Africa';
    if (host.contains('gnews')) return 'GNews Africa';
    
    return 'African News Source';
  }

  // Conversion methods for database compatibility
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

  // Enhanced fallback news with better country representation
  static List<Map<String, dynamic>> getFallbackAfricanNews() {
    final now = DateTime.now().toIso8601String();
    final fallbackArticles = <Map<String, dynamic>>[];
    
    // Create diverse fallback articles for major African countries
    final fallbackData = [
      {
        'title': 'Nigeria Unveils Ambitious Infrastructure Development Plan',
        'description': 'The Nigerian government announces a comprehensive infrastructure development program worth \$50 billion over the next five years.',
        'content': 'Nigeria has unveiled an ambitious infrastructure development plan that aims to transform the country\'s economic landscape over the next five years. The comprehensive program, valued at \$50 billion, will focus on transportation networks, digital infrastructure, and energy systems. President Bola Tinubu announced the initiative during a special address to the National Assembly, emphasizing the government\'s commitment to creating jobs and attracting foreign investment. The plan includes the construction of new highways, expansion of broadband internet access to rural areas, and the development of renewable energy projects. Key projects include the Lagos-Kano railway modernization, the establishment of technology hubs in major cities, and the construction of solar power plants across northern states. The government expects the infrastructure investments to boost GDP growth by 3-4% annually and create over 2 million jobs. International development partners, including the World Bank and African Development Bank, have expressed strong support for the initiative.',
        'publishers': 'Vanguard Nigeria',
        'country': 'Nigeria',
        'tag': 'Infrastructure'
      },
      {
        'title': 'South Africa Leads Continental Renewable Energy Revolution',
        'description': 'South Africa emerges as the continent\'s renewable energy leader with groundbreaking solar and wind power initiatives.',
        'content': 'South Africa has positioned itself as the continent\'s renewable energy powerhouse with the launch of several groundbreaking solar and wind power projects. The country\'s Renewable Energy Independent Power Producer Procurement Programme has attracted over \$14 billion in investment, making it one of the most successful clean energy initiatives in Africa. The Northern Cape province alone now hosts some of the world\'s largest solar installations, generating enough clean electricity to power millions of homes. President Cyril Ramaphosa highlighted the country\'s commitment to achieving net-zero emissions by 2050 during the recent COP28 climate summit. The renewable energy sector has created over 40,000 jobs and significantly reduced the country\'s reliance on coal-fired power plants. Major international companies, including Google and Amazon, have announced plans to power their African operations entirely through South African renewable energy. The success has inspired other African nations to develop similar programs, with Kenya, Morocco, and Egypt launching their own renewable energy initiatives.',
        'publishers': 'News24 South Africa',
        'country': 'South Africa',
        'tag': 'Energy'
      },
      {
        'title': 'Kenya\'s Digital Economy Reaches New Heights',
        'description': 'Kenya continues to lead Africa\'s digital transformation with innovative fintech solutions and technological advancements.',
        'content': 'Kenya has solidified its position as Africa\'s digital economy leader with remarkable growth in fintech innovation and technological adoption. The country\'s mobile money platform, M-Pesa, now processes over \$50 billion annually and serves as a model for digital financial inclusion across the developing world. Nairobi\'s Silicon Savannah has become a hub for tech startups, attracting venture capital investment from global firms. The government\'s digital transformation agenda, known as the Digital Economy Blueprint, aims to contribute 20% to GDP by 2030. Recent achievements include the successful launch of the Konza Technopolis smart city project and the expansion of high-speed internet to all 47 counties. President William Ruto announced plans to make Kenya a regional leader in artificial intelligence and blockchain technology. The country has also launched Africa\'s first satellite assembly facility in partnership with international space agencies. Young entrepreneurs are driving innovation in sectors ranging from agriculture technology to digital health solutions, creating thousands of jobs and attracting international recognition.',
        'publishers': 'The Standard Kenya',
        'country': 'Kenya',
        'tag': 'African Technology'
      },
      {
        'title': 'Ghana Sets New Standards in Agricultural Innovation',
        'description': 'Ghana implements cutting-edge agricultural technologies to boost food security and farmer incomes across the nation.',
        'content': 'Ghana has emerged as a continental leader in agricultural innovation, implementing cutting-edge technologies that are revolutionizing farming practices and boosting food security. The government\'s Planting for Food and Jobs program has introduced precision agriculture techniques, including drone-based crop monitoring and smart irrigation systems. Cocoa farmers in the Ashanti and Western regions are now using mobile apps to track crop health and access real-time market prices. The introduction of climate-resilient seed varieties has increased crop yields by an average of 30% over the past two years. President Nana Akufo-Addo launched the Ghana Agricultural Technology Transfer Programme, which connects smallholder farmers with modern farming equipment and knowledge. The country has also established agricultural processing zones in all 16 regions, adding value to raw produce and creating employment for rural communities. International partnerships with Israel and the Netherlands have brought advanced greenhouse technologies and water-efficient farming methods. The success of these initiatives has attracted attention from across Africa, with delegations from Nigeria, Burkina Faso, and Togo visiting to learn from Ghana\'s agricultural transformation model.',
        'publishers': 'GhanaWeb',
        'country': 'Ghana',
        'tag': 'African Agriculture'
      },
      {
        'title': 'Egypt Unveils Massive New Administrative Capital',
        'description': 'Egypt officially opens its new administrative capital, marking a historic milestone in urban development and governance.',
        'content': 'Egypt has officially inaugurated its New Administrative Capital, a futuristic city that represents one of the most ambitious urban development projects in African history. The mega-project, located 45 kilometers east of Cairo, spans 170,000 acres and is designed to house 6.5 million residents. President Abdel Fattah el-Sisi moved his offices to the new capital, symbolizing a new era in Egyptian governance and urban planning. The city features the world\'s largest cathedral and mosque, a massive government district, and Africa\'s tallest skyscraper. Smart city technologies are integrated throughout, including autonomous public transportation, renewable energy systems, and advanced telecommunications infrastructure. The project has created over 1.5 million jobs and attracted \$58 billion in investment from international developers and governments. The new capital aims to relieve pressure on historic Cairo while preserving the ancient city\'s cultural heritage. Environmental sustainability is a key focus, with extensive green spaces, waste recycling facilities, and water conservation systems. The success of the project has positioned Egypt as a leader in urban planning and sustainable development across the Middle East and Africa.',
        'publishers': 'Al-Ahram Egypt',
        'country': 'Egypt',
        'tag': 'Infrastructure'
      },
      {
        'title': 'Morocco Expands Its Role as Africa\'s Gateway to Europe',
        'description': 'Morocco strengthens its position as a strategic hub for African-European trade and investment partnerships.',
        'content': 'Morocco has significantly expanded its role as Africa\'s primary gateway to Europe, leveraging its strategic location and robust infrastructure to facilitate continental trade and investment. The Tangier Med port complex has become Africa\'s largest container port, handling over 7 million containers annually and serving as a transshipment hub for Sub-Saharan African goods entering European markets. King Mohammed VI launched the Africa-Morocco Economic Forum, bringing together business leaders from across the continent to explore new partnership opportunities. The country\'s automotive industry has attracted major international manufacturers, with Renault, PSA Peugeot, and Chinese companies establishing production facilities that export vehicles throughout Africa. Morocco\'s renewable energy program, including the world\'s largest concentrated solar power plant in Ouarzazate, serves as a model for other African nations. The government has signed cooperation agreements with over 30 African countries, focusing on technology transfer, education, and infrastructure development. Morocco\'s banking sector has expanded across francophone Africa, providing financial services and supporting regional integration. The success of these initiatives has made Morocco a preferred partner for international investors seeking to access African markets.',
        'publishers': 'Morocco World News',
        'country': 'Morocco',
        'tag': 'Trade'
      },
      {
        'title': 'Ethiopia Launches Revolutionary Healthcare Initiative',
        'description': 'Ethiopia implements an innovative community-based healthcare program that\'s transforming rural health outcomes.',
        'content': 'Ethiopia has launched a groundbreaking community-based healthcare initiative that is transforming health outcomes in rural areas and serving as a model for other developing nations. The Health Extension Program trains local women as Health Extension Workers, providing basic healthcare services directly to communities. Over 40,000 Health Extension Workers now serve rural populations, delivering preventive care, treating common illnesses, and educating families about hygiene and nutrition. The program has contributed to a 60% reduction in child mortality rates over the past decade. Prime Minister Abiy Ahmed announced plans to expand the program to urban areas and integrate digital health technologies. Mobile health clinics equipped with telemedicine capabilities now reach remote mountainous regions, connecting rural patients with specialists in Addis Ababa. The government has partnered with international organizations to establish pharmaceutical manufacturing facilities, reducing dependence on imported medicines. Ethiopia\'s success in combating infectious diseases, including the near-elimination of malaria in several regions, has gained international recognition. The World Health Organization has endorsed Ethiopia\'s approach as a best practice for achieving universal health coverage in resource-limited settings.',
        'publishers': 'Ethiopian News Agency',
        'country': 'Ethiopia',
        'tag': 'African Health'
      },
      {
        'title': 'Tanzania Emerges as East Africa\'s Tourism Powerhouse',
        'description': 'Tanzania\'s tourism sector experiences unprecedented growth, driving economic development and conservation efforts.',
        'content': 'Tanzania has emerged as East Africa\'s premier tourism destination, with the sector experiencing unprecedented growth that is driving economic development and innovative conservation efforts. The country welcomed over 1.5 million international visitors last year, generating record tourism revenues of \$2.8 billion. President Samia Suluhu Hassan launched the National Tourism Policy 2023, aimed at doubling tourist arrivals by 2030 while ensuring sustainable development. The Serengeti National Park and Ngorongoro Conservation Area continue to attract visitors from around the world, while new destinations like Ruaha National Park and the Mafia Island Marine Park are gaining international recognition. Community-based tourism initiatives have empowered local communities to participate directly in conservation efforts while earning income from wildlife tourism. The government has invested heavily in tourism infrastructure, including the expansion of Julius Nyerere International Airport and the construction of new eco-lodges. Tanzania\'s success in balancing tourism growth with wildlife conservation has been recognized by the United Nations as a model for sustainable tourism development. The sector now employs over 1.8 million people directly and indirectly, making it one of the country\'s largest employers after agriculture.',
        'publishers': 'The Citizen Tanzania',
        'country': 'Tanzania',
        'tag': 'African Culture & Lifestyle'
      }
    ];
    
    // Add articles for each major country
    for (final data in fallbackData) {
      fallbackArticles.add({
        'title': data['title'],
        'description': data['description'],
        'content': data['content'],
        'publishers': data['publishers'],
        'articleUrl': '',
        'image': _getDefaultImageUrl(),
        'articeImage': _getDefaultImageUrl(),
        'articleBody': data['content'],
        'urlLink': '',
        'country': data['country'],
        'created_at': now,
        'tag': data['tag'],
      });
    }
    
    // Add articles for other African countries with regional focus
    final otherCountries = _allAfricanCountries.where((country) => 
      !fallbackData.any((data) => data['country'] == country)).toList();
    
    for (int i = 0; i < otherCountries.length && i < 20; i++) {
      final country = otherCountries[i];
      final region = _getRegionForCountry(country);
      
      fallbackArticles.add({
        'title': '$country Advances Regional Integration Efforts',
        'description': '$country strengthens partnerships within $region to boost economic development and cooperation.',
        'content': '$country has taken significant steps to strengthen regional integration within $region, launching new initiatives that promote cross-border trade, investment, and cooperation. The government has announced plans to improve transportation links with neighboring countries and harmonize trade regulations to facilitate commerce. New partnerships in education, healthcare, and technology transfer are creating opportunities for knowledge sharing and capacity building. Local businesses are exploring new markets across the region, supported by government initiatives that provide funding and technical assistance. The country\'s commitment to regional integration aligns with African Union goals for continental unity and economic development. Infrastructure projects, including road networks and telecommunications systems, are connecting communities and enabling greater participation in regional economies.',
        'publishers': 'African Union News',
        'articleUrl': '',
        'image': _getDefaultImageUrl(),
        'articeImage': _getDefaultImageUrl(),
        'articleBody': '$country regional integration content...',
        'urlLink': '',
        'country': country,
        'created_at': now,
        'tag': 'Trade',
      });
    }
    
    return fallbackArticles;
  }

  static String _getRegionForCountry(String country) {
    for (final entry in _regionalGroups.entries) {
      if (entry.value.contains(country)) {
        return entry.key;
      }
    }
    return 'Africa';
  }

  // Enhanced fallback for investment news
  static List<Map<String, dynamic>> getFallbackInvestmentNews() {
    final now = DateTime.now().toIso8601String();
    final fallbackArticles = <Map<String, dynamic>>[];
    
    final investmentData = [
      {
        'title': 'African Development Bank Announces \$25 Billion Infrastructure Fund',
        'description': 'New fund targets transportation, energy, and digital infrastructure projects across the continent.',
        'content': 'The African Development Bank has announced the launch of a \$25 billion infrastructure fund designed to accelerate development projects across the continent. The fund will focus on critical infrastructure including transportation networks, renewable energy systems, and digital connectivity. President Akinwumi Adesina emphasized the fund\'s potential to create millions of jobs and boost economic growth across member countries. Priority projects include cross-border highway networks, solar power installations, and fiber optic cable systems. The fund has already attracted commitments from international investors and development finance institutions.',
        'tag': 'Infrastructure',
        'country': 'General Africa'
      },
      {
        'title': 'Nigerian Stock Exchange Reaches All-Time High',
        'description': 'Strong earnings reports and foreign investment drive Nigerian equities to record levels.',
        'content': 'The Nigerian Stock Exchange has reached an all-time high, driven by strong corporate earnings and increased foreign investment. Banking and telecommunications stocks led the rally, with major companies reporting robust quarterly results. Foreign portfolio investment increased by 45% compared to the previous year, indicating growing confidence in the Nigerian economy. Market capitalization exceeded ₦30 trillion for the first time, making Nigeria one of Africa\'s largest equity markets. Analysts attribute the growth to economic reforms and improved business conditions.',
        'tag': 'Stocks',
        'country': 'Nigeria'
      },
      {
        'title': 'Kenya Leads East Africa in Real Estate Investment',
        'description': 'Nairobi property market attracts international investors with strong fundamentals and growth potential.',
        'content': 'Kenya has emerged as East Africa\'s leading destination for real estate investment, with Nairobi\'s property market attracting significant international capital. Commercial real estate transactions increased by 60% last year, driven by demand for office space and retail developments. The government\'s affordable housing program has stimulated residential construction, creating opportunities for developers and investors. International real estate firms have established regional headquarters in Nairobi, recognizing the city\'s potential as a regional hub. Property values in prime locations have shown steady appreciation despite global economic uncertainties.',
        'tag': 'Real Estate',
        'country': 'Kenya'
      }
    ];
    
    for (final data in investmentData) {
      fallbackArticles.add({
        'title': data['title'],
        'description': data['description'],
        'content': data['content'],
        'publishers': 'African Investment News',
        'articleUrl': '',
        'image': _getDefaultImageUrl(),
        'articeImage': _getDefaultImageUrl(),
        'articleBody': data['content'],
        'urlLink': '',
        'country': data['country'],
        'created_at': now,
        'tag': data['tag'],
      });
    }
    
    return fallbackArticles;
  }

  // Enhanced fallback for Feed Your Curiosity
  static List<Map<String, dynamic>> getFallbackFeedYourCuriosityNews() => getFallbackAfricanNews();
}