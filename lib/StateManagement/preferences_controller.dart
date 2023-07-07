import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/StateManagement/everything_controller.dart';
import 'package:news_reader_app/StateManagement/top_headlines_controller.dart';
import 'package:news_reader_app/models/preferences.dart';
import 'package:news_reader_app/Persistence/preferences_persistence.dart';

final preferencesControllerProvider =
    AsyncNotifierProvider<PreferencesController, Preferences>(
        () => PreferencesController());

class PreferencesController extends AsyncNotifier<Preferences> {
  final preferencesPersistenceObject = PreferencesPersistence();

  @override
  FutureOr<Preferences> build() async {
    print('Preferences Controller Build Method is called');
    print('State: $state');

    if (!state.hasValue) {
      // Fetch preferences from local storage (present in a json file)
      final preferences = await fetchPreferences();
      return preferences;
    } else {
      return state.requireValue;
    }
  }

  Future<Preferences> fetchPreferences() async {
    try {
      final preferences = await preferencesPersistenceObject.loadPreferences();
      return preferences;
    } catch (error, stackTrace) {
      throw Exception('Error loading saved preferences: $error, $stackTrace');
    }
  }

  Preferences getPreferences() {
    // return preferences stored
    return state.requireValue;
  }

  Future<void> savePreferences(Preferences preferences) async {
    // Save preferences to local storage (present in a json file)
    preferencesPersistenceObject.savePreferences(preferences);
  }

  void updatePreferences(Preferences preferences) {
    // Update preferences stored
    state = const AsyncLoading();
    savePreferences(preferences);
    ref
        .read(topHeadlinesControllerProvider.notifier)
        .updateTopHeadlines(preferences);
    ref
        .read(everythingControllerProvider.notifier)
        .updateEverything(preferences);
    state = AsyncData(preferences);
  }
}
