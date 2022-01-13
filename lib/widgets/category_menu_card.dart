import 'package:flutter/material.dart';

import '../models/category.dart';

import '../screens/category_screen.dart';

class CategoryMenuCard extends StatelessWidget {
  final Category category;

  const CategoryMenuCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: InkWell(
          splashColor: Colors.green,
          onTap: () {
            Navigator.pushNamed(
              context,
              CategoryScreen.routeName,
              arguments: category,
            );
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(category.categoryName),
              )
            ],
          ),
        ),
      ),
    );
  }
}
