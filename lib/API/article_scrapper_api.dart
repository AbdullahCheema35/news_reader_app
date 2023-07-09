import 'dart:convert';
import 'package:http/http.dart' as http;

class ArticleScrapperAPI {
  final baseUrl = 'https://api.diffbot.com/v3/article';
  final apiKey = 'd1e146a3137180e162b16bf1d89a25d6';

  Future<String> fetchArticleText(String providedUrl) async {
    final url = providedUrl;

    final encodedApiKey = Uri.encodeComponent(apiKey);
    final encodedUrl = Uri.encodeComponent(url);

    final response = await http
        .get(Uri.parse('$baseUrl?token=$encodedApiKey&url=$encodedUrl'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // print(responseData['objects'][0]['text']);
      // if responseData['objects'] exists and is not null

      if (responseData['objects'] != null) {
        return responseData['objects'][0]['text'] as String;
      } else {
        throw Exception('Failed to fetch article: ${responseData['error']}');
      }
    } else {
      throw Exception('Failed to fetch article: ${response.statusCode}');
    }
  }
}
