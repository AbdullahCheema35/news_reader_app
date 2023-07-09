import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';

class CategoriesSection extends ConsumerWidget {
  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];
  CategoriesSection({super.key});
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefState = ref.watch(preferencesControllerProvider);

    return prefState.when(
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
            SizedBox(
              height: 40.0, // Set a specific height to limit vertical space
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: ToggleButtons(
                      isSelected: categories
                          .map((category) => _selectedCategory == category)
                          .toList(),
                      onPressed: (index) {
                        final currentlySelectedCategory = categories[index];
                        _selectedCategory =
                            currentlySelectedCategory == _selectedCategory
                                ? ''
                                : currentlySelectedCategory;

                        data.categories.clear();
                        if (_selectedCategory.isNotEmpty) {
                          data.categories.add(_selectedCategory);
                        }

                        ref
                            .read(preferencesControllerProvider.notifier)
                            .updatePreferences(data);
                      },
                      color: Colors.grey,
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                      children: categories
                          .map((category) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(category),
                              ))
                          .toList(),
                    ),
                  );
                }).toList(),
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
  }
}
