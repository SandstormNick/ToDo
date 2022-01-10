import 'package:flutter/material.dart';

import '../models/category_arguments.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = 'category';
  //final int categoryId;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category',
          key: key,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Text(
        args.categoryId.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
