import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_provider.dart';

import '../models/category.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = 'add-item';

  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _itemNameController = TextEditingController();

  void _saveItem(int categoryId) {
    if (_itemNameController.text.isEmpty) {
      return;
    }
    print(categoryId);
    Provider.of<ItemProvider>(context, listen: false).addItem(
      _itemNameController.text,
      categoryId, //pass through categoryid
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
