import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

class NewsAPI {
  final String apiKey = '';
  final String baseUrl = 'https://newsapi.org/v2';
  final String topHeadlinesUrl = '/top-headlines';
  final String everythingUrl = '/everything';
  final int pageSize = 10;

  Future<List<Article>> fetchTopHeadlines(Preferences preferences) async {
    final country = 'us';

    final String url =
        '$baseUrl$topHeadlinesUrl?country=$country&apiKey=$apiKey';

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
    final country = 'us';
    final category = 'business';
    final query = 'tesla';
    final sortBy = 'publishedAt';
    final from = '2021-09-01';
    final to = '2021-09-30';
    final language = 'en';

    final String url =
        '$baseUrl$everythingUrl?q=$query&country=$country&language=$language&category=$category&sortBy=$sortBy&from=$from&to=$to&pageSize=$pageSize&apiKey=$apiKey';

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
}
