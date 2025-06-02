import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../supabase/database/tables/new_force_articles.dart';
import '../supabase/database/tables/feed_your_curiosity_topics.dart';

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

            var imageUrl = imageElement?.attributes['src'] ?? '';
            // Make sure image URL is absolute
            if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
              imageUrl = imageUrl.startsWith('//')
                  ? 'https:$imageUrl'
                  : imageUrl.startsWith('/')
                      ? 'https://www.ghanaweb.com$imageUrl'
                      : 'https://www.ghanaweb.com/$imageUrl';
            }
            print('Found image URL: $imageUrl');
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
      // Try multiple URLs for Pan African News
      final urls = [
        'https://panafricanvisions.com/',
        'https://panafricanvisions.com/news/',
        'https://panafricanvisions.com/category/news/'
      ];

      List<Map<String, dynamic>> articles = [];

      // Try each URL until we get articles
      for (final url in urls) {
        print('Trying URL: $url');
        final response = await http.get(Uri.parse(url), headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }).timeout(Duration(seconds: 30));

        print(
            'Pan African News response status code: ${response.statusCode} for URL: $url');

        if (response.statusCode != 200) {
          print(
              'Failed to load Pan African News from $url: ${response.statusCode}');
          continue; // Try next URL
        }

        final document = html_parser.parse(response.body);

        // Try different selectors that might contain news articles
        final selectors = [
          'article',
          '.post',
          '.entry',
          '.article',
          '.news-item',
          '.blog-post',
          '.item',
          'article.post',
          '.news-article'
        ];

        var articleElements = <dynamic>[];
        var usedSelector = '';

        for (final selector in selectors) {
          articleElements = document.querySelectorAll(selector);
          print(
              'Found ${articleElements.length} elements with selector: $selector on $url');
          if (articleElements.isNotEmpty) {
            usedSelector = selector;
            break;
          }
        }

        if (articleElements.isEmpty) {
          print('No article elements found on Pan African News at $url');
          continue; // Try next URL
        }

        print(
            'Using selector: $usedSelector for ${articleElements.length} articles');

        // Print the HTML structure of the first article element for debugging
        if (articleElements.isNotEmpty) {
          print('First article element HTML structure from $url:');
          final htmlLength = articleElements.first.outerHtml.length;
          final maxLength = htmlLength < 500 ? htmlLength : 500;
          print(articleElements.first.outerHtml.substring(0, maxLength));
        }

        // Define multiple possible selectors for each element
        final titleSelectors = [
          '.entry-title a',
          'h2 a',
          'h3 a',
          '.title a',
          'a.title',
          'header h2 a',
          'a'
        ];
        final imageSelectors = [
          '.post-thumbnail img',
          'img',
          '.featured-image img',
          '.entry-image img'
        ];
        final descriptionSelectors = [
          '.entry-content p',
          '.excerpt',
          '.entry-excerpt',
          '.summary',
          'p',
          '.content p'
        ];

        for (final element in articleElements) {
          try {
            // Try to find title using multiple selectors
            var titleElement;
            for (final selector in titleSelectors) {
              titleElement = element.querySelector(selector);
              if (titleElement != null) {
                print('Found title with selector: $selector');
                break;
              }
            }

            if (titleElement != null) {
              final title = titleElement.text.trim();
              print('Found title: $title');

              var articleUrl = '';
              // Handle relative URLs
              if (titleElement.attributes.containsKey('href')) {
                final href = titleElement.attributes['href'] ?? '';
                articleUrl = href.startsWith('http')
                    ? href
                    : 'https://panafricanvisions.com$href';
              }
              print('Article URL: $articleUrl');

              // Try to find image using multiple selectors
              var imageElement;
              var imageUrl = '';
              for (final selector in imageSelectors) {
                imageElement = element.querySelector(selector);
                if (imageElement != null) {
                  imageUrl = imageElement?.attributes['src'] ?? '';
                  // Make sure image URL is absolute
                  if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                    imageUrl = imageUrl.startsWith('//')
                        ? 'https:$imageUrl'
                        : imageUrl.startsWith('/')
                            ? 'https://panafricanvisions.com$imageUrl'
                            : 'https://panafricanvisions.com/$imageUrl';
                  }
                  print('Image URL: $imageUrl');
                  if (imageUrl.isNotEmpty) {
                    print('Found image with selector: $selector');
                    break;
                  }
                }
              }
              print('Image URL: $imageUrl');

              // Try to find description using multiple selectors
              var descriptionElement;
              var description = '';
              for (final selector in descriptionSelectors) {
                descriptionElement = element.querySelector(selector);
                if (descriptionElement != null) {
                  description = descriptionElement.text.trim();
                  if (description.isNotEmpty) {
                    print('Found description with selector: $selector');
                    break;
                  }
                }
              }

              if (description.isNotEmpty) {
                final maxPreviewLength =
                    description.length > 50 ? 50 : description.length;
                print(
                    'Description: ${description.substring(0, maxPreviewLength)}...');
              }

              // Only add if we have at least a title and URL
              if (title.isNotEmpty && articleUrl.isNotEmpty) {
                // Get full article content
                final articleContent = await _getArticleContent(articleUrl);
                final now = DateTime.now().toIso8601String();

                articles.add({
                  'title': title,
                  'description':
                      description.isNotEmpty ? description : 'Read more...',
                  'publishers': 'Pan African Visions',
                  'articleUrl': articleUrl,
                  'articeImage': imageUrl,
                  'articleBody': articleContent.isNotEmpty
                      ? articleContent
                      : 'Click to read the full article.',
                  'urlLink': articleUrl,
                  'created_at': now,
                });

                print('Successfully added article: $title');

                // Limit to 10 articles to avoid overloading
                if (articles.length >= 10) break;
              } else {
                print('Skipping article with empty title or URL');
              }
            } else {
              print('No title element found in article');
            }
          } catch (e) {
            print('Error parsing article: $e');
            continue;
          }
        }

        // If we found articles from this URL, stop trying other URLs
        if (articles.isNotEmpty) {
          break;
        }
      }

      if (articles.isEmpty) {
        print(
            'No articles found from Pan African News on any URL, using fallback data');
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
    return scrapedNews.map((article) {
      return NewForceArticlesRow({
        'title': article['title'],
        'description': article['description'],
        'articleBody': article['content'] ?? article['articleBody'],
        'articeImage': article['image'] ?? article['articeImage'],
        'publishers': article['publisher'] ?? article['publishers'],
        'created_at': DateTime.now().toIso8601String(),
        'articleUrl': article['url'] ?? article['articleUrl'],
      });
    }).toList();
  }

  /// Scrape news from Feed Your Curiosity sources (reusing Pan African News logic)
  static Future<List<Map<String, dynamic>>> scrapeFeedYourCuriosity() async {
    try {
      print('Starting to scrape Feed Your Curiosity news...');
      // Reuse the Pan African News scraper logic but tag articles differently
      final articles = await scrapePanAfricanNews();

      // Tag articles as Feed Your Curiosity
      for (var article in articles) {
        article['tag'] = 'Feed Your Curiosity';
      }

      return articles;
    } catch (e) {
      print('Error scraping Feed Your Curiosity news: $e');
      return _getFallbackFeedYourCuriosity();
    }
  }

  /// Public method to get fallback GhanaWeb news
  static List<Map<String, dynamic>> getFallbackGhanaWebNews() {
    return _getFallbackGhanaWebNews();
  }

  /// Public method to get fallback Pan African news
  static List<Map<String, dynamic>> getFallbackPanAfricanNews() {
    return _getFallbackPanAfricanNews();
  }

  /// Public method to get fallback Feed Your Curiosity news
  static List<Map<String, dynamic>> getFallbackFeedYourCuriosityNews() {
    return _getFallbackFeedYourCuriosity();
  }

  /// Provides fallback data for Feed Your Curiosity when scraping fails
  static List<Map<String, dynamic>> _getFallbackFeedYourCuriosity() {
    return [
      {
        'title': 'The Future of AI in African Tech Ecosystems',
        'description':
            'How artificial intelligence is transforming technology landscapes across Africa.',
        'content':
            'Artificial intelligence is rapidly transforming technology ecosystems across Africa. From healthcare to agriculture, AI applications are solving unique challenges and creating new opportunities for innovation. Several tech hubs in countries like Nigeria, Kenya, and South Africa are leading the charge, developing AI solutions tailored to local needs. These innovations include predictive analytics for crop yields, AI-powered diagnostic tools for rural healthcare, and natural language processing systems for local languages. As infrastructure improves and more investment flows into the continent, Africa is positioned to leverage AI technologies in ways that address its unique challenges while creating sustainable growth opportunities.',
        'image':
            'https://images.unsplash.com/photo-1526378800651-c32d170fe6f8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1769&q=80',
        'publisher': 'Feed Your Curiosity',
        'url': 'https://example.com/ai-in-africa',
        'tag': 'Technology',
        'publisherImageUrl': 'https://via.placeholder.com/150?text=FYC',
      },
      {
        'title': 'Renewable Energy Solutions for Rural Communities',
        'description':
            'Innovative approaches to bringing sustainable power to underserved areas.',
        'content':
            'Across Africa, innovative renewable energy solutions are bringing power to rural communities that have long lived without reliable electricity. Solar mini-grids, wind power installations, and micro-hydro systems are being deployed in remote areas, transforming daily life and creating economic opportunities. These technologies are not only environmentally friendly but also economically viable in regions where traditional grid extension would be prohibitively expensive. Local entrepreneurs are developing business models that make these solutions affordable through pay-as-you-go systems and community ownership structures. The impact extends beyond just providing light—it enables education, healthcare improvements, and new business opportunities.',
        'image':
            'https://images.unsplash.com/photo-1509391366360-2e959784a276?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1772&q=80',
        'publisher': 'Feed Your Curiosity',
        'url': 'https://example.com/renewable-energy-africa',
        'tag': 'Energy',
        'publisherImageUrl': 'https://via.placeholder.com/150?text=FYC',
      },
    ];
  }

  /// Convert scraped news to FeedYourCuriosityTopicsRow objects
  static List<FeedYourCuriosityTopicsRow> convertToFeedYourCuriosityTopics(
      List<Map<String, dynamic>> scrapedNews) {
    return scrapedNews.map((article) {
      return FeedYourCuriosityTopicsRow({
        'title': article['title'],
        'newsDescription': article['description'],
        'newsBody': article['content'] ?? article['articleBody'],
        'image': article['image'] ?? article['articeImage'],
        'publisher': article['publisher'] ?? article['publishers'],
        'created_at': DateTime.now().toIso8601String(),
        'tag': article['tag'] ?? 'Technology', // Default tag if not provided
        'publisherImageUrl':
            article['publisherImageUrl'] ?? '', // Optional publisher image
      });
    }).toList();
  }
}
