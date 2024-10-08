import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/screens/add_note_screen.dart';
import 'package:todo_list/screens/note_category_screen.dart';

import 'screens/categories_screen.dart';
import 'screens/add_category_screen.dart';
import 'screens/category_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/note_item_screen.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 26, 100, 28),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
        ),
        colorScheme: kColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: const ButtonStyle().copyWith(
            backgroundColor: WidgetStatePropertyAll(kDarkColorScheme.primaryContainer),
            foregroundColor: WidgetStatePropertyAll(kDarkColorScheme.onPrimaryContainer),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        ),
        colorScheme: kDarkColorScheme,
        cardTheme: CardTheme(
          color: kDarkColorScheme.onPrimaryContainer,
          elevation: 2.0
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: const ButtonStyle().copyWith(
            backgroundColor: WidgetStatePropertyAll(kDarkColorScheme.primaryContainer),
            foregroundColor: WidgetStatePropertyAll(kDarkColorScheme.onPrimaryContainer),
          ),
        ),
      ),
      home: CategoriesScreen(
        key: key,
      ),
      routes: {
        AddCategoryScreen.routeName: (ctx) => const AddCategoryScreen(),
        CategoryScreen.routeName: (ctx) => const CategoryScreen(),
        AddItemScreen.routeName: (ctx) => const AddItemScreen(),
        NoteItemScreen.routeName: (ctx) => const NoteItemScreen(),
        NoteCategoryScreen.routeName: (ctx) => const NoteCategoryScreen(),
        AddNoteScreen.routeAddItemNote: (ctx) => const AddNoteScreen(isItem: true,),
        AddNoteScreen.routeAddCategoryNote: (ctx) => const AddNoteScreen(isItem: false,),
      },
    );
  }
}
