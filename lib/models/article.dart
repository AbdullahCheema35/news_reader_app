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
  String? articleText;
  bool saved;

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
    this.saved = false,
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
      saved: json['saved'] ?? false,
    );
  }
  // Convert Article object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'source': {'name': source},
      'url': url,
      'author': author,
      'urlToImage': urlToImage,
      'description': description,
      'content': content,
      'publishedAt': publishedAt.toIso8601String(),
      'articleText': articleText,
      'saved': saved,
    };
  }
}
