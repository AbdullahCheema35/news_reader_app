import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/API/news_api.dart';
import 'package:news_reader_app/StateManagement/preferences_controller.dart';
import 'package:news_reader_app/models/article.dart';
import 'package:news_reader_app/models/preferences.dart';

final everythingControllerProvider =
    AsyncNotifierProvider<EverythingController, List<Article>>(
        () => EverythingController());

class EverythingController extends AsyncNotifier<List<Article>> {
  static final newsAPI = NewsAPI();
  Preferences? currentPreferences;

  @override
  FutureOr<List<Article>> build() async {
    currentPreferences ??= await ref.read(preferencesControllerProvider.future);

    if (!state.hasValue) {
      // Fetch everything news from API
      final everythingList = await newsAPI.fetchEverything(currentPreferences!);
      return everythingList;
    } else {
      return state.requireValue;
    }
  }

  List<Article> get currentEverything {
    return state.requireValue;
  }

  FutureOr<void> updateEverything(Preferences preferences) async {
    currentPreferences = preferences;
    // Fetch everything news from API
    final everythingList = await newsAPI.fetchEverything(currentPreferences!);
    // Update everything news stored
    state = AsyncData(everythingList);
  }
}
