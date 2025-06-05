import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';

class NewsScraperService {
  static const List<String> targetCountries = [
    'Nigeria',
    'Kenya',
    'South Africa',
    'Ethiopia',
    'Ghana'
  ];

  static const Map<String, List<String>> countryKeywords = {
    'Nigeria': [
      'nigeria',
      'nigerian',
      'nigerians',
      'lagos',
      'abuja',
      'kano',
      'ibadan',
      'port harcourt',
      'buhari',
      'tinubu',
      'bola tinubu',
      'muhammadu buhari',
      'osinbajo',
      'yemi osinbajo',
      'naira',
      'nollywood',
      'afrobeats',
      'davido',
      'wizkid',
      'burna boy',
      'boko haram',
      'fulani',
      'igbo',
      'yoruba',
      'hausa',
      'biafra',
      'nnpc',
      'niger delta',
      'oil revenue',
      'petroleum',
      'crude oil',
      'federal capital territory',
      'fct',
      'national assembly',
      'senate president',
      'governor of lagos',
      'governor of kano',
      'nigerian economy',
      'cbn',
      'central bank of nigeria',
      'benue',
      'benue state',
      'kaduna',
      'plateau',
      'rivers state',
      'delta state',
      'nigerian american',
      'nigerian coalition'
    ],
    'Kenya': [
      'kenya',
      'kenyan',
      'kenyans',
      'nairobi',
      'mombasa',
      'kisumu',
      'nakuru',
      'eldoret',
      'ruto',
      'william ruto',
      'kenyatta',
      'uhuru kenyatta',
      'raila odinga',
      'dp ruto',
      'kenyan shilling',
      'safari',
      'masai',
      'maasai',
      'kikuyu',
      'luo',
      'kalenjin',
      'safaricom',
      'm-pesa',
      'mpesa',
      'tusker',
      'equity bank',
      'mount kenya',
      'lake victoria',
      'tsavo',
      'amboseli',
      'samburu',
      'kenyan parliament',
      'bomas of kenya',
      'coast province',
      'rift valley',
      'tea exports',
      'coffee exports',
      'horticulture',
      'flower exports',
      'al-shabaab',
      'somali border',
      'refugee camp',
      'dadaab'
    ],
    'South Africa': [
      'south africa', 'south african', 'south africans', 'johannesburg',
      'cape town', 'durban',
      'pretoria', 'port elizabeth', 'bloemfontein', 'kimberley', 'polokwane',
      'ramaphosa', 'cyril ramaphosa', 'jacob zuma', 'thabo mbeki',
      'nelson mandela',
      'rand', 'south african rand', 'zar', 'apartheid', 'anc',
      'eff', // removed 'da' as it's too short
      'afrikaans', 'zulu', 'xhosa', 'sotho', 'tswana', 'venda', 'ndebele',
      'johannesburg stock exchange', 'jse', 'sasol', 'mtn', 'shoprite',
      'naspers',
      'kruger national park', 'table mountain', 'robben island', 'drakensberg',
      'mining', 'gold mining', 'platinum', 'diamonds', 'coal mining',
      'load shedding', 'eskom', 'electricity Crisis', 'power cuts',
      'western cape', 'gauteng', 'kwazulu-natal', 'free state', 'mpumalanga',
      'south africa\'s', 'sadc', 'southern africa'
    ],
    'Ethiopia': [
      'ethiopia',
      'ethiopian',
      'ethiopians',
      'addis ababa',
      'dire dawa',
      'mekelle',
      'bahir dar',
      'awassa',
      'jimma',
      'dessie',
      'gondar',
      'abiy ahmed',
      'abiy',
      'hailemariam desalegn',
      'meles zenawi',
      'ethiopian birr',
      'birr',
      'orthodox',
      'coptic',
      'amhara',
      'oromo',
      'tigray',
      'ethiopian airlines',
      'coffee origin',
      'lucy fossil',
      'lalibela',
      'blue nile',
      'rift valley',
      'simien mountains',
      'danakil depression',
      'tigray war',
      'tigray conflict',
      'tplf',
      'oromia',
      'amhara region',
      'african union',
      'au headquarters',
      'uneca',
      'economic commission',
      'grand ethiopian renaissance dam',
      'gerd',
      'nile dam',
      'renaissance dam',
      'drought',
      'famine',
      'food security',
      'humanitarian crisis'
    ],
    'Ghana': [
      'ghana', 'ghanaian', 'ghanaians', 'accra', 'kumasi', 'tamale',
      'cape coast',
      'takoradi', 'tema', 'sunyani',
      'koforidua', // removed 'ho', 'wa', 'ga' as they're too short
      'akufo-addo', 'nana akufo-addo', 'john mahama', 'jerry rawlings',
      'john kufuor',
      'cedi', 'ghanaian cedi', 'ghs', 'pesewa', 'akan', 'twi',
      'ewe', // removed 'ga'
      'ashanti', 'volta region', 'northern region', 'upper east', 'upper west',
      'cocoa', 'gold coast', 'gold mining', 'oil production',
      'jubilee oil field',
      'bank of ghana', 'bog', 'mtn ghana', 'vodafone ghana', 'airtel ghana',
      'black stars', 'ghana football', 'hearts of oak', 'asante kotoko',
      'national democratic congress', 'ndc', 'new patriotic party', 'npp',
      'cape coast castle', 'elmina castle', 'kakum national park', 'lake volta',
      'ob amponsah', 'amponsah'
    ]
  };

