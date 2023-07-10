import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/UI/article_card.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/StateManagement/saved_articles_controller.dart';

class SavedArticlesPage extends ConsumerWidget {
  const SavedArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
      ),
      body: ref.watch(savedArticlesControllerProvider).when(
            data: (savedArticles) {
              return _returnSavedArticlesList(savedArticles);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          ),
    );
  }
}

Widget _returnSavedArticlesList(List<Article> savedArticles) {
  if (savedArticles.isEmpty) {
    return const Center(
      child: Text('No saved articles'),
    );
  } else {
    return ListView.builder(
      itemCount: savedArticles.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: savedArticles[index]);
      },
    );
  }
}
