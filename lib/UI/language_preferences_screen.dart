import 'package:flutter/material.dart';

class LanguagePreferenceScreen extends StatelessWidget {
  const LanguagePreferenceScreen({super.key});

  final Map<String, String> languageMap = const {
    'ar': 'Arabic',
    'de': 'German',
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'he': 'Hebrew',
    'it': 'Italian',
    'nl': 'Dutch',
    'no': 'Norwegian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'sv': 'Swedish',
    'ud': 'Udmurt',
    'zh': 'Chinese',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Preference'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select your preferred language',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languageMap.length,
              itemBuilder: (context, index) {
                final languageCode = languageMap.keys.elementAt(index);
                final languageName = languageMap.values.elementAt(index);

                return ListTile(
                  title: Text(languageName),
                  onTap: () {
                    Navigator.pop(context, languageCode);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
