import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/models/preferences.dart';
import 'package:news_reader_app/Persistence/preferences_persistence.dart';

final preferencesControllerProvider =
    AsyncNotifierProvider<PreferencesController, Preferences>(
        () => PreferencesController());

class PreferencesController extends AsyncNotifier<Preferences> {
  @override
  FutureOr<Preferences> build() async {
    // Fetch preferences from local storage (present in a json file)
    final preferencesFuture = preferencesPersistence.loadPreferences();
  }
}