  static const List<String> otherAfricanCountries = [
    'uganda', 'sudan', 'mali', 'egypt', 'cameroon', 'tanzania', 'zimbabwe',
    'morocco', 'algeria', 'tunisia', 'libya', 'chad', 'burkina faso',
    'ivory coast', 'senegal', 'guinea', 'sierra leone', 'liberia', 'togo',
    'benin', 'gabon', 'equatorial guinea', 'central african republic',
    'democratic republic of congo', 'congo', 'angola', 'zambia', 'malawi',
    'mozambique', 'botswana', 'namibia', 'lesotho', 'swaziland', 'madagascar',
    'mauritius', 'seychelles', 'comoros', 'djibouti', 'eritrea', 'somalia',
    'rwanda', 'burundi'
    // NOTE: Removed 'niger' to avoid conflict with 'nigeria'
  ];

  static String categorizeByCountry(String title, String description) {
    final titleLower = title.toLowerCase();
    final descriptionLower = description.toLowerCase();

    print('🔍 Categorizing: "$title"');

    // First priority: Check title for exact country matches (before exclusions)
    for (final country in targetCountries) {
      final countryLower = country.toLowerCase();
      if (titleLower.contains(countryLower)) {
        print('✅ Found $country in title directly');
        return country;
      }
    }

    // Check if this is clearly about another African country we don't categorize
    // But use word boundaries to avoid false matches like "niger" in "nigeria"
    for (final otherCountry in otherAfricanCountries) {
      final otherCountryLower = otherCountry.toLowerCase();

      // Use word boundary regex to match whole words only
      final pattern = RegExp(r'\b' + RegExp.escape(otherCountryLower) + r'\b');

      if (pattern.hasMatch(titleLower)) {
        print(
            '🚫 Found other African country ($otherCountry) in title, defaulting to General Africa');
        return 'General Africa';
      }
    }

    // Second priority: Check for specific keywords with higher weight for title
    Map<String, int> countryScores = {};

    for (final country in targetCountries) {
      int score = 0;
      final keywords = countryKeywords[country] ?? [];
      List<String> foundKeywords = [];

      for (final keyword in keywords) {
        final keywordLower = keyword.toLowerCase();

        // Skip very short keywords (2 characters or less) unless they are standalone words
        if (keywordLower.length <= 2) {
          // For very short keywords, ensure they are whole words, not just substring matches
          final titleWords = titleLower.split(RegExp(r'[\s\-\.,;:\(\)\[\]]+'));
          final descWords =
              descriptionLower.split(RegExp(r'[\s\-\.,;:\(\)\[\]]+'));

          if (titleWords.contains(keywordLower)) {
            score += 3;
            foundKeywords.add('T:$keyword');
          }

          if (descWords.contains(keywordLower)) {
            score += 1;
            foundKeywords.add('D:$keyword');
          }
        } else {
          // For longer keywords (3+ characters), use contains matching
          if (titleLower.contains(keywordLower)) {
            score += 3;
            foundKeywords.add('T:$keyword');
          }

          if (descriptionLower.contains(keywordLower)) {
            score += 1;
            foundKeywords.add('D:$keyword');
          }
        }
      }

      if (score > 0) {
        countryScores[country] = score;
        print('🎯 $country score: $score (${foundKeywords.join(', ')})');
      }
    }

    // Return country with highest score, but only if score is significant enough
    if (countryScores.isNotEmpty) {
      final bestMatch =
          countryScores.entries.reduce((a, b) => a.value > b.value ? a : b);

      // Require a minimum score of 3 to avoid false positives from short keywords
      if (bestMatch.value >= 3) {
        print('🏆 Best match: ${bestMatch.key} with score ${bestMatch.value}');
        return bestMatch.key;
      } else {
        print(
            '⚠️ Best match ${bestMatch.key} score ${bestMatch.value} too low, defaulting to General Africa');
      }
    }

    // Third priority: Look for any African context indicators
    final africanKeywords = [
      'african',
      'africa',
      'continental',
      'sub-saharan',
      'east africa',
      'west africa',
      'southern africa',
      'north africa'
    ];
    for (final keyword in africanKeywords) {
      if (titleLower.contains(keyword) || descriptionLower.contains(keyword)) {
        print('🌍 Found general African keyword: $keyword');
        return 'General Africa';
      }
    }

    print('❌ No categorization found, defaulting to General Africa');
    return 'General Africa';
  }

