import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/categories_screen.dart';
import 'screens/add_category_screen.dart';
import 'screens/category_screen.dart';
import 'screens/add_item_screen.dart';

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
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.onPrimaryContainer,
          foregroundColor: kDarkColorScheme.primaryContainer,
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer),
      ),
      home: CategoriesScreen(
        key: key,
      ),
      routes: {
        AddCategoryScreen.routeName: (ctx) => const AddCategoryScreen(),
        CategoryScreen.routeName: (ctx) => const CategoryScreen(),
        AddItemScreen.routeName: (ctx) => const AddItemScreen(),
      },
    );
  }
}
