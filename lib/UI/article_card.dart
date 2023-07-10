import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/UI/article_detail_screen.dart';
import 'package:news_reader_app/StateManagement/saved_articles_controller.dart';

class ArticleCard extends ConsumerWidget {
  final Article article;

  ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.source),
        trailing: IconButton(
          icon: Icon(article.saved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () async {
            // Add your save article logic here
            if (article.saved) {
              // Remove article from saved articles
              article.saved = false;
              ref
                  .watch(savedArticlesControllerProvider.notifier)
                  .unSaveArticle(article);
              // print('Article removed from saved articles');
            } else {
              // Save article
              article.saved = true;
              ref
                  .watch(savedArticlesControllerProvider.notifier)
                  .saveArticle(article);
              // print('Article saved');
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
      ),
    );
  }
}
