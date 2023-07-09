import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/API/article_scrapper_api.dart';
import 'package:news_reader_app/Persistence/article_persistence.dart';
import 'package:news_reader_app/models/article.dart';

final savedArticlesControllerProvider =
    AsyncNotifierProvider<SavedArticlesController, List<Article>>(
        () => SavedArticlesController());

class SavedArticlesController extends AsyncNotifier<List<Article>> {
  static final ArticlePersistence articlePersistence = ArticlePersistence();
  static final ArticleScrapperAPI articleScrapperAPI = ArticleScrapperAPI();
  @override
  FutureOr<List<Article>> build() async {
    if (!state.hasValue) {
      // Fetch savedArticles news from Persistence handler
      final savedArticlesList = await articlePersistence.loadArticles();
      return savedArticlesList;
    } else {
      return state.requireValue;
    }
  }

  FutureOr<void> saveArticle(Article article) async {
    final articleList = await future;
    state = const AsyncLoading();
    if (article.articleText == null) {
      final articleText =
          await articleScrapperAPI.fetchArticleText(article.url);
      article.articleText = articleText;
    }
    await articlePersistence.saveArticle(article);
    state = AsyncData(articleList..add(article));
  }

  FutureOr<void> unSaveArticle(Article article) async {
    final articleList = await future;
    state = const AsyncLoading();
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

  List<Article> get currentSavedArticles {
    return state.requireValue;
  }
}
