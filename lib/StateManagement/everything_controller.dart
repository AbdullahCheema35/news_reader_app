import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/API/news_api.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

final everythingControllerProvider =
    AsyncNotifierProvider<EverythingController, List<Article>>(
        () => EverythingController());

class EverythingController extends AsyncNotifier<List<Article>> {
  @override
  FutureOr<List<Article>> build() async {
    final NewsAPI newsAPI = NewsAPI();

    final Preferences preferences =
        await ref.read(preferencesControllerProvider.future);

    // Fetch everything news from API
    final everythingList = await newsAPI.fetchEverything(preferences);

    return everythingList;
  }

  List<Article> getArticles() {
    return state.asData?.value ?? [];
  }

  Article getArticle(int index) {
    final article = state.asData?.value[index];
    if (article != null) {
      return article;
    } else {
      throw Exception('Article not found');
    }
  }
}
