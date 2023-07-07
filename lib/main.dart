import 'package:flutter/material.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/StateManagement/top_headlines_controller.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';

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
            CategoriesSection(),
            const SizedBox(height: 16.0),
            TopHeadlinesSection(),
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

class CategoriesSection extends ConsumerWidget {
  final List<String> categories = ['Sports', 'Technology', 'Politics'];

  CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferencesControllerProvider);

    return state.when(
      data: (data) {
        // Use data
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
                    selected: data.categories.contains(category),
                    onSelected: (selected) {
                      // Category selected
                      if (selected) {
                        // Add category to preferences
                        data.categories.add(category);
                        ref
                            .read(preferencesControllerProvider.notifier)
                            .updatePreferences(data);
                      } else {
                        // Remove category from preferences
                        data.categories.remove(category);
                        ref
                            .read(preferencesControllerProvider.notifier)
                            .updatePreferences(data);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () {
        // Show loading indicator
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        // Show error message
        return Text('Error: $error');
      },
    );
  }
}

class PreferencesDrawer extends ConsumerWidget {
  const PreferencesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class TopHeadlinesSection extends ConsumerStatefulWidget {
  const TopHeadlinesSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TopHeadlinesSectionState();
}

class _TopHeadlinesSectionState extends ConsumerState<TopHeadlinesSection> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    // Start the automatic scrolling
    _startScrolling();
  }

  void _startScrolling() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        if (_pageController.page ==
            ref
                    .read(topHeadlinesControllerProvider.notifier)
                    .currentTopHeadlines
                    .length -
                1) {
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
    final preferencesState = ref.watch(preferencesControllerProvider);
    return preferencesState.when(
      data: (preferencesData) {
        // Use data
        final topHeadlinesState = ref.watch(topHeadlinesControllerProvider);
        return topHeadlinesState.when(
          data: (topHeadlinesData) {
            // Use data
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Headlines',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: topHeadlinesData.length,
                    itemBuilder: (context, index) {
                      final article = topHeadlinesData[index];
                      return ArticleCard(article: article);
                    },
                  ),
                ),
              ],
            );
          },
          loading: () {
            // Show loading indicator
            return const CircularProgressIndicator();
          },
          error: (error, stackTrace) {
            // Show error message
            return Text('Error: $error');
          },
        );
      },
      loading: () {
        // Show loading indicator
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        // Show error message
        return Text('Error: $error');
      },
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