  // Test method to validate categorization
  static void testCategorization() {
    final testCases = [
      {
        'title': 'Nigeria President Tinubu announces new economic policy',
        'description': 'The Nigerian government unveils new reforms'
      },
      {
        'title': 'Kenya leads East Africa in renewable energy',
        'description': 'Nairobi-based company expands solar projects'
      },
      {
        'title': 'South African rand strengthens against dollar',
        'description': 'Johannesburg Stock Exchange sees gains'
      },
      {
        'title': 'Ethiopian Airlines expands African routes',
        'description': 'Addis Ababa hub connects more cities'
      },
      {
        'title': 'Ghana cocoa exports hit record high',
        'description': 'Accra reports bumper harvest season'
      },
      {
        'title': 'African Union summit discusses trade',
        'description': 'Continental leaders meet in Ethiopia'
      },
    ];

    print('\n=== CATEGORIZATION TEST ===');
    for (final testCase in testCases) {
      final result =
          categorizeByCountry(testCase['title']!, testCase['description']!);
      print('Title: ${testCase['title']}');
      print('Result: $result');
      print('---');
    }
    print('=== END TEST ===\n');
  }

  static Future<List<Map<String, dynamic>>> scrapeAfricaNews() async {
    final List<Map<String, dynamic>> allArticles = [];

    final sources = [
      'https://www.africanews.com/',
      'https://allafrica.com/',
      'https://www.news24.com/africa',
    ];

    for (final url in sources) {
      try {
        print('Scraping African news from: $url');
        final articles = await _scrapeFromSource(url);
        allArticles.addAll(articles);

        if (allArticles.length >= 30) break;
      } catch (e) {
        print('Error scraping from $url: $e');
        continue;
      }
    }

    if (allArticles.isEmpty) {
      return _getFallbackAfricanNews();
    }

    return allArticles;
  }

