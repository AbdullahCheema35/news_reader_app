import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/UI/article_detail_screen.dart';
import 'package:news_reader_app/StateManagement/saved_articles_controller.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool saved;
  static final ref = ProviderContainer();

  const ArticleCard({super.key, required this.article, this.saved = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.source),
        trailing: IconButton(
          icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () async {
            // Add your save article logic here
            if (saved) {
              // Remove article from saved articles
              await ref
                  .read(savedArticlesControllerProvider.notifier)
                  .unSaveArticle(article);
            } else {
              // Save article
              await ref
                  .read(savedArticlesControllerProvider.notifier)
                  .saveArticle(article);
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ArticleDetailScreen(article: article, savedArticle: saved),
            ),
          );
        },
      ),
    );
  }
}
