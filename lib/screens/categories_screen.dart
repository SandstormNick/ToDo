import 'package:flutter/material.dart';

import '../widgets/category_menu_card.dart';

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
              CategoryMenuCard(
                key: key,
                cardTitle: 'First dum text',
              ),
              CategoryMenuCard(
                key: key,
                cardTitle: '2nd dum text',
              ),
              CategoryMenuCard(
                key: key,
                cardTitle: '3rd dum text',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
