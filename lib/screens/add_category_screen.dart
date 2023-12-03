import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  static const routeName = 'add-category';

  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _categoryNameController = TextEditingController();

  void _saveCategory() {
    if (_categoryNameController.text.isEmpty) {
      return;
    }

    ref
        .watch(categoryProvider.notifier)
        .addCategory(_categoryNameController.text);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                      decoration: const InputDecoration(
                        labelText: 'Category name',
                      ),
                      controller: _categoryNameController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _saveCategory,
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          )
        ],
      ),
    );
  }
}
