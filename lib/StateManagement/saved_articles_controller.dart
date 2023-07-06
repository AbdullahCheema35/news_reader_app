import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/Persistence/article_persistence.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

final savedArticlesControllerProvider =
    AsyncNotifierProvider<SavedArticlesController, List<Article>>(
        () => SavedArticlesController());

class SavedArticlesController extends AsyncNotifier<List<Article>> {
  @override
  FutureOr<List<Article>> build() async {
    final ArticlePersistence articlePersistence = ArticlePersistence();

    // Fetch savedArticles news from Persistence handler
    final savedArticlesList = await articlePersistence.loadArticles();

    return savedArticlesList;
  }

  void saveArticle(Article article) async {
    final articleList = await future;
    state = const AsyncLoading();
    final ArticlePersistence articlePersistence = ArticlePersistence();
    await articlePersistence.saveArticle(article);
    state = AsyncData(articleList..add(article));
  }

  void unSaveArticle(Article article) async {
    final articleList = await future;
    state = const AsyncLoading();
    final ArticlePersistence articlePersistence = ArticlePersistence();
    final updatedList = articleList..remove(article);
    await articlePersistence.unSaveArticle(updatedList);
    state = AsyncData(updatedList);
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
