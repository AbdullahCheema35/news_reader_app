class Preferences {
  String? country;
  String? language;
  List<String> categories;
  String? query;
  String? from;
  String? to;
  String? sortBy;
  int page;

  Preferences()
      : categories = [],
        page = 1;

  // Constructor to create preferences from Preferences object
  Preferences.fromPreferences(Preferences preferences)
      : country = preferences.country,
        language = preferences.language,
        categories = preferences.categories,
        query = preferences.query,
        from = preferences.from,
        to = preferences.to,
        sortBy = preferences.sortBy,
        page = preferences.page;

  // Constructor to create preferences from JSON
  Preferences.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        language = json['language'],
        categories = List.from(json['categories']),
        query = json['query'],
        from = json['from'],
        to = json['to'],
        sortBy = json['sortBy'],
        page = json['page'];

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'language': language,
      'categories': categories.toList(),
      'query': query,
      'from': from,
      'to': to,
      'sortBy': sortBy,
      'page': page,
    };
  }
}
