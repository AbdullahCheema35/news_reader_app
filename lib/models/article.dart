import 'package:flutter_riverpod/flutter_riverpod.dart';

class Article {
  final String title;
  final String source;
  final String? author;
  final String url;
  final String? urlToImage;
  final String? description;
  final String? content;
  final DateTime publishedAt;
  late final String? articleText;

  Article({
    required this.title,
    required this.source,
    required this.url,
    required this.publishedAt,
    this.author,
    this.urlToImage,
    this.description,
    this.content,
    this.articleText,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      source: json['source']['name'],
      url: json['url'],
      author: json['author'],
      urlToImage: json['urlToImage'],
      description: json['description'],
      content: json['content'],
      publishedAt: DateTime.parse(json['publishedAt']),
      articleText: json['articleText'],
    );
  }
}
