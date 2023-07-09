import 'dart:convert';
import 'dart:io';
import 'package:news_reader_app/models/preferences.dart';
import 'package:path_provider/path_provider.dart';

class PreferencesPersistence {
  static const String _fileName = 'preferences.json';

  Future<Preferences> loadPreferences() async {
    try {
      final file = File(await _getFilePath());
      if (file.existsSync()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final decodedData = jsonDecode(contents);
          return Preferences.fromJson(decodedData);
        }
      } else {
        createFile();
      }
    } catch (e) {
      throw Exception('Error loading saved preferences: $e');
    }
    return Preferences();
  }

  Future<void> savePreferences(Preferences preferences) async {
    try {
      final file = File(await _getFilePath());
      final encodedData = jsonEncode(preferences.toJson());
      if (!file.existsSync()) {
        createFile();
      }
      await file.writeAsString(encodedData);
    } catch (e) {
      throw Exception('Error saving Preference: $e');
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
