import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl = 'https://newsapi.org/v2';

  // Get API key from environment variables
  static String get apiKey {
    final key = dotenv.env['API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('API_KEY not found in .env file');
    }
    return key;
  }

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // Categories
  static const List<String> categories = [
    'general',
    'technology',
    'business',
    'sports',
    'health',
    'science',
    'entertainment',
  ];

  // Countries
  static const String defaultCountry = 'us';

  // App info
  static const String appName = 'News App';
  static const String appVersion = '1.0.0';
}
