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
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();

  String? _validateItemName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text.';
    }
    return null;
  }

  void _saveItem(int categoryId) {
    if (_formKey.currentState!.validate()) {
      ref.watch(itemProvider.notifier).addItem(
          _itemNameController.text,
          categoryId,
        );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Category;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
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
                        controller: _itemNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Item name',
                        ),
                        validator: _validateItemName,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _saveItem(args.categoryId),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            )
          ],
        ),
      ),
    );
  }
}
