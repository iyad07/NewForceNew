// Country Mapping Utility
// This utility helps validate and map country names between your database and the news scraper

class CountryMappingUtility {
  // Exact country names from your database
  static const List<String> databaseCountries = [
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

  // Alternative names that might appear in news sources
  static const Map<String, String> alternativeNames = {
    'Democratic Republic of the Congo': 'Congo (Kinshasa)',
    'DRC': 'Congo (Kinshasa)',
    'Congo-Kinshasa': 'Congo (Kinshasa)',
    'DR Congo': 'Congo (Kinshasa)',
    'Republic of the Congo': 'Congo (Brazzaville)',
    'Congo-Brazzaville': 'Congo (Brazzaville)',
    'Republic of Congo': 'Congo (Brazzaville)',
    'Cote d\'Ivoire': 'Côte d\'Ivoire',
    'Ivory Coast': 'Côte d\'Ivoire',
    'Swaziland': 'Eswatini',
    'Kingdom of Eswatini': 'Eswatini',
    'Cabo Verde': 'Cape Verde',
    'Republic of Cape Verde': 'Cape Verde',
    'São Tomé and Príncipe': 'Sao Tome and Principe',
    'Sao Tome & Principe': 'Sao Tome and Principe',
    'Central African Rep': 'Central African Republic',
    'CAR': 'Central African Republic',
    'The Gambia': 'Gambia',
    'Islamic Republic of Mauritania': 'Mauritania',
    'Republic of South Sudan': 'South Sudan',
    'Republic of Sudan': 'Sudan',
    'United Republic of Tanzania': 'Tanzania',
    'Federal Republic of Nigeria': 'Nigeria',
    'Republic of Kenya': 'Kenya',
    'Republic of Ghana': 'Ghana',
    'Arab Republic of Egypt': 'Egypt',
    'Kingdom of Morocco': 'Morocco',
    'People\'s Democratic Republic of Algeria': 'Algeria',
    'Republic of South Africa': 'South Africa',
    'Federal Democratic Republic of Ethiopia': 'Ethiopia',
    'Republic of Uganda': 'Uganda',
    'Republic of Angola': 'Angola',
    'Republic of Mozambique': 'Mozambique',
    'Republic of Madagascar': 'Madagascar',
    'Republic of Cameroon': 'Cameroon',
    'Republic of Niger': 'Niger',
    'Republic of Mali': 'Mali',
    'Republic of Burkina Faso': 'Burkina Faso',
    'Republic of Senegal': 'Senegal',
    'Republic of Guinea': 'Guinea',
    'Republic of Benin': 'Benin',
    'Togolese Republic': 'Togo',
    'Republic of Sierra Leone': 'Sierra Leone',
    'Republic of Liberia': 'Liberia',
    'Republic of Guinea-Bissau': 'Guinea-Bissau',
    'Republic of Zambia': 'Zambia',
    'Republic of Zimbabwe': 'Zimbabwe',
    'Republic of Botswana': 'Botswana',
    'Republic of Namibia': 'Namibia',
    'Kingdom of Lesotho': 'Lesotho',
    'Republic of Malawi': 'Malawi',
    'Union of the Comoros': 'Comoros',
    'Republic of Mauritius': 'Mauritius',
    'Republic of Seychelles': 'Seychelles',
    'Republic of Djibouti': 'Djibouti',
    'State of Eritrea': 'Eritrea',
    'Somali Republic': 'Somalia',
    'Republic of Rwanda': 'Rwanda',
    'Republic of Burundi': 'Burundi',
    'Republic of Chad': 'Chad',
    'Gabonese Republic': 'Gabon',
    'Republic of Equatorial Guinea': 'Equatorial Guinea',
    'Great Socialist People\'s Libyan Arab Jamahiriya': 'Libya',
    'Libyan Arab Jamahiriya': 'Libya',
    'State of Libya': 'Libya',
    'Tunisian Republic': 'Tunisia',
    'Republic of Tunisia': 'Tunisia',
  };

  // Regional mappings
  static const Map<String, List<String>> regionalMapping = {
    'North Africa': [
      'Algeria', 'Egypt', 'Libya', 'Morocco', 'Sudan', 'Tunisia'
    ],
    'West Africa': [
      'Benin', 'Burkina Faso', 'Cape Verde', 'Côte d\'Ivoire', 'Gambia', 
      'Ghana', 'Guinea', 'Guinea-Bissau', 'Liberia', 'Mali', 'Mauritania', 
      'Niger', 'Nigeria', 'Senegal', 'Sierra Leone', 'Togo'
    ],
    'Central Africa': [
      'Cameroon', 'Central African Republic', 'Chad', 'Congo (Kinshasa)', 
      'Congo (Brazzaville)', 'Equatorial Guinea', 'Gabon', 'Sao Tome and Principe'
    ],
    'East Africa': [
      'Burundi', 'Comoros', 'Djibouti', 'Eritrea', 'Ethiopia', 'Kenya', 
      'Madagascar', 'Malawi', 'Mauritius', 'Rwanda', 'Seychelles', 'Somalia', 
      'South Sudan', 'Tanzania', 'Uganda'
    ],
    'Southern Africa': [
      'Angola', 'Botswana', 'Eswatini', 'Lesotho', 'Mozambique', 'Namibia', 
      'South Africa', 'Zambia', 'Zimbabwe'
    ]
  };

  // Priority countries for enhanced news coverage
  static const List<String> priorityCountries = [
    'Nigeria', 'South Africa', 'Egypt', 'Kenya', 'Ghana', 'Morocco', 
    'Ethiopia', 'Tanzania', 'Uganda', 'Angola', 'Algeria', 'Tunisia'
  ];

  /// Normalizes a country name to match database spelling
  static String normalizeCountryName(String countryName) {
    final normalized = countryName.trim();
    
    // Check if it's already a valid database country
    if (databaseCountries.contains(normalized)) {
      return normalized;
    }
    
    // Check alternative names
    if (alternativeNames.containsKey(normalized)) {
      return alternativeNames[normalized]!;
    }
    
    // Case-insensitive search in alternative names
    for (final entry in alternativeNames.entries) {
      if (entry.key.toLowerCase() == normalized.toLowerCase()) {
        return entry.value;
      }
    }
    
    // Case-insensitive search in database countries
    for (final country in databaseCountries) {
      if (country.toLowerCase() == normalized.toLowerCase()) {
        return country;
      }
    }
    
    // If no match found, return 'General Africa'
    return 'General Africa';
  }

  /// Gets the region for a given country
  static String getRegionForCountry(String countryName) {
    final normalizedCountry = normalizeCountryName(countryName);
    
    for (final entry in regionalMapping.entries) {
      if (entry.value.contains(normalizedCountry)) {
        return entry.key;
      }
    }
    
    return 'Africa';
  }

  /// Validates if a country exists in the database
  static bool isValidCountry(String countryName) {
    return normalizeCountryName(countryName) != 'General Africa';
  }

  /// Gets all countries in a specific region
  static List<String> getCountriesInRegion(String region) {
    return regionalMapping[region] ?? [];
  }

  /// Checks if a country is a priority country
  static bool isPriorityCountry(String countryName) {
    final normalizedCountry = normalizeCountryName(countryName);
    return priorityCountries.contains(normalizedCountry);
  }

  /// Gets a list of all valid database countries
  static List<String> getAllValidCountries() {
    return List.from(databaseCountries);
  }

  /// Gets country keywords for news categorization
  static List<String> getCountryKeywords(String countryName) {
    final normalizedCountry = normalizeCountryName(countryName);
    
    // Return basic keywords based on country name
    final keywords = <String>[normalizedCountry.toLowerCase()];
    
    // Add alternative spellings
    alternativeNames.entries
        .where((entry) => entry.value == normalizedCountry)
        .forEach((entry) => keywords.add(entry.key.toLowerCase()));
    
    return keywords;
  }

  /// Validates country distribution for news articles
  static Map<String, List<String>> validateCountryDistribution(
      Map<String, List<dynamic>> distribution) {
    final validatedDistribution = <String, List<String>>{};
    
    for (final entry in distribution.entries) {
      final normalizedCountry = normalizeCountryName(entry.key);
      validatedDistribution[normalizedCountry] = 
          entry.value.map((item) => item.toString()).toList();
    }
    
    return validatedDistribution;
  }

  /// Debug method to print country mapping validation
  static void printCountryValidation() {
    print('=== COUNTRY MAPPING VALIDATION ===');
    print('Total database countries: ${databaseCountries.length}');
    print('Total alternative mappings: ${alternativeNames.length}');
    print('Total regions: ${regionalMapping.length}');
    print('Priority countries: ${priorityCountries.length}');
    
    print('\nRegional distribution:');
    regionalMapping.forEach((region, countries) {
      print('$region: ${countries.length} countries');
    });
    
    print('\nPriority countries:');
    priorityCountries.forEach((country) {
      final region = getRegionForCountry(country);
      print('$country ($region)');
    });
    
    print('=====================================');
  }

  /// Test method to validate specific country names
  static void testCountryNormalization(List<String> testNames) {
    print('=== COUNTRY NORMALIZATION TEST ===');
    for (final name in testNames) {
      final normalized = normalizeCountryName(name);
      final region = getRegionForCountry(normalized);
      final isPriority = isPriorityCountry(name);
      print('$name -> $normalized ($region) [Priority: $isPriority]');
    }
    print('==================================');
  }
}