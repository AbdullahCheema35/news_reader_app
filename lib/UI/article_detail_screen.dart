import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_reader_app/API/article_scrapper_api.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:news_reader_app/models/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

// class ArticleDetailScreen extends StatefulWidget {
//   final Article article;
//   final String title;
//   final String source;
//   final String? author;
//   final String url;
//   final String? urlToImage;
//   final String? description;
//   final String? content;
//   final DateTime publishedAt;

//   const ArticleDetailScreen({
//     Key? key,
//     required this.article,
//     required this.title,
//     required this.source,
//     required this.url,
//     required this.publishedAt,
//     this.author,
//     this.urlToImage,
//     this.description,
//     this.content,
//   }) : super(key: key);

//   factory ArticleDetailScreen.fromArticle(Article article) {
//     return ArticleDetailScreen(
//       article: article,
//       title: article.title,
//       source: article.source,
//       url: article.url,
//       publishedAt: article.publishedAt,
//       author: article.author,
//       urlToImage: article.urlToImage,
//       description: article.description,
//       content: article.content,
//     );
//   }

//   @override
//   State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
// }

// class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
//   String? articleText;
//   bool isLoading = true;
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     //fetchArticleText();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//             print(progress);
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             // if (request.url.startsWith('https://www.youtube.com/')) {
//             //   return NavigationDecision.prevent;
//             // }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Article Detail')),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final bool savedArticle;

  const ArticleDetailScreen({
    Key? key,
    required this.article,
    this.savedArticle = false,
  }) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  static final ArticleScrapperAPI articleScrapperAPI = ArticleScrapperAPI();
  late final String articleText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.savedArticle) {
      // Article is saved, so we already have the article text.
      articleText = widget.article.articleText!;
      isLoading = false;
    } else {
      // We have to fetch the article text from the API.
      articleScrapperAPI.fetchArticleText(widget.article.url).then((value) {
        // check if the widget is mounted
        if (!mounted) return;
        setState(() {
          articleText = value;
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String articleTitle = widget.article.title;
    // String articleImage = widget.article.urlToImage!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            articleTitle,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(height: 16.0),
          // Image.network(
          //   articleImage,
          //   height: 200.0,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          const SizedBox(height: 16.0),
          if (isLoading)
            const CircularProgressIndicator()
          else
            Text(
              articleText,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
        ],
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           if (widget.urlToImage != null)
    //             Image.network(
    //               widget.urlToImage!,
    //               height: 200,
    //               fit: BoxFit.cover,
    //             ),
    //           const SizedBox(height: 16.0),
    //           Text(
    //             'Source: ${widget.source}',
    //             style:
    //                 const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //           ),
    //           if (widget.author != null) Text('Author: ${widget.author}'),
    //           Text('Published at: ${widget.publishedAt.toString()}'),
    //           if (widget.description != null)
    //             Text('Description: ${widget.description}'),
    //           if (widget.content != null) Text('Content: ${widget.content}'),
    //           const SizedBox(height: 16.0),
    //           if (isLoading)
    //             const CircularProgressIndicator()
    //           else if (articleText != null)
    //             Html(data: articleText!)
    //           else
    //             const Text('Failed to load article content.'),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
