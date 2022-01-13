import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_arguments.dart';

import '../providers/item_provider.dart';

import '../screens/add_item_screen.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = 'category';
  //final int categoryId;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryArguments;
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
                  arguments: CategoryArguments(args.categoryId));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ItemProvider>(context, listen: false)
            .fetchAndSetItems(),
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
                            children: const [
                              Card(
                                child: Text('Item 1'),
                              ),
                              Card(
                                child: Text('Item 2'),
                              ),
                              Card(
                                child: Text('Item 3'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
      ),
      // Text(
      //   args.categoryId.toString(),
      //   style: const TextStyle(
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
    );
  }
}
