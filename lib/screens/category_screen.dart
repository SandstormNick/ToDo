import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

import '../providers/item_provider.dart';

import '../screens/add_item_screen.dart';

import '../widgets/item_name_card.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = 'category';
  //final int categoryId;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Category;
    print(args.categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.categoryName,
          //key: key,
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
                                ItemNameCard(
                                  item: catItems.items[i],
                                  notifiyParent: refresh,
                                ),
                                //Temp - Remove
                                TextButton(
                                  onPressed: () {
                                    ItemProvider ip = Provider.of<ItemProvider>(context, listen: false);
                                    ip.printItemsDebugMethod();
                                  },
                                  child: const Text('Print Items'),
                                ),
                                //Temp - Remove
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
