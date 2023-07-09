import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

class NewsAPI {
  final String apiKey = 'a6c09d9ab14a4881ab19c1901f568684';
  final String baseUrl = 'https://newsapi.org/v2';
  final String topHeadlinesUrl = '/top-headlines';
  final String everythingUrl = '/everything';
  final int topHeadlinesPageSize = 10;
  final int everythingPageSize = 20;

  Future<List<Article>> fetchTopHeadlines(Preferences preferences) async {
    final String url = parsePreferencesForHeadlines(preferences);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final articlesJson = json['articles'];

      List<Article> articles = [];

      for (var articleJson in articlesJson) {
        final article = Article.fromJson(articleJson);
        articles.add(article);
      }

      return articles;
    } else {
      throw Exception('Failed to fetch top headlines');
    }
  }

  Future<List<Article>> fetchEverything(Preferences preferences) async {
    final String url = parsePreferencesForEverything(preferences);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final articlesJson = json['articles'];

      List<Article> articles = [];

      for (var articleJson in articlesJson) {
        final article = Article.fromJson(articleJson);
        articles.add(article);
      }

      return articles;
    } else {
      throw Exception('Failed to fetch everything');
    }
  }

  String parsePreferencesForHeadlines(Preferences preferences) {
    String parsedString =
        '$baseUrl$topHeadlinesUrl?pageSize=$topHeadlinesPageSize&page=${preferences.page}&apiKey=$apiKey';
    bool requiredParametersMissing = true;
    if (preferences.country != null) {
      requiredParametersMissing = false;
      parsedString += '&country=${preferences.country}';
    }
    if (preferences.language != null) {
      requiredParametersMissing = false;
      parsedString += '&language=${preferences.language}';
    }
    if (preferences.query != null) {
      requiredParametersMissing = false;
      parsedString += '&q=${preferences.query}';
    }
    if (preferences.categories.isNotEmpty) {
      requiredParametersMissing = false;
      final categoryString = preferences.categories.join(',');
      parsedString += '&category=$categoryString';
    }
    if (requiredParametersMissing) {
      parsedString += '&country=us';
    }
    // Exclude Google News
    parsedString += '&excludeDomains=news.google.com';
    return parsedString;
  }

  String parsePreferencesForEverything(Preferences preferences) {
    String parsedString =
        '$baseUrl$everythingUrl?pageSize=$everythingPageSize&page=${preferences.page}&apiKey=$apiKey';
    bool requiredParametersMissing = true;
    if (preferences.query != null) {
      requiredParametersMissing = false;
      parsedString += '&q=${preferences.query}';
    }
    if (preferences.from != null) {
      parsedString += '&from=${preferences.from}';
    }
    if (preferences.to != null) {
      parsedString += '&to=${preferences.to}';
    }
    if (preferences.language != null) {
      parsedString += '&language=${preferences.language}';
    }
    if (preferences.sortBy != null) {
      parsedString += '&sortBy=${preferences.sortBy}';
    }
    if (requiredParametersMissing) {
      parsedString += '&domains=bbc.co.uk';
    }
    // Exclude Google News
    parsedString += '&excludeDomains=news.google.com';
    return parsedString;
  }
}
