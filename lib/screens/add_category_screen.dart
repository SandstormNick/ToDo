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
  final _formKey = GlobalKey<FormState>();

  final _categoryNameController = TextEditingController();

  String? _validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text.';
    }
    return null;
  }

  void _saveCategory() {

    if (_formKey.currentState!.validate()) {
      ref
        .watch(categoryProvider.notifier)
        .addCategory(_categoryNameController.text);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Category'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _categoryNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Category name',
                        ),
                        validator: _validateCategoryName,
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
      ),
    );
  }
}
