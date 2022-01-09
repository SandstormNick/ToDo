import 'package:flutter/material.dart';

import '../models/category.dart';

import '../helpers/db_helper.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  void addCategory(String catName) {
    final newCategory = Category(
      categoryName: catName,
    );

    _items.add(newCategory);
    notifyListeners();

    DBHelper.insert('category', {
      'CategoryName': newCategory.categoryName,
      'IsDeleted': 0,
    });

    // for (int i = 0; i < _items.length; i++) {
    //   print(_items[i].categoryName);
    //   print(_items[i].isDeleted);
    // }
  }

  Future<void> fetchAndSetCategories() async {
    final dataList = await DBHelper.getData('category');
    _items = dataList
        .map(
          (mapItem) => Category(
            categoryId: mapItem['CategoryId'],
            categoryName: mapItem['CategoryName'],
            isDeleted: mapItem['IsDeleted'],
          ),
        )
        .toList();

    notifyListeners();
  }
}