  static Future<List<Map<String, dynamic>>> _scrapeFromSource(
      String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      }).timeout(Duration(seconds: 30));

      if (response.statusCode != 200) {
        print('Failed to load from $url: ${response.statusCode}');
        return [];
      }

      final document = html_parser.parse(response.body);
      final articles = <Map<String, dynamic>>[];

      final selectors = [
        'article',
        '.article',
        '.news-item',
        '.post',
        '.story',
        '.content-item'
      ];

      var articleElements = <dynamic>[];
      for (final selector in selectors) {
        articleElements = document.querySelectorAll(selector);
        if (articleElements.isNotEmpty) break;
      }

      for (final element in articleElements) {
        try {
          final titleElement = element.querySelector('h1 a') ??
              element.querySelector('h2 a') ??
              element.querySelector('h3 a') ??
              element.querySelector('.title a') ??
              element.querySelector('a');

          if (titleElement == null) continue;

          final title = titleElement.text.trim();
          if (title.isEmpty) continue;

          var articleUrl = titleElement.attributes['href'] ?? '';
          if (articleUrl.isNotEmpty && !articleUrl.startsWith('http')) {
            final uri = Uri.parse(url);
            articleUrl = '${uri.scheme}://${uri.host}$articleUrl';
          }

          final imageElement = element.querySelector('img');
          var imageUrl = imageElement?.attributes['src'] ?? '';
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
            final uri = Uri.parse(url);
            imageUrl = '${uri.scheme}://${uri.host}$imageUrl';
          }

          final descriptionElement = element.querySelector('p') ??
              element.querySelector('.excerpt') ??
              element.querySelector('.summary');

          final description = descriptionElement?.text.trim() ?? 'Read more...';

          final country = categorizeByCountry(title, description);

          // Always include articles - let categorization handle the grouping
          final articleContent = await _getArticleContent(articleUrl);
          final now = DateTime.now().toIso8601String();

          articles.add({
            'title': title,
            'description': description,
            'publishers': _getPublisherFromUrl(url),
            'articleUrl': articleUrl,
            'articeImage': imageUrl,
            'articleBody':
                articleContent.isNotEmpty ? articleContent : description,
            'urlLink': articleUrl,
            'country': country,
            'created_at': now,
          });

          print('Added article: "$title" -> Category: $country');

          if (articles.length >= 15)
            break; // Increased limit to get more articles
        } catch (e) {
          print('Error parsing article: $e');
          continue;
        }
      }

      return articles;
    } catch (e) {
      print('Error scraping from $url: $e');
      return [];
    }
  }

  static String _getPublisherFromUrl(String url) {
    final uri = Uri.parse(url);
    final host = uri.host.toLowerCase();

    if (host.contains('africanews')) return 'AfricaNews';
    if (host.contains('allafrica')) return 'AllAfrica';
    if (host.contains('news24')) return 'News24';

    return 'African News Source';
  }

  static Future<String> _getArticleContent(String url) async {
    try {
      if (url.isEmpty) return '';

      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));

      if (response.statusCode != 200) return '';

      final document = html_parser.parse(response.body);

      final contentSelectors = [
        '.article-content',
        '.entry-content',
        '.post-content',
        '.story-content',
        'article',
        '.content',
        '[class*="content"]'
      ];

      for (final selector in contentSelectors) {
        final contentElement = document.querySelector(selector);
        if (contentElement != null) {
          contentElement
              .querySelectorAll(
                  'script, .ad, .advertisement, .social-share, .related-posts')
              .forEach((element) => element.remove());
          final content = contentElement.text.trim();
          if (content.length > 100) {
            return content;
          }
        }
      }

      return '';
    } catch (e) {
      print('Error fetching article content: $e');
      return '';
    }
  }

  static List<Map<String, dynamic>> _getFallbackAfricanNews() {
    print('Using fallback African news data');
    final now = DateTime.now().toIso8601String();

    return [
      // Nigeria news
      {
        'title': 'Nigeria President Tinubu Announces New Economic Reforms',
        'description':
            'Nigerian President Bola Tinubu unveils comprehensive economic reform package to boost GDP growth and tackle inflation.',
        'publishers': 'AfricaNews',
        'articleUrl': 'https://www.africanews.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/08/05/12/08/africa-2583952_960_720.jpg',
        'articleBody':
            'Nigeria continues to demonstrate economic resilience with President Bola Tinubu announcing new reforms. The Lagos-based government is implementing policies to diversify the economy beyond oil dependency.',
        'urlLink': 'https://www.africanews.com',
        'country': 'Nigeria',
        'created_at': now,
      },
      {
        'title': 'Lagos Traffic Management System Gets Major Upgrade',
        'description':
            'Lagos State government introduces smart traffic solutions to ease congestion in Nigeria\'s commercial capital.',
        'publishers': 'Nigerian Tribune',
        'articleUrl': 'https://www.tribuneonlineng.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2018/11/29/21/19/hamburg-3846525_960_720.jpg',
        'articleBody':
            'Lagos, Nigeria\'s bustling commercial hub, is implementing cutting-edge traffic management technology to address the city\'s notorious congestion problems.',
        'urlLink': 'https://www.tribuneonlineng.com',
        'country': 'Nigeria',
        'created_at': now,
      },

      // Kenya news
      {
        'title': 'Kenya Leads East Africa in Renewable Energy Innovation',
        'description':
            'Kenyan companies pioneer solar and wind energy solutions, attracting international investment to Nairobi tech hub.',
        'publishers': 'AllAfrica',
        'articleUrl': 'https://allafrica.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2019/02/28/17/23/wind-4026914_960_720.jpg',
        'articleBody':
            'Kenya has emerged as East Africa\'s renewable energy leader. Nairobi-based startups are developing innovative solutions, while President William Ruto\'s administration promotes green energy initiatives.',
        'urlLink': 'https://allafrica.com',
        'country': 'Kenya',
        'created_at': now,
      },
      {
        'title': 'Kenyan Shilling Stabilizes Against Major Currencies',
        'description':
            'Kenya\'s central bank reports improved foreign exchange reserves as the shilling gains strength.',
        'publishers': 'Business Daily Africa',
        'articleUrl': 'https://www.businessdailyafrica.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2016/11/27/21/42/stock-1863880_960_720.jpg',
        'articleBody':
            'The Kenyan shilling has shown remarkable stability, with the Central Bank of Kenya implementing successful monetary policies to strengthen the currency.',
        'urlLink': 'https://www.businessdailyafrica.com',
        'country': 'Kenya',
        'created_at': now,
      },

      // South Africa news
      {
        'title': 'South African Rand Strengthens Amid Economic Optimism',
        'description':
            'South Africa sees currency gains as President Cyril Ramaphosa\'s economic policies show positive results.',
        'publishers': 'News24',
        'articleUrl': 'https://www.news24.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2018/05/08/21/29/cyber-3384744_960_720.jpg',
        'articleBody':
            'The South African rand has strengthened significantly, with Johannesburg Stock Exchange posting gains. President Cyril Ramaphosa\'s administration continues implementing economic reforms.',
        'urlLink': 'https://www.news24.com',
        'country': 'South Africa',
        'created_at': now,
      },
      {
        'title': 'Cape Town Leads Africa in Tech Innovation',
        'description':
            'South African city emerges as continental technology hub, attracting startups and international investment.',
        'publishers': 'TechCentral',
        'articleUrl': 'https://techcentral.co.za',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/12/10/22/21/cape-town-3010962_960_720.jpg',
        'articleBody':
            'Cape Town, South Africa, is solidifying its position as Africa\'s premier tech destination, with numerous startups choosing the city for its infrastructure and talent pool.',
        'urlLink': 'https://techcentral.co.za',
        'country': 'South Africa',
        'created_at': now,
      },

      // Ethiopia news
      {
        'title': 'Ethiopian Airlines Expands Pan-African Routes',
        'description':
            'Ethiopia\'s national carrier announces new destinations, strengthening Addis Ababa\'s position as Africa\'s aviation hub.',
        'publishers': 'AfricaNews',
        'articleUrl': 'https://www.africanews.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/06/05/07/58/bridge-2373388_960_720.jpg',
        'articleBody':
            'Ethiopian Airlines continues expanding its African network from Addis Ababa, with new routes supporting Prime Minister Abiy Ahmed\'s vision of continental connectivity.',
        'urlLink': 'https://www.africanews.com',
        'country': 'Ethiopia',
        'created_at': now,
      },
      {
        'title': 'Ethiopia Coffee Exports Reach Record Highs',
        'description':
            'Ethiopian coffee industry posts strongest performance in years, boosting foreign currency earnings.',
        'publishers': 'Ethiopian Herald',
        'articleUrl': 'https://www.herald.et',
        'articeImage':
            'https://cdn.pixabay.com/photo/2015/05/07/13/46/coffee-756490_960_720.jpg',
        'articleBody':
            'Ethiopia, the birthplace of coffee, has achieved record export levels. The Ethiopian government reports significant foreign currency earnings from coffee exports.',
        'urlLink': 'https://www.herald.et',
        'country': 'Ethiopia',
        'created_at': now,
      },

      // Ghana news
      {
        'title': 'Ghana Cocoa Production Sets New Records',
        'description':
            'Ghanaian farmers achieve bumper cocoa harvest, with Accra reporting strong export performance.',
        'publishers': 'AllAfrica',
        'articleUrl': 'https://allafrica.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/08/10/02/05/tiles-2617112_960_720.jpg',
        'articleBody':
            'Ghana maintains its position as a leading cocoa producer, with record harvests boosting the economy. President Nana Akufo-Addo\'s agricultural policies show positive results.',
        'urlLink': 'https://allafrica.com',
        'country': 'Ghana',
        'created_at': now,
      },
      {
        'title': 'Ghanaian Cedi Shows Signs of Recovery',
        'description':
            'Ghana\'s currency stabilizes as the Bank of Ghana implements new monetary policies.',
        'publishers': 'GhanaWeb',
        'articleUrl': 'https://www.ghanaweb.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2016/10/11/04/08/currency-1730717_960_720.jpg',
        'articleBody':
            'The Ghanaian cedi has shown improvement against major currencies, with the Bank of Ghana\'s intervention measures proving effective in Accra\'s financial markets.',
        'urlLink': 'https://www.ghanaweb.com',
        'country': 'Ghana',
        'created_at': now,
      },
      {
        'title': 'South Africa Implements New Digital Transformation Strategy',
        'description':
            'South Africa announces comprehensive digital transformation plan to boost economic competitiveness.',
        'publishers': 'News24',
        'articleUrl': 'https://www.news24.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2018/05/08/21/29/cyber-3384744_960_720.jpg',
        'articleBody':
            'South Africa has unveiled an ambitious digital transformation strategy aimed at enhancing the country\'s economic competitiveness and technological capabilities in the digital age.',
        'urlLink': 'https://www.news24.com',
        'country': 'South Africa',
        'created_at': now,
      },
      {
        'title': 'Ethiopia Expands Infrastructure Development Projects',
        'description':
            'Ethiopia announces major infrastructure projects to boost connectivity and economic growth.',
        'publishers': 'AfricaNews',
        'articleUrl': 'https://www.africanews.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/06/05/07/58/bridge-2373388_960_720.jpg',
        'articleBody':
            'Ethiopia continues its ambitious infrastructure development program with new projects aimed at improving connectivity and supporting economic growth across the country.',
        'urlLink': 'https://www.africanews.com',
        'country': 'Ethiopia',
        'created_at': now,
      },
      {
        'title': 'Ghana Strengthens Position as West Africa Tech Hub',
        'description':
            'Ghana\'s technology sector continues to grow, attracting startups and international tech companies.',
        'publishers': 'AllAfrica',
        'articleUrl': 'https://allafrica.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/08/10/02/05/tiles-2617112_960_720.jpg',
        'articleBody':
            'Ghana is solidifying its position as West Africa\'s premier technology hub, with a thriving startup ecosystem and increasing international investment in the tech sector.',
        'urlLink': 'https://allafrica.com',
        'country': 'Ghana',
        'created_at': now,
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> scrapeFeedYourCuriosity() async {
    try {
      print('Starting to scrape Feed Your Curiosity news...');
      final articles = await scrapeAfricaNews();

      for (var article in articles) {
        // Categorize each article based on its content
        final title = article['title'] ?? '';
        final description = article['description'] ?? '';
        final content = article['content'] ?? article['articleBody'] ?? '';
        
        article['tag'] = categorizeByTopic(title, description, content);
      }

      return articles;
    } catch (e) {
      print('Error scraping Feed Your Curiosity news: $e');
      return _getFallbackFeedYourCuriosity();
    }
  }

  static List<Map<String, dynamic>> _getFallbackFeedYourCuriosity() {
    return [
      {
        'title': 'The Rise of Fintech in African Markets',
        'description':
            'How digital financial services are transforming economies across Africa.',
        'content':
            'Financial technology is revolutionizing how Africans access and use financial services. From mobile money to digital lending, fintech solutions are driving financial inclusion and economic growth across the continent.',
        'image':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3',
        'publisher': 'Feed Your Curiosity',
        'url': 'https://example.com/fintech-africa',
        'tag': 'African Tech',
        'publisherImageUrl': 'https://via.placeholder.com/150?text=FYC',
        'country': 'General Africa',
      },
      {
        'title': 'African Art and Culture in the Global Scene',
        'description':
            'Exploring how African artists are gaining international recognition.',
        'content':
            'African art and culture are experiencing unprecedented global recognition. From contemporary art galleries to international film festivals, African creativity is captivating audiences worldwide.',
        'image':
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
        'publisher': 'Feed Your Curiosity',
        'url': 'https://example.com/african-art-global',
        'tag': 'African culture',
        'publisherImageUrl': 'https://via.placeholder.com/150?text=FYC',
        'country': 'General Africa',
      },
      {
        'title': 'Sustainable Farming Practices Transforming African Agriculture',
        'description':
            'How innovative farming techniques are improving yields and sustainability across Africa.',
        'content':
            'African farmers are increasingly adopting sustainable agricultural practices that improve soil health, conserve water, and increase crop yields. These methods are helping to address food security challenges while protecting the environment.',
        'image':
            'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?ixlib=rb-4.0.3',
        'publisher': 'Feed Your Curiosity',
        'url': 'https://example.com/sustainable-farming-africa',
        'tag': 'African Agriculture',
        'publisherImageUrl': 'https://via.placeholder.com/150?text=FYC',
        'country': 'General Africa',
      },
    ];
  }

  static List<Map<String, dynamic>> getFallbackAfricanNews() {
    return _getFallbackAfricanNews();
  }

  static List<Map<String, dynamic>> getFallbackFeedYourCuriosityNews() {
    return _getFallbackFeedYourCuriosity();
  }

  static List<NewForceArticlesRow> convertToNewForceArticles(
      List<Map<String, dynamic>> scrapedNews) {
    return scrapedNews.map((article) {
      return NewForceArticlesRow({
        'title': article['title'],
        'description': article['description'],
        'article_body': article['content'] ?? article['articleBody'],
        'article_image': article['image'] ?? article['articeImage'],
        'publishers': article['publisher'] ?? article['publishers'],
        'created_at': article['created_at'] ?? DateTime.now().toIso8601String(),
        'article_url': article['url'] ?? article['articleUrl'],
        'country': article['country'] ?? 'General Africa',
      });
    }).toList();
  }

  static List<FeedYourCuriosityTopicsRow> convertToFeedYourCuriosityTopics(
      List<Map<String, dynamic>> scrapedNews) {
    return scrapedNews.map((article) {
      return FeedYourCuriosityTopicsRow({
        'title': article['title'],
        'newsDescription': article['description'],
        'newsBody': article['content'] ?? article['articleBody'],
        'image': article['image'] ?? article['articeImage'],
        'publisher': article['publisher'] ?? article['publishers'],
        'created_at': article['created_at'] ?? DateTime.now().toIso8601String(),
        'tag': article['tag'] ?? 'Technology',
        'publisherImageUrl': article['publisherImageUrl'] ?? '',
        'country': article['country'] ?? 'General Africa',
      });
    }).toList();
  }

  static String categorizeByTopic(String title, String description, String content) {
    // Convert all text to lowercase for case-insensitive matching
    final String combinedText = '${title.toLowerCase()} ${description.toLowerCase()} ${(content ?? "").toLowerCase()}';
    
    // Define keywords for each category
    final Map<String, List<String>> topicKeywords = {
      'African culture': [
        'art', 'culture', 'heritage', 'tradition', 'music', 'dance', 'festival', 
        'language', 'history', 'artifact', 'museum', 'exhibition', 'artist', 
        'cultural', 'traditional', 'ceremony', 'ritual', 'craft', 'indigenous', 
        'identity', 'folklore', 'storytelling', 'literature', 'poetry', 'fashion'
      ],
      'African Agriculture': [
        'agriculture', 'farming', 'crop', 'harvest', 'farm', 'food', 'production', 
        'livestock', 'irrigation', 'soil', 'seed', 'sustainable', 'organic', 
        'farmer', 'plantation', 'agribusiness', 'agricultural', 'cultivation', 
        'fertilizer', 'yield', 'drought', 'climate', 'land', 'rural', 'cooperative'
      ],
      'African Tech': [
        'technology', 'tech', 'digital', 'innovation', 'startup', 'fintech', 
        'mobile', 'app', 'software', 'hardware', 'internet', 'ai', 'artificial intelligence', 
        'blockchain', 'cryptocurrency', 'iot', 'internet of things', 'coding', 
        'developer', 'programming', 'incubator', 'accelerator', 'venture capital', 
        'investment', 'e-commerce', 'telecommunications'
      ]
    };
    
    // Count matches for each category
    final Map<String, int> matchCounts = {};
    
    topicKeywords.forEach((topic, keywords) {
      int count = 0;
      for (final keyword in keywords) {
        if (combinedText.contains(keyword)) {
          count++;
        }
      }
      matchCounts[topic] = count;
    });
    
    // Find the category with the most matches
    String bestMatch = 'African Tech'; // Default category
    int highestCount = 0;
    
    matchCounts.forEach((topic, count) {
      if (count > highestCount) {
        highestCount = count;
        bestMatch = topic;
      }
    });
    
    return bestMatch;
  }
}
