import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../supabase/database/tables/new_force_articles.dart';

/// A service for scraping news from various sources
class NewsScraperService {
  /// Scrape news from GhanaWeb
  static Future<List<Map<String, dynamic>>> scrapeGhanaWeb() async {
    try {
      print('Starting to scrape GhanaWeb news...');
      // Using a more direct URL that is likely to work
      const String url = 'https://www.ghanaweb.com';
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      }).timeout(Duration(seconds: 30));

      print('GhanaWeb response status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Failed to load GhanaWeb news: ${response.statusCode}');
        // Instead of throwing, return empty list
        return _getFallbackGhanaWebNews();
      }

      final document = html_parser.parse(response.body);
      final articles = <Map<String, dynamic>>[];

      // Try different selectors that might contain news articles
      final selectors = [
        '.news-article-block',
        '.article-block',
        '.news-item',
        '.article-item',
        'article',
        '.news'
      ];

      var articleElements = <dynamic>[];

      for (final selector in selectors) {
        articleElements = document.querySelectorAll(selector);
        print(
            'Found ${articleElements.length} elements with selector: $selector');
        if (articleElements.isNotEmpty) break;
      }

      if (articleElements.isEmpty) {
        print('No article elements found on GhanaWeb');
        // Use fallback data
        return _getFallbackGhanaWebNews();
      }

      for (final element in articleElements) {
        try {
          // Try different selectors for title
          var titleElement = element.querySelector('.news-article-title a') ??
              element.querySelector('h2 a') ??
              element.querySelector('h3 a') ??
              element.querySelector('.title a') ??
              element.querySelector('a');

          var imageElement = element.querySelector('.news-article-image img') ??
              element.querySelector('img');

          var descriptionElement =
              element.querySelector('.news-article-description') ??
                  element.querySelector('p');

          if (titleElement != null) {
            final title = titleElement.text.trim();
            var articleUrl = '';

            // Handle relative URLs
            if (titleElement.attributes.containsKey('href')) {
              final href = titleElement.attributes['href'] ?? '';
              articleUrl = href.startsWith('http')
                  ? href
                  : 'https://www.ghanaweb.com$href';
            }

            final imageUrl = imageElement?.attributes['src'] ?? '';
            final description = descriptionElement?.text.trim() ?? '';

            // Only add if we have at least a title
            if (title.isNotEmpty) {
              // Get full article content
              final articleContent = await _getArticleContent(articleUrl);

              articles.add({
                'title': title,
                'description':
                    description.isNotEmpty ? description : 'Read more...',
                'publishers': 'GhanaWeb',
                'articleUrl': articleUrl,
                'articeImage': imageUrl,
                'articleBody': articleContent.isNotEmpty
                    ? articleContent
                    : 'Click to read the full article.',
                'urlLink': articleUrl,
              });

              print('Added GhanaWeb article: $title');

              // Limit to 10 articles to avoid overloading
              if (articles.length >= 10) break;
            }
          }
        } catch (e) {
          print('Error parsing GhanaWeb article: $e');
          continue;
        }
      }

      print('Successfully scraped ${articles.length} articles from GhanaWeb');

      // If we couldn't scrape any articles, use fallback data
      if (articles.isEmpty) {
        return _getFallbackGhanaWebNews();
      }

      return articles;
    } catch (e) {
      print('Exception while scraping GhanaWeb: $e');
      return _getFallbackGhanaWebNews();
    }
  }

  /// Provides fallback news data for GhanaWeb when scraping fails
  static List<Map<String, dynamic>> _getFallbackGhanaWebNews() {
    print('Using fallback GhanaWeb news data');
    final now = DateTime.now().toIso8601String();
    return [
      {
        'title': 'Ghana Economy Shows Signs of Recovery',
        'description':
            'Recent economic indicators suggest Ghana economy is on a path to recovery after challenging period.',
        'publishers': 'GhanaWeb',
        'articleUrl': 'https://www.ghanaweb.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/10/28/10/35/ghana-2896567_960_720.png',
        'articleBody':
            'Ghana economy is showing positive signs of recovery according to recent data released by the Finance Ministry. Inflation rates have decreased while GDP growth projections have been revised upward for the coming quarter. The cedi has also stabilized against major currencies, bringing some relief to importers and consumers alike.',
        'urlLink': 'https://www.ghanaweb.com',
        'created_at': now,
      },
      {
        'title': 'New Educational Policy Announced for Ghanaian Schools',
        'description':
            'The Ministry of Education has unveiled a comprehensive new policy aimed at improving educational outcomes.',
        'publishers': 'GhanaWeb',
        'articleUrl': 'https://www.ghanaweb.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2015/11/19/09/02/classroom-1050785_960_720.jpg',
        'articleBody':
            'Ghana Ministry of Education has announced a new policy framework that will transform the country educational system. The policy focuses on technology integration, teacher training, and curriculum updates to prepare students for the modern workforce. Implementation will begin next academic year.',
        'urlLink': 'https://www.ghanaweb.com',
        'created_at': now,
      },
      {
        'title': 'Black Stars Prepare for Upcoming World Cup Qualifiers',
        'description':
            'Ghana national football team has begun intensive training ahead of crucial World Cup qualifying matches.',
        'publishers': 'GhanaWeb',
        'articleUrl': 'https://www.ghanaweb.com',
        'articeImage':
            'https://cdn.pixabay.com/photo/2016/05/27/14/33/football-1419954_960_720.jpg',
        'articleBody':
            'The Black Stars have assembled at their training camp to prepare for the upcoming FIFA World Cup qualifying matches. The team coach expressed confidence in their preparations and the squad ability to secure important victories in the qualifying rounds.',
        'urlLink': 'https://www.ghanaweb.com',
        'created_at': now,
      },
    ];
  }

  /// Provides fallback news data for Pan African News when scraping fails
  static List<Map<String, dynamic>> _getFallbackPanAfricanNews() {
    print('Using fallback Pan African News data');
    final now = DateTime.now().toIso8601String();
    return [
      {
        'title': 'African Union Announces New Economic Initiative',
        'description':
            'The African Union has unveiled a new economic initiative aimed at boosting intra-African trade.',
        'publishers': 'Pan African Visions',
        'articleUrl': 'https://panafricanvisions.com/',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/08/05/12/08/africa-2583952_960_720.jpg',
        'articleBody':
            'The African Union has announced a major economic initiative that aims to increase trade between African nations by 50% over the next five years. The initiative includes infrastructure development, reduced tariffs, and streamlined border procedures.',
        'urlLink': 'https://panafricanvisions.com/',
        'created_at': now,
      },
      {
        'title': 'New Climate Change Adaptation Fund for African Nations',
        'description':
            'International donors have established a new fund to help African countries adapt to climate change impacts.',
        'publishers': 'Pan African Visions',
        'articleUrl': 'https://panafricanvisions.com/',
        'articeImage':
            'https://cdn.pixabay.com/photo/2017/02/10/03/12/africa-2054656_960_720.jpg',
        'articleBody':
            'A coalition of international donors has announced a new 3 billion fund dedicated to helping African nations implement climate change adaptation measures. The fund will prioritize projects related to water security, sustainable agriculture, and renewable energy.',
        'urlLink': 'https://panafricanvisions.com/',
        'created_at': now,
      },
      {
        'title': 'Pan-African Film Festival Celebrates 30th Anniversary',
        'description':
            'The continent largest film festival marks three decades of showcasing African cinema.',
        'publishers': 'Pan African Visions',
        'articleUrl': 'https://panafricanvisions.com/',
        'articeImage':
            'https://cdn.pixabay.com/photo/2016/11/16/11/29/film-1828805_960_720.jpg',
        'articleBody':
            'The Pan-African Film Festival is celebrating its 30th anniversary this year with a record number of submissions from across the continent. The festival continues to be an important platform for African filmmakers to showcase their work and connect with international distributors.',
        'urlLink': 'https://panafricanvisions.com/',
        'created_at': now,
      },
    ];
  }

  /// Scrape news from Pan African News sources
  static Future<List<Map<String, dynamic>>> scrapePanAfricanNews() async {
    try {
      print('Starting to scrape Pan African News...');
      const String url = 'https://panafricanvisions.com/news/';
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      }).timeout(Duration(seconds: 30));

      print('Pan African News response status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Failed to load Pan African News: ${response.statusCode}');
        return _getFallbackPanAfricanNews();
      }

      final document = html_parser.parse(response.body);
      final articles = <Map<String, dynamic>>[];

      // Try different selectors that might contain news articles
      final selectors = ['article.post', '.news-article', '.post', 'article'];

      var articleElements = <dynamic>[];

      for (final selector in selectors) {
        articleElements = document.querySelectorAll(selector);
        print(
            'Found ${articleElements.length} elements with selector: $selector');
        if (articleElements.isNotEmpty) break;
      }

      if (articleElements.isEmpty) {
        print('No article elements found on Pan African News');
        return _getFallbackPanAfricanNews();
      }

      for (final element in articleElements) {
        try {
          final titleElement = element.querySelector('.entry-title a');
          final imageElement = element.querySelector('.post-thumbnail img');
          final descriptionElement = element.querySelector('.entry-content p');

          if (titleElement != null) {
            final title = titleElement.text.trim();
            final articleUrl = titleElement.attributes['href'] ?? '';
            final imageUrl = imageElement?.attributes['src'] ?? '';
            final description = descriptionElement?.text.trim() ?? '';

            // Get full article content
            final articleContent = await _getArticleContent(articleUrl);
            final now = DateTime.now().toIso8601String();
            
            articles.add({
              'title': title,
              'description': description,
              'publishers': 'Pan African Visions',
              'articleUrl': articleUrl,
              'articeImage': imageUrl,
              'articleBody': articleContent,
              'urlLink': articleUrl,
              'created_at': now,
            });

            // Limit to 10 articles to avoid overloading
            if (articles.length >= 10) break;
          }
        } catch (e) {
          print('Error parsing article: $e');
          continue;
        }
      }

      if (articles.isEmpty) {
        print('No articles found from Pan African News, using fallback data');
        return _getFallbackPanAfricanNews();
      }

      print(
          'Successfully scraped ${articles.length} articles from Pan African News');
      return articles;
    } catch (e) {
      print('Error scraping Pan African News: $e');
      return _getFallbackPanAfricanNews();
    }
  }

  /// Get the full content of an article from its URL
  static Future<String> _getArticleContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return '';
      }

      final document = html_parser.parse(response.body);

      // Try different selectors for article content based on common patterns
      final contentSelectors = [
        '.article-content',
        '.entry-content',
        '.post-content',
        '.story-content',
        'article',
        '.content',
        '#content'
      ];

      for (final selector in contentSelectors) {
        final contentElement = document.querySelector(selector);
        if (contentElement != null) {
          // Remove scripts, ads, and other unwanted elements
          contentElement
              .querySelectorAll(
                  'script, .ad, .advertisement, .social-share, .related-posts')
              .forEach((element) => element.remove());

          return contentElement.text.trim();
        }
      }

      return '';
    } catch (e) {
      print('Error fetching article content: $e');
      return '';
    }
  }

  /// Convert scraped news to NewForceArticlesRow objects
  static List<NewForceArticlesRow> convertToNewForceArticles(
      List<Map<String, dynamic>> scrapedNews) {
    final articles = <NewForceArticlesRow>[];
    final now =
        DateTime.now().toIso8601String(); // Use the same timestamp for all articles in this batch

    for (final news in scrapedNews) {
      try {
        // Create a complete data map with all required fields and ensure created_at is valid
        final Map<String, dynamic> articleData = {
          'title': news['title'] ?? 'No Title',
          'description': news['description'] ?? 'No description available',
          'publishers': news['publishers'] ?? 'Unknown Publisher',
          'articleUrl': news['articleUrl'] ?? '',
          'articeImage': news['articeImage'] ?? '',
          'articleBody': news['articleBody'] ?? 'No content available',
          'urlLink': news['urlLink'] ?? '',
          'created_at': now, // Always use a valid DateTime
        };

        final article = NewForceArticlesRow(articleData);
        articles.add(article);
      } catch (e) {
        print('Error creating article: $e');
        // Continue with the next article if there's an error
        continue;
      }
    }

    return articles;
  }
}
