import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';

import '../widgets/alert_dialog.dart';

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

  Future<bool> _showAlertDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => const CustomAlertDialog(alertType: 'Category'),
    );
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      var newCategoryName = _categoryNameController.text;

      if (ref
          .watch(categoryProvider.notifier)
          .checkIfCategoryExists(newCategoryName)) {
        bool addAnyway = await _showAlertDialog();
        if (addAnyway) {
          ref.watch(categoryProvider.notifier).addCategory(newCategoryName);

          Navigator.of(context).pop();
        }
      } else {
        ref.watch(categoryProvider.notifier).addCategory(newCategoryName);

        Navigator.of(context).pop();
      }
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
                        textCapitalization: TextCapitalization.sentences,
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
