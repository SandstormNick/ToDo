import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = 'add-category';

  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _categoryNameController = TextEditingController();

  void _saveCategory() {
    if (_categoryNameController.text.isEmpty) {
      return;
    }
    Provider.of<CategoryProvider>(context, listen: false).addCategory(
      _categoryNameController.text,
    );
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
