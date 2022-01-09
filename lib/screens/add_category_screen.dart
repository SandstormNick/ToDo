import 'package:flutter/material.dart';

class AddCategoryScreen extends StatelessWidget {
  static const routeName = 'add-category';

  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
    );
  }
}
