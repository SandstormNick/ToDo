import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';

import '../helpers/db_helper.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  Future<void> addCategory(String catName) async {
    final newCategory = Category(
      categoryId: 0, //temp value
      categoryName: catName,
    );

    state = [...state, newCategory];

    final int insertedId = await DBHelper.insertReturnId('category', {
      'CategoryName': newCategory.categoryName,
      'IsDeleted': 0,
    });

    state.last.categoryId = insertedId;
  }

  Future<void> fetchAndSetCategories() async {
    final dataList =
        await DBHelper.getDataNotDeleted('category', 'IsDeleted = 0');
    state = dataList
        .map(
          (mapItem) => Category(
            categoryId: mapItem['CategoryId'],
            categoryName: mapItem['CategoryName'],
            isDeleted: mapItem['IsDeleted'] == 0 ? false : true,
          ),
        )
        .toList();
  }

  Future<void> updateIsDeletedForCategory(int? categoryId) async {
    DBHelper.updateWithId(
      'category',
      'CategoryId = ?',
      categoryId,
      {
        'IsDeleted': 1,
      },
    );

    state = state.where((cat) => cat.categoryId != categoryId).toList();
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});
