class Article {
  final String title;
  final String source;
  final String? author;
  final String url;
  final String? urlToImage;
  final String? description;
  final String? content;
  final DateTime publishedAt;
  late final String articleText;

  Article({
    required this.title,
    required this.source,
    this.author,
    required this.url,
    this.urlToImage,
    this.description,
    this.content,
    required this.publishedAt,
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
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'source': {'name': source},
  //     'url': url,
  //     'author': author,
  //     'urlToImage': urlToImage,
  //     'description': description,
  //     'content': content,
  //     'publishedAt': publishedAt.toIso8601String(),
  //   };
  // }
}
