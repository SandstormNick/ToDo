import 'package:flutter/material.dart';

import '../models/item.dart';

import '../helpers/db_helper.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  Future<void> addItem(String itemName, int categoryId) async {
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);

    final newItem = Item(
      itemName: itemName,
      dateAdded: date,
      categoryIdfK: categoryId,
    );

    _items.add(newItem);
    notifyListeners();

    final int insertedId = await DBHelper.insertReturnId('item', {
      'ItemName': newItem.itemName,
      'CategoryId_FK': newItem.categoryIdfK,
      'IsCompleted': 0,
      'IsDeleted': 0,
      'DateAdded': newItem.dateAdded.toString(),
    });

    items.last.itemId = insertedId;
  }

  Future<void> fetchAndSetItems(int categoryId) async {
    final dataList = await DBHelper.getDataWithId(
        'item', 'CategoryId_FK = ?', 'IsCompleted', categoryId);
    _items = dataList
        .map(
          (mapItem) => Item(
            itemId: mapItem['ItemId'],
            itemName: mapItem['ItemName'],
            isCompleted: mapItem['IsCompleted'] == 0 ? false : true,
            isDeleted: mapItem['IsDeleted'] == 0 ? false : true,
            dateAdded: DateTime.parse(mapItem['DateAdded']),
            categoryIdfK: mapItem['CategoryId_FK'],
          ),
        )
        .toList();
  }

  Future<void> updateIsCompletedForItem(int? itemId, bool isCompleted) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsCompleted': isCompleted ? 1 : 0,
      },
    );
  }
}
