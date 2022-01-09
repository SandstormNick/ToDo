import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryMenuCard extends StatelessWidget {
  //final String cardTitle;
  final Category category;

  const CategoryMenuCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: InkWell(
          splashColor: Colors.green,
          onTap: () {
            print(category.categoryId);
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
