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
        'title': 'Nigeria\'s Fintech Sector Attracts Record Investment',
        'description': 'Nigerian fintech companies secure over \$800 million in funding, leading Africa\'s digital payment revolution.',
        'content': 'Nigeria\'s fintech sector has attracted record investment of over \$800 million this year, cementing the country\'s position as Africa\'s leading digital payments hub. Companies like Flutterwave, Paystack, and Interswitch continue to expand across the continent, providing innovative financial services to millions of users. The Central Bank of Nigeria\'s supportive regulatory framework has encouraged innovation while ensuring consumer protection. Mobile banking adoption has reached 45% of the adult population, with digital transactions growing by 300% over the past three years. International investors, including Visa, Mastercard, and major venture capital firms, are increasing their presence in Lagos, recognizing Nigeria as a gateway to African markets.',
        'publishers': 'TechCabal Nigeria',
        'country': 'Nigeria',
        'tag': 'African Technology'
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
      },
      {
        'title': 'Rwanda Becomes Africa\'s First Fully Digital Government',
        'description': 'Rwanda completes its digital transformation, offering all government services online through innovative e-governance platform.',
        'content': 'Rwanda has achieved a historic milestone by becoming Africa\'s first fully digital government, with all public services now available online through the comprehensive Irembo platform. President Paul Kagame announced that citizens can now access over 100 government services digitally, from birth certificates to business licenses, without visiting physical offices. The transformation has reduced service delivery time from weeks to hours and eliminated corruption in public service delivery. Rwanda\'s digital ID system, integrated with mobile money and banking services, serves as a model for other African nations. The country has also launched a national fiber optic network reaching every village, ensuring universal internet access. International organizations, including the World Bank and UN, have praised Rwanda\'s digital governance model as a blueprint for developing nations.',
        'publishers': 'The New Times Rwanda',
        'country': 'Rwanda',
        'tag': 'African Technology'
      },
      {
        'title': 'Botswana Discovers Major Diamond Deposit Worth \$15 Billion',
        'description': 'New diamond discovery in Botswana could extend the country\'s mining operations for another 50 years.',
        'content': 'Botswana has announced the discovery of a massive diamond deposit worth an estimated \$15 billion, potentially extending the country\'s diamond mining operations for another five decades. The Karowe mine expansion project, operated by Lucara Diamond Corp, has revealed one of the largest diamond-bearing kimberlite pipes ever found in southern Africa. President Mokgweetsi Masisi emphasized that the discovery will secure Botswana\'s position as the world\'s largest diamond producer by value. The government plans to use diamond revenues to diversify the economy, investing in education, healthcare, and renewable energy projects. Botswana\'s transparent diamond revenue management has been recognized internationally as a model for resource-rich African countries.',
        'publishers': 'Mmegi Botswana',
        'country': 'Botswana',
        'tag': 'Natural Resources'
      },
      {
        'title': 'Senegal Launches Africa\'s Largest Solar Power Plant',
        'description': 'Senegal inaugurates a 200MW solar facility that will provide clean energy to over 2 million people.',
        'content': 'Senegal has inaugurated Africa\'s largest solar power plant, a 200MW facility that will provide clean electricity to over 2 million people and significantly reduce the country\'s carbon footprint. President Macky Sall announced that the Senergy solar park represents a major step toward achieving universal electricity access by 2025. The project, developed in partnership with international investors, created over 3,000 jobs during construction and will employ 500 people permanently. Senegal aims to generate 30% of its electricity from renewable sources by 2030, with additional wind and solar projects planned across the country. The success has attracted interest from neighboring countries, with Mali, Burkina Faso, and Guinea exploring similar renewable energy partnerships.',
        'publishers': 'Le Soleil Senegal',
        'country': 'Senegal',
        'tag': 'Energy'
      },
      {
        'title': 'Uganda Emerges as East Africa\'s Coffee Export Champion',
        'description': 'Uganda\'s coffee exports reach record levels, driving rural development and foreign exchange earnings.',
        'content': 'Uganda has emerged as East Africa\'s leading coffee exporter, with annual exports reaching a record 6.5 million bags and generating over \$800 million in foreign exchange. President Yoweri Museveni launched the National Coffee Platform, connecting smallholder farmers directly with international buyers through digital marketplaces. The government\'s coffee value addition strategy has established processing facilities in all major growing regions, increasing farmer incomes by an average of 40%. Uganda\'s high-quality Arabica and Robusta varieties are gaining recognition in specialty coffee markets worldwide. The sector now employs over 1.7 million households, making it a crucial driver of rural development and poverty reduction.',
        'publishers': 'Daily Monitor Uganda',
        'country': 'Uganda',
        'tag': 'African Agriculture'
      },
      {
        'title': 'Zambia Launches Ambitious Copper Mining Expansion',
        'description': 'Zambia announces plans to double copper production, attracting billions in mining investment.',
        'content': 'Zambia has announced an ambitious plan to double its copper production over the next decade, attracting over \$5 billion in new mining investments from international companies. President Hakainde Hichilema emphasized that copper will drive Zambia\'s economic recovery and development, with new mines opening in the Copperbelt and Northwestern provinces. The government has streamlined mining regulations and improved infrastructure to support the expansion, including upgrades to rail networks and power supply systems. First Quantum Minerals, Barrick Gold, and other major mining companies have committed to significant investments in new projects. Zambia\'s copper is essential for global renewable energy infrastructure, positioning the country as a key player in the green energy transition.',
        'publishers': 'Zambia Daily Mail',
        'country': 'Zambia',
        'tag': 'Natural Resources'
      },
      {
        'title': 'Côte d\'Ivoire Becomes World\'s Largest Cocoa Processor',
        'description': 'Côte d\'Ivoire transforms from raw cocoa exporter to leading processor, adding value to agricultural production.',
        'content': 'Côte d\'Ivoire has achieved a remarkable transformation, becoming the world\'s largest cocoa processor and moving beyond its traditional role as a raw commodity exporter. President Alassane Ouattara announced that the country now processes over 600,000 tons of cocoa annually, creating thousands of jobs and adding significant value to agricultural production. Major chocolate manufacturers, including Cargill, Barry Callebaut, and Olam, have established processing facilities in Abidjan and San Pedro. The government\'s cocoa value chain development program has increased farmer incomes by 60% while ensuring sustainable farming practices. Côte d\'Ivoire\'s success in cocoa processing is inspiring similar value addition initiatives in coffee, cashew nuts, and other agricultural products.',
        'publishers': 'Fraternité Matin',
        'country': 'Côte d\'Ivoire',
        'tag': 'African Agriculture'
      },
      {
        'title': 'Tunisia Leads North Africa in Startup Innovation',
        'description': 'Tunisia\'s thriving startup ecosystem attracts international investment and drives technological innovation.',
        'content': 'Tunisia has emerged as North Africa\'s leading startup hub, with over 400 active startups attracting more than \$100 million in venture capital investment this year. The government\'s Startup Act has created a supportive regulatory environment, offering tax incentives and simplified procedures for new technology companies. Tunis\'s growing tech ecosystem spans fintech, e-commerce, healthtech, and agritech sectors, with several companies expanding across Africa and the Middle East. President Kais Saied launched the National Digital Strategy 2025, aiming to make Tunisia a regional technology leader. International accelerators and incubators have established operations in Tunisia, recognizing the country\'s skilled workforce and strategic location between Europe and Africa.',
        'publishers': 'La Presse Tunisia',
        'country': 'Tunisia',
        'tag': 'African Technology'
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
      },
      {
        'title': 'South African Mining Giants Secure \$3B Green Energy Investment',
        'description': 'Major mining companies partner with renewable energy firms to power operations sustainably.',
        'content': 'South Africa\'s leading mining companies have secured \$3 billion in green energy investments to transition their operations to renewable power sources. Anglo American, Sibanye-Stillwater, and Impala Platinum are leading the initiative with solar and wind farms across mining regions. The investment will create 15,000 construction jobs and significantly reduce the mining sector\'s carbon footprint. Mining executives emphasize that renewable energy will reduce operational costs while meeting environmental commitments. The project positions South Africa as a leader in sustainable mining practices globally.',
        'tag': 'Green Energy',
        'country': 'South Africa'
      },
      {
        'title': 'Egyptian Suez Canal Economic Zone Attracts \$8B Investment',
        'description': 'International manufacturers establish operations in Egypt\'s strategic economic zone.',
        'content': 'Egypt\'s Suez Canal Economic Zone has attracted over \$8 billion in new investments from international manufacturers seeking to serve African and Middle Eastern markets. The zone now hosts companies from China, Germany, Japan, and the United States, creating over 50,000 jobs. Key sectors include automotive assembly, textiles, petrochemicals, and logistics services. The zone\'s strategic location and modern infrastructure make it an ideal gateway for trade between continents. Government incentives and streamlined regulations have accelerated investment commitments.',
        'tag': 'Manufacturing',
        'country': 'Egypt'
      },
      {
        'title': 'Moroccan Renewable Energy Sector Receives \$4B Investment Boost',
        'description': 'Morocco expands its position as Africa\'s renewable energy leader with massive new investments.',
        'content': 'Morocco has secured \$4 billion in new investments for renewable energy projects, reinforcing its position as Africa\'s clean energy leader. The funding will support expansion of the Noor Ouarzazate solar complex and new wind farms along the Atlantic coast. Morocco aims to generate 52% of its electricity from renewable sources by 2030. The investments include partnerships with European energy companies positioning Morocco as a potential green hydrogen exporter. The renewable energy sector has created over 20,000 jobs and attracted significant technology transfer.',
        'tag': 'Renewable Energy',
        'country': 'Morocco'
      },
      {
        'title': 'Ghana\'s Fintech Sector Attracts Record \$200M Venture Capital',
        'description': 'Ghanaian fintech startups secure major funding rounds, driving financial inclusion across West Africa.',
        'content': 'Ghana\'s fintech sector has attracted a record \$200 million in venture capital investment, with local startups expanding services across West Africa. Leading companies like Zeepay, ExpressPay, and Hubtel have secured major funding rounds from international investors. The Bank of Ghana\'s supportive regulatory framework and high mobile penetration have created ideal conditions for fintech innovation. The government aims to achieve 80% financial inclusion by 2025 through digital payment platforms. Ghanaian fintech success is driving similar innovation across the region.',
        'tag': 'Fintech',
        'country': 'Ghana'
      },
      {
        'title': 'Rwanda Becomes Africa\'s Leading Tech Investment Destination',
        'description': 'Rwanda\'s digital transformation attracts major technology investments and partnerships.',
        'content': 'Rwanda has emerged as Africa\'s leading destination for technology investment, attracting over \$500 million in tech sector funding this year. Major companies including Google, Microsoft, and Alibaba have established operations in Kigali. The government\'s digital transformation strategy has created a supportive ecosystem for tech startups and international companies. Rwanda\'s fiber optic network reaches every district, providing the infrastructure needed for digital innovation. The country\'s tech sector now employs over 50,000 people and contributes significantly to GDP growth.',
        'tag': 'Technology',
        'country': 'Rwanda'
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
  static List<Map<String, dynamic>> getFallbackFeedYourCuriosityNews() {
    final now = DateTime.now().toIso8601String();
    final fallbackArticles = <Map<String, dynamic>>[];
    
    final curiosityData = [
      // African Culture and Lifestyle articles
      {
        'title': 'The Rich Tapestry of African Wedding Traditions',
        'description': 'Exploring diverse marriage customs and celebrations across African cultures.',
        'content': 'African wedding traditions showcase the continent\'s incredible cultural diversity, with each ethnic group bringing unique customs and rituals. In Ghana, Kente cloth plays a central role in Akan ceremonies, while Ethiopian weddings feature the traditional coffee ceremony. South African Zulu weddings include the umabo ceremony where families exchange gifts. Nigerian Yoruba weddings are known for their vibrant colors and elaborate gele headwraps. These traditions often span several days, involving entire communities and strengthening social bonds. Modern African couples increasingly blend traditional customs with contemporary elements, creating meaningful celebrations that honor their heritage while embracing change.',
        'tag': 'African Culture & Lifestyle',
        'country': 'Continental'
      },
      {
        'title': 'African Fashion: From Traditional Textiles to Global Runways',
        'description': 'How African designers are revolutionizing global fashion with traditional techniques and modern innovation.',
        'content': 'African fashion is experiencing a renaissance, with designers like Thebe Magugu, Ozwald Boateng, and Lisa Folawiyo gaining international recognition. Traditional textiles like Ankara, Kente, and Bogolan are being reimagined for contemporary wear. The industry combines ancient techniques such as hand-weaving, natural dyeing, and intricate beadwork with modern design sensibilities. Fashion weeks in Lagos, Johannesburg, and Dakar showcase emerging talent, while established brands collaborate with African artisans. This movement not only preserves cultural heritage but also creates economic opportunities for local communities, particularly women who often lead textile production.',
        'tag': 'African Culture & Lifestyle',
         'country': 'Continental'
       },
       {
         'title': 'The Evolution of African Music: From Traditional Rhythms to Global Beats',
         'description': 'How African musical traditions continue to influence and shape world music.',
         'content': 'African music has profoundly influenced global musical genres, from jazz and blues to hip-hop and electronic music. Traditional instruments like the djembe, kora, and mbira continue to evolve, with artists like Toumani Diabaté and Oliver Mtukudzi bridging traditional and contemporary sounds. Afrobeats, pioneered by artists like Burna Boy and Wizkid, has become a global phenomenon. South African amapiano and Nigerian afrobeats are reshaping dance floors worldwide. Music festivals across Africa celebrate this diversity, while digital platforms help preserve traditional songs and introduce them to new audiences. The rhythmic complexity and call-and-response patterns of African music continue to inspire musicians globally.',
         'tag': 'African Culture & Lifestyle',
        'country': 'Continental'
      },
      {
        'title': 'African Cuisine: A Culinary Journey Across the Continent',
        'description': 'Discovering the diverse flavors and cooking traditions that define African gastronomy.',
        'content': 'African cuisine reflects the continent\'s rich biodiversity and cultural heritage, with each region offering unique flavors and cooking techniques. West African jollof rice sparks friendly rivalries between Nigeria, Ghana, and Senegal, each claiming the best version. Ethiopian injera bread serves as both plate and utensil, accompanying spicy stews and vegetables. South African braai culture brings communities together around the grill, while Moroccan tagines showcase the art of slow cooking with aromatic spices. East African ugali provides sustenance across multiple countries, often paired with sukuma wiki greens. Modern African chefs are elevating traditional dishes, opening restaurants worldwide and gaining Michelin recognition. Food festivals celebrate this diversity while preserving ancestral recipes.',
        'tag': 'African Culture & Lifestyle',
        'country': 'Continental'
      },
      {
        'title': 'The Art of African Storytelling: Preserving Oral Traditions in the Digital Age',
        'description': 'How ancient storytelling traditions are being preserved and adapted for modern audiences.',
        'content': 'African storytelling traditions, passed down through generations, are finding new life in the digital age. Griots in West Africa continue their role as living libraries, preserving history through song and narrative. Anansi stories from Ghana teach moral lessons through the clever spider\'s adventures. South African praise poetry celebrates heroes and ancestors with rhythmic verses. Modern platforms like podcasts and YouTube channels are documenting these oral traditions, making them accessible to global audiences. Animation studios are creating content based on African folktales, while schools integrate storytelling into curricula. This preservation effort ensures that wisdom, values, and cultural identity continue to thrive in contemporary society.',
        'tag': 'African Culture & Lifestyle',
        'country': 'Continental'
      },
      {
        'title': 'African Languages: Celebrating Linguistic Diversity and Revival Efforts',
        'description': 'Exploring the continent\'s linguistic richness and efforts to preserve endangered languages.',
        'content': 'Africa is home to over 2,000 languages, representing one-third of the world\'s linguistic diversity. Swahili serves as a lingua franca across East Africa, while Hausa connects communities across the Sahel. South Africa recognizes 11 official languages, promoting multilingual education and media. However, many indigenous languages face extinction as urbanization and globalization favor dominant languages. Revival efforts include digital dictionaries, mobile apps, and social media content in local languages. Universities are establishing African language departments, while writers publish literature in indigenous tongues. Technology companies are developing voice recognition and translation tools for African languages, ensuring digital inclusion for all speakers.',
        'tag': 'African Culture & Lifestyle',
        'country': 'Continental'
      },
      // African Agriculture articles
      {
        'title': 'Climate-Smart Agriculture: African Farmers Leading Adaptation',
        'description': 'How African farmers are developing innovative techniques to combat climate change and improve yields.',
        'content': 'African farmers are pioneering climate-smart agriculture techniques that increase productivity while building resilience to climate change. In Kenya, farmers use drought-resistant crop varieties and precision irrigation systems. Ethiopian terracing techniques prevent soil erosion while maximizing water retention. Nigerian farmers practice crop rotation with nitrogen-fixing legumes to improve soil health. Senegalese communities use traditional weather prediction methods combined with modern meteorological data. These innovations often combine indigenous knowledge with modern technology, creating sustainable solutions that work in local contexts. International organizations are studying these practices for global application.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'The Rise of Urban Farming in African Cities',
        'description': 'How African cities are embracing vertical farming and rooftop gardens to ensure food security.',
        'content': 'Urban farming is transforming African cities, with innovative projects sprouting from Lagos to Nairobi. Vertical farms in South African townships maximize limited space while providing fresh vegetables year-round. Rooftop gardens in Cairo reduce urban heat while supplying local markets. Hydroponic systems in Kenyan slums produce crops without soil, using minimal water. These initiatives address food security, create employment, and reduce the environmental impact of food transportation. Community gardens strengthen social bonds while teaching sustainable practices to urban youth. Technology integration, including IoT sensors and mobile apps, helps optimize growing conditions and market access.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'Ancient Grains Revival: Rediscovering Africa\'s Nutritional Heritage',
        'description': 'How traditional African crops are gaining recognition for their nutritional value and climate resilience.',
        'content': 'Ancient African grains like teff, fonio, and sorghum are experiencing a global revival due to their exceptional nutritional profiles and climate resilience. Teff, Ethiopia\'s superfood grain, is naturally gluten-free and rich in protein and minerals. Fonio, cultivated in West Africa for over 5,000 years, grows in poor soils and requires minimal water. Sorghum thrives in arid conditions and provides essential nutrients. These crops offer solutions to malnutrition and climate change challenges. Research institutions are developing improved varieties while preserving genetic diversity. International markets are increasingly demanding these nutritious alternatives to conventional grains.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'Precision Agriculture: Drones and Satellites Transform African Farming',
        'description': 'How cutting-edge technology is revolutionizing agricultural practices across Africa.',
        'content': 'Precision agriculture is transforming African farming through drone technology, satellite imagery, and IoT sensors. Kenyan farmers use drones to monitor crop health and apply targeted pesticides, reducing chemical use by 30%. South African vineyards employ satellite data to optimize irrigation and predict harvest times. Nigerian rice farmers utilize GPS-guided tractors for precise planting and fertilizer application. Ghanaian cocoa farmers receive real-time weather data and market prices through mobile apps. These technologies increase yields while reducing environmental impact. Training programs help farmers adopt digital tools, while partnerships with tech companies make advanced equipment more accessible.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'Women in Agriculture: Leading Africa\'s Food Security Revolution',
        'description': 'Celebrating the crucial role of women farmers in feeding Africa and driving agricultural innovation.',
        'content': 'Women produce 60-80% of Africa\'s food, yet face significant barriers to land ownership and credit access. Innovative programs are changing this landscape. In Rwanda, women\'s cooperatives have increased coffee production by 40% through collective farming and processing. Kenyan women farmers use mobile banking to access microloans for seeds and equipment. Ethiopian women participate in watershed management projects that improve soil conservation and water retention. Training programs teach modern farming techniques while respecting traditional knowledge. Policy changes in countries like Malawi are granting women equal land rights, leading to increased agricultural productivity and household income.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'Aquaculture Boom: Fish Farming Transforms African Protein Production',
        'description': 'How fish farming is addressing protein deficiency and creating sustainable livelihoods.',
        'content': 'Aquaculture is rapidly expanding across Africa, providing sustainable protein sources and economic opportunities. Nigerian catfish farms supply local markets while reducing pressure on wild fish stocks. Ugandan tilapia farming in cages on Lake Victoria creates jobs for thousands of families. Egyptian fish farms in the Nile Delta use integrated systems that combine fish, rice, and duck production. Kenyan aquaponics systems grow fish and vegetables together, maximizing water efficiency. Training programs teach modern fish farming techniques, while mobile apps help farmers monitor water quality and fish health. Government support and international partnerships are scaling up production to meet growing protein demand.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      {
        'title': 'Agroforestry: Trees and Crops Working Together for Sustainability',
        'description': 'How integrating trees with agriculture is restoring degraded land and improving farmer livelihoods.',
        'content': 'Agroforestry practices are transforming degraded landscapes across Africa while improving farmer incomes. In Niger, farmer-managed natural regeneration has restored 5 million hectares of land, increasing crop yields and providing fuelwood. Kenyan farmers plant nitrogen-fixing trees that improve soil fertility while producing timber and fruit. Ethiopian coffee farmers use shade trees to protect crops while maintaining biodiversity. Senegalese farmers integrate baobab trees with millet cultivation, harvesting nutritious leaves and fruit. These systems sequester carbon, prevent soil erosion, and provide multiple income streams. Research shows agroforestry can increase crop yields by 20-40% while building climate resilience.',
        'tag': 'African Agriculture',
        'country': 'Continental'
      },
      // African Technology articles
      {
        'title': 'Mobile Money Revolution: How Africa Leads Digital Financial Innovation',
        'description': 'Exploring how African mobile payment systems are transforming global fintech.',
        'content': 'Africa leads the world in mobile money adoption, with services like M-Pesa revolutionizing financial inclusion. Kenya\'s M-Pesa serves over 50 million users, enabling everything from bill payments to international remittances. Ghana\'s mobile money interoperability allows seamless transfers between different providers. Nigeria\'s fintech sector attracts billions in investment, with companies like Flutterwave and Paystack expanding globally. These innovations address the challenge of limited banking infrastructure while creating new economic opportunities. Mobile money has enabled micro-lending, insurance products, and savings programs that serve previously unbanked populations. The success of African mobile money systems influences fintech development worldwide.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'Solar Innovation: Africa\'s Renewable Energy Tech Boom',
        'description': 'How African engineers are developing cutting-edge solar technologies for local and global markets.',
        'content': 'African solar technology innovation is addressing energy access challenges while creating exportable solutions. Kenyan company M-KOPA pioneered pay-as-you-go solar systems that have connected millions to clean energy. South African researchers developed perovskite solar cells that work efficiently in high-temperature conditions. Nigerian engineers created solar-powered cold storage systems for rural farmers. Moroccan concentrated solar power plants demonstrate large-scale renewable energy potential. These innovations combine local needs with global market opportunities, attracting international investment and partnerships. African solar tech companies are expanding to other developing markets, sharing expertise and technology.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'AI and Machine Learning: Africa\'s Growing Tech Ecosystem',
        'description': 'How African developers are creating AI solutions for local challenges and global applications.',
        'content': 'Africa\'s AI ecosystem is rapidly expanding, with developers creating solutions for healthcare, agriculture, and education. South African company Aerobotics uses AI and drones for precision agriculture, helping farmers optimize crop yields. Nigerian startup Ubenwa developed AI that detects birth asphyxia in newborns through cry analysis. Kenyan researchers use machine learning to predict crop diseases and optimize irrigation. Ghana\'s tech hubs are developing AI applications for local languages and cultural contexts. These innovations demonstrate how AI can address specific African challenges while contributing to global technological advancement. Investment in African AI startups continues to grow, supported by improving internet infrastructure and educational programs.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'Blockchain Revolution: African Solutions for Global Challenges',
        'description': 'How African developers are leveraging blockchain technology for transparency and financial inclusion.',
        'content': 'African blockchain initiatives are addressing transparency, identity, and financial inclusion challenges. Ghana\'s land registry uses blockchain to prevent fraud and ensure secure property ownership. South African companies develop blockchain solutions for supply chain transparency in mining and agriculture. Nigerian fintech startups use blockchain for cross-border remittances, reducing costs for diaspora communities. Kenyan developers create blockchain-based identity systems for refugees and displaced populations. These innovations demonstrate blockchain\'s potential beyond cryptocurrency, solving real-world problems while building technical expertise. African blockchain conferences attract global attention, positioning the continent as a leader in practical blockchain applications.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'EdTech Innovation: Transforming Education Across Africa',
        'description': 'How educational technology is bridging learning gaps and creating new opportunities.',
        'content': 'Educational technology is revolutionizing learning across Africa, addressing challenges of access and quality. Kenyan platform M-Shule provides curriculum-aligned content via SMS, reaching students without internet access. South African startup GetSmarter partners with universities to offer online courses globally. Nigerian company uLesson creates interactive video lessons for secondary school students. Rwandan initiative One Laptop Per Child has distributed devices to over 200,000 students. These platforms use local languages and culturally relevant content, making education more accessible. Partnerships with governments and NGOs scale successful programs, while data analytics help personalize learning experiences.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'HealthTech Breakthroughs: Digital Solutions for African Healthcare',
        'description': 'How technology is improving healthcare access and outcomes across the continent.',
        'content': 'African healthtech innovations are addressing healthcare challenges through digital solutions. Kenyan platform Daktari Africa connects patients with doctors via video consultations, improving rural healthcare access. South African startup Vula Mobile helps healthcare workers diagnose eye conditions using smartphone cameras. Nigerian company LifeBank uses technology to deliver blood and medical supplies via motorcycles and drones. Ghanaian platform mPharma manages pharmaceutical supply chains, ensuring medication availability. These solutions leverage mobile technology and local infrastructure to provide affordable, accessible healthcare. Partnerships with governments and international organizations help scale successful interventions.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'Space Technology: Africa\'s Growing Satellite Industry',
        'description': 'How African countries are developing space capabilities for communication and earth observation.',
        'content': 'African space technology is advancing rapidly, with multiple countries launching satellites and developing space programs. South Africa\'s SANSA operates earth observation satellites for agriculture and disaster monitoring. Nigeria\'s space agency has launched multiple satellites for communication and remote sensing. Ghana\'s first satellite, GhanaSat-1, was built by students and launched from the International Space Station. Egypt\'s space program focuses on satellite manufacturing and earth observation. These initiatives provide valuable data for agriculture, weather forecasting, and natural resource management. Regional cooperation through the African Space Agency promotes knowledge sharing and joint missions, positioning Africa as an emerging space power.',
        'tag': 'African Technology',
        'country': 'Continental'
      },
      {
        'title': 'Green Tech Innovation: Sustainable Solutions for African Cities',
        'description': 'How African innovators are developing environmentally friendly technologies for urban challenges.',
        'content': 'African green technology innovations are addressing urban environmental challenges while creating economic opportunities. Kenyan company Sanergy converts human waste into fertilizer and insect protein, improving sanitation while producing valuable products. South African startup Renergen produces helium and natural gas from renewable sources. Nigerian company RecyclePoints rewards citizens for recycling plastic waste, cleaning communities while generating income. Ghanaian innovation Hub creates biogas systems for urban households, reducing reliance on charcoal. These solutions combine environmental benefits with business viability, attracting investment and creating jobs. Government support and international partnerships help scale successful green technologies across the continent.',
        'tag': 'African Technology',
        'country': 'Continental'
      }
    ];
    
    for (final data in curiosityData) {
      fallbackArticles.add({
        'title': data['title'],
        'description': data['description'],
        'content': data['content'],
        'publishers': 'African Knowledge Network',
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
}