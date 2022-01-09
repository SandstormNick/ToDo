import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

import './add_category_screen.dart';

import '../widgets/category_menu_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          key: key,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<CategoryProvider>(context, listen: false)
            .fetchAndSetCategories(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<CategoryProvider>(
                    child: const Center(
                      child: Text('Add your first ToDo Category'),
                    ),
                    builder: (context, categories, child) =>
                        categories.items.isEmpty
                            ? child!
                            : SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    children: [
                                      for (var i = 0;
                                          i < categories.items.length;
                                          i++)
                                        CategoryMenuCard(
                                          category: categories.items[i],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                  ),
      ),
    );
  }
}
