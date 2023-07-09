import 'package:flutter/material.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/models/preferences.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Search bar with a button
    // return Row(
    //   children: [
    //     Expanded(
    //       child: TextField(
    //         decoration: const InputDecoration(
    //           prefixIcon: Icon(Icons.search),
    //           hintText: 'Search for news articles...',
    //           border: OutlineInputBorder(),
    //         ),
    //         onChanged: (value) {
    //           // Add your search logic here
    //         },
    //       ),
    //     ),
    //     const SizedBox(width: 8.0),
    //     ElevatedButton(
    //       onPressed: () {
    //         // Add your search logic here
    //       },
    //       child: const Text('Search'),
    //     ),
    //   ],
    // );
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search for news articles...',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        final preferencesProvider =
            ref.read(preferencesControllerProvider.notifier);
        Preferences currentPreferences = preferencesProvider.getPreferences();

        currentPreferences.query = value.isEmpty ? null : value;
        preferencesProvider.updatePreferences(currentPreferences);
      },
    );
  }
}
