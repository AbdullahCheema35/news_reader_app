import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/UI/country_preferences_screen.dart';
import 'package:news_reader_app/UI/language_preferences_screen.dart';
import 'package:news_reader_app/models/preferences.dart';
import 'package:news_reader_app/UI/saved_articles_screen.dart';

class PreferencesDrawer extends ConsumerWidget {
  const PreferencesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language Preference'),
            onTap: () async {
              Navigator.pop(context);
              final language = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguagePreferenceScreen(),
                ),
              );
              if (language != null) {
                final preferencesProvider =
                    ref.read(preferencesControllerProvider.notifier);
                Preferences currentPreferences =
                    preferencesProvider.getPreferences();

                currentPreferences.language = language;
                preferencesProvider.updatePreferences(currentPreferences);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Country Preference'),
            onTap: () async {
              Navigator.pop(context);
              final selectedCountry = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountryPreferenceScreen(),
                ),
              );
              if (selectedCountry != null) {
                final preferencesProvider =
                    ref.read(preferencesControllerProvider.notifier);
                Preferences currentPreferences =
                    preferencesProvider.getPreferences();

                currentPreferences.country = selectedCountry;
                preferencesProvider.updatePreferences(currentPreferences);
              }
            },
          ),
          // List tile to clear preferences
          ListTile(
            leading: const Icon(Icons.clear),
            title: const Text('Clear Preferences'),
            onTap: () {
              final preferencesProvider =
                  ref.read(preferencesControllerProvider.notifier);
              preferencesProvider.updatePreferences(Preferences());
              // Close drawer
              Navigator.pop(context);
            },
          ),
          // List tile to show saved articles
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved Articles'),
            onTap: () {
              // Close drawer
              Navigator.pop(context);
              // Navigate to saved articles screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedArticlesPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
