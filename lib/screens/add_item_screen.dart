import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/item_provider.dart';

import '../models/category.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  static const routeName = 'add-item';

  const AddItemScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _itemNameController = TextEditingController();

  void _saveItem(int categoryId) {
    if (_itemNameController.text.isEmpty) {
      return;
    }

    ref.watch(itemProvider.notifier).addItem(
          _itemNameController.text,
          categoryId,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Item name'),
                      controller: _itemNameController,
                    )
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _saveItem(args.categoryId),
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
