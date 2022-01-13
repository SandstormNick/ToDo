import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/categories_screen.dart';
import 'screens/add_category_screen.dart';
import 'screens/category_screen.dart';
import 'screens/add_item_screen.dart';

import 'providers/category_provider.dart';
import 'providers/item_provider.dart';

void main() {
  //runApp(const MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => ItemProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
