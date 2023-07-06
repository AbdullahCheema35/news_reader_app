import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/API/news_api.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

final topHeadlinesControllerProvider =
    AsyncNotifierProvider<TopHeadlinesController, List<Article>>(
        () => TopHeadlinesController());

class TopHeadlinesController extends AsyncNotifier<List<Article>> {
  @override
  FutureOr<List<Article>> build() async {
    final NewsAPI newsAPI = NewsAPI();

    final Preferences preferences =
        await ref.read(preferencesControllerProvider.future);

    // Fetch topHeadlines news from API
    final topHeadlinesList = await newsAPI.fetchTopHeadlines(preferences);

    return topHeadlinesList;
  }
}
