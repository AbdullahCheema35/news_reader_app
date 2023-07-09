import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:news_reader_app/models/article.dart';

class ArticlePersistence {
  static const String _fileName = 'articles.json';

  Future<List<Article>> loadArticles() async {
    try {
      final file = File(await _getFilePath());
      if (file.existsSync()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final decodedData = jsonDecode(contents) as List<dynamic>;
          return decodedData
              .map<Article>((json) => Article.fromJson(json))
              .toList();
        }
      } else {
        createFile();
      }
    } catch (e) {
      throw Exception('Error loading saved articles: $e');
    }
    return [];
  }

  Future<void> saveArticle(Article article) async {
    try {
      final file = File(await _getFilePath());
      final encodedData = jsonEncode(article);
      if (!file.existsSync()) {
        createFile();
      }
      // append to the json file
      await file.writeAsString(encodedData, mode: FileMode.append);
    } catch (e) {
      throw Exception('Error saving article: $e');
    }
  }

  Future<void> unSaveArticle(List<Article> articleList) async {
    try {
      final file = File(await _getFilePath());
      final encodedData = jsonEncode(articleList);
      if (!file.existsSync()) {
        return;
      }
      // store updated list of articles in json file (overwrite)
      await file.writeAsString(encodedData);
    } catch (e) {
      throw Exception('Error saving article: $e');
    }
  }

  void createFile() async {
    // Get the directory name where the file will be created
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$_fileName';

    // Create the file
    File file = File(filePath);
    file.createSync();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }
}
