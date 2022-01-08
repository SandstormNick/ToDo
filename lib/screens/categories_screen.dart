import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          key: key,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                child: Text(
                  'Dummy Text 1',
                  key: key,
                ),
              ),
              Card(
                child: Text(
                  'Dummy Text 2',
                  key: key,
                ),
              ),
              Card(
                child: Text(
                  'Dummy Text 3',
                  key: key,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
