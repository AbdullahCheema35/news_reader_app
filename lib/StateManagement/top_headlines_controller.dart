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
  static final newsAPI = NewsAPI();
  Preferences? currentPreferences;

  @override
  FutureOr<List<Article>> build() async {
    currentPreferences ??= await ref.read(preferencesControllerProvider.future);

    if (!state.hasValue) {
      // Fetch topHeadlines news from API
      final topHeadlinesList =
          await newsAPI.fetchTopHeadlines(currentPreferences!);
      return topHeadlinesList;
    } else {
      return state.requireValue;
    }
  }

  FutureOr<void> updateTopHeadlines(Preferences preferences) async {
    currentPreferences = preferences;
    // Fetch topHeadlines news from API
    final topHeadlinesList =
        await newsAPI.fetchTopHeadlines(currentPreferences!);
    // Update topHeadlines news stored
    state = AsyncData(topHeadlinesList);
  }

  List<Article> get currentTopHeadlines {
    return state.requireValue;
  }
}
