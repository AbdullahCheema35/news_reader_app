import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/UI/article_card.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/StateManagement/everything_controller.dart';

class EverythingSection extends ConsumerWidget {
  const EverythingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(everythingControllerProvider).when(
          data: (articles) => _returnArticlesList(articles),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        );
  }

  Widget _returnArticlesList(List<Article> articles) {
    if (articles.isEmpty) {
      return const Center(
        child: Text(
          'Enter a search term to find articles',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ArticleCard(article: articles[index]);
        },
      );
    }
  }
}
