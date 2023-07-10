import 'package:flutter/material.dart' show MaterialApp, ThemeData, runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:news_reader_app/UI/home_screen.dart' show HomeScreen;

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'News Reader App',
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      ),
    ),
  );
}
