import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';

import './add_category_screen.dart';

import '../widgets/category_menu_card.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        future: ref.read(categoryProvider.notifier).fetchAndSetCategories(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer(
                child: const Center(
                  child: Text('Add your first ToDo Category'),
                ),
                builder: (context, ref, child) => ref
                        .watch(categoryProvider)
                        .isEmpty
                    ? child!
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i < ref.watch(categoryProvider).length;
                                  i++)
                                CategoryMenuCard(
                                    category: ref.watch(categoryProvider)[i]),
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
