import 'package:flutter/material.dart';
import 'package:news_reader_app/UI/categories_section.dart';
import 'package:news_reader_app/UI/everything_section.dart';
import 'package:news_reader_app/UI/preferences_drawer.dart';
import 'package:news_reader_app/UI/search_bar.dart';
import 'package:news_reader_app/UI/top_headlines_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('News Reader App'),
          ],
        ),
      ),
      drawer: const PreferencesDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SearchBar(),
            const SizedBox(height: 16.0),
            CategoriesSection(),
            const SizedBox(height: 16.0),
            const TopHeadlinesSection(),
            const SizedBox(height: 16.0),
            // Create scrollable list of articles
            const EverythingSection(),
          ],
        ),
      ),
    );
  }
}
