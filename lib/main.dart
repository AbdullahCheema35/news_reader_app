import 'package:flutter/material.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/API/news_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MaterialApp(
    title: 'News Reader App',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: const HomeScreen(),
  ));
}

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
            SearchBar(),
            const SizedBox(height: 16.0),
            TopHeadlinesSection(),
            const SizedBox(height: 16.0),
            CategoriesSection(),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search for news articles...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Add your search logic here
      },
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<String> categories = ['Sports', 'Technology', 'Politics'];

  CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: categories.map((category) {
            return Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(category),
                selected: false,
                onSelected: (selected) {
                  // Add your category selection logic here
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PreferencesDrawer extends StatelessWidget {
  const PreferencesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Preferences'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language Preference'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguagePreferenceScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Country Preference'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CountryPreferenceScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TopHeadlinesSection extends StatefulWidget {
  const TopHeadlinesSection({super.key});

  @override
  _TopHeadlinesSectionState createState() => _TopHeadlinesSectionState();
}

class _TopHeadlinesSectionState extends State<TopHeadlinesSection> {
  late final List<Article> topHeadlines;
  late final NewsAPI newsAPI;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    newsAPI = NewsAPI();
    topHeadlines = await newsAPI.fetchTopHeadlines();
    // Start the automatic scrolling
    _startScrolling();
  }

  void _startScrolling() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        if (_pageController.page == topHeadlines.length - 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }
      _startScrolling();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Headlines',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 200.0,
          child: PageView.builder(
            controller: _pageController,
            itemCount: topHeadlines.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ArticleCard(article: topHeadlines[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.source),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {
            // Add your save article logic here
          },
        ),
      ),
    );
  }
}

class LanguagePreferenceScreen extends StatelessWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Preference'),
      ),
      body: const Center(
        child: Text('Select your preferred language'),
      ),
    );
  }
}

class CountryPreferenceScreen extends StatelessWidget {
  const CountryPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Preference'),
      ),
      body: const Center(
        child: Text('Select your preferred country'),
      ),
    );
  }
}
