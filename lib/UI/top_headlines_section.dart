import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/StateManagement/top_headlines_controller.dart';
import 'package:news_reader_app/UI/article_card.dart';

class TopHeadlinesSection extends ConsumerStatefulWidget {
  const TopHeadlinesSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TopHeadlinesSectionState();
}

class _TopHeadlinesSectionState extends ConsumerState<TopHeadlinesSection> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  late int totalClients;

  @override
  void initState() {
    super.initState();
    // Start the automatic scrolling
    _startScrolling();
  }

  void _startScrolling() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_pageController.hasClients) {
        if (_pageController.page == totalClients - 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
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
            totalClients = topHeadlinesData.length;
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
