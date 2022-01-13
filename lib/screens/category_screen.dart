import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

import '../providers/item_provider.dart';

import '../screens/add_item_screen.dart';

import '../widgets/item_name_card.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = 'category';
  //final int categoryId;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Category;
    print(args.categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category',
          key: key,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddItemScreen.routeName,
                  arguments: args);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ItemProvider>(context, listen: false)
            .fetchAndSetItems(args.categoryId),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<ItemProvider>(
                child: const Center(
                  child: Text('Add an item'),
                ),
                builder: (context, catItems, child) => catItems.items.isEmpty
                    ? child!
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              for (int i = 0; i < catItems.items.length; i++)
                                ItemNameCard(item: catItems.items[i])
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
