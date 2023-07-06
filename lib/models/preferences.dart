class Preferences {
  String? country;
  String? language;
  String? category;
  String? query;
  String? from;
  String? to;
  String? sortBy;

  Preferences({
    this.country,
    this.language,
    this.category,
    this.query,
    this.from,
    this.to,
    this.sortBy,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      country: json['country'],
      language: json['language'],
      category: json['category'],
      query: json['query'],
      from: json['from'],
      to: json['to'],
      sortBy: json['sortBy'],
    );
  }
}
