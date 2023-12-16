import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';

import '../providers/item_provider.dart';

import '../screens/add_item_screen.dart';

import '../widgets/item_name_card.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  static const routeName = 'category';
  //final int categoryId;

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Category;

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
        future:
            ref.read(itemProvider.notifier).fetchAndSetItems(args.categoryId),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer(
                    child: const Center(
                      child: Text('Add an item'),
                    ),
                    builder: (context, ref, child) =>
                        ref.watch(itemProvider).isEmpty
                            ? child!
                            : SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i < ref.watch(itemProvider).length;
                                          i++)
                                        ItemNameCard(
                                          item: ref.watch(itemProvider)[i],
                                          notifiyParent: refresh,
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
