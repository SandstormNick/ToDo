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
      itemOrder: _getNextItemOrder(),
    );

    _items.add(newItem);
    notifyListeners();

    printItemsDebugMethod();

    final int insertedId = await DBHelper.insertReturnId('item', {
      'ItemName': newItem.itemName,
      'CategoryId_FK': newItem.categoryIdfK,
      'IsCompleted': 0,
      'IsDeleted': 0,
      'DateAdded': newItem.dateAdded.toString(),
      'ItemOrder': newItem.itemOrder,
    });

    items.last.itemId = insertedId;
  }

  Future<void> fetchAndSetItems(int categoryId) async {
    final dataList = await DBHelper.getDataWithId('item',
        'CategoryId_FK = ? AND IsDeleted = 0', 'IsCompleted', categoryId);
    _items = dataList
        .map(
          (mapItem) => Item(
            itemId: mapItem['ItemId'],
            itemName: mapItem['ItemName'],
            isCompleted: mapItem['IsCompleted'] == 0 ? false : true,
            isDeleted: mapItem['IsDeleted'] == 0 ? false : true,
            dateAdded: DateTime.parse(mapItem['DateAdded']),
            categoryIdfK: mapItem['CategoryId_FK'],
            itemOrder: mapItem['ItemOrder'],
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

  Future<void> updateIsDeletedForItem(int? itemId) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsDeleted': 1,
      },
    );
    int index = _items.indexWhere((item) => item.itemId == itemId);
    _items.removeAt(index);

    notifyListeners();
  }

  //Function to find the next available ItemOrder where isCompleted is false
  int _getNextItemOrder() {
    List<int> itemOrders = _items
        .where((item) => !item.isCompleted)
        .map((item) => item.itemOrder)
        .toList();

    //If there are no items with IsCompleted set to false then return 1
    if (itemOrders.isEmpty) {
      return 1;
    }

    //Otherwise return the maximum itemOrder + 1
    return itemOrders.reduce((max, order) => order > max ? order : max) + 1;
  }

  //A method that can be used in debugging
  void printItemsDebugMethod() {
    //print _items
    print('Printing records from item Table');
    _items.forEach((item) {
      //print("itemId: " + item.itemId.toString());
      print("itemName: " + item.itemName);
      print("itemOrder: " + item.itemOrder.toString());
      //print(item.dateAdded);
    });
  }
}
