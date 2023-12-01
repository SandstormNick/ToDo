import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';

import '../helpers/db_helper.dart';

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super([]);

  Future<void> addItem(String itemName, int categoryId) async {
    //Might need to rework this method a little bit
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);

    final newItem = Item(
      itemName: itemName,
      dateAdded: date,
      categoryIdfK: categoryId,
      itemOrder: _getNextAvailableItemOrder(),
    );

    //printItemsDebugMethod();

    final int insertedId = await DBHelper.insertReturnId('item', {
      'ItemName': newItem.itemName,
      'CategoryId_FK': newItem.categoryIdfK,
      'IsCompleted': 0,
      'IsDeleted': 0,
      'DateAdded': newItem.dateAdded.toString(),
      'ItemOrder': newItem.itemOrder,
    });

    newItem.itemId = insertedId;

    //Need to add the new Item to the appropriate place in the _items list
    state.insert(newItem.itemOrder - 1, newItem);
    state = [...state];
  }

  Future<void> fetchAndSetItems(int categoryId) async {
    final dataListPendingItems = await DBHelper.getDataWithId(
        'item',
        'CategoryId_FK = ? AND IsDeleted = 0 AND IsCompleted = 0',
        'ItemOrder',
        categoryId);

    List<Item> pendingItems = dataListPendingItems
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

    final dataListCompletedItems = await DBHelper.getDataWithId(
        'item',
        'CategoryId_FK = ? AND IsDeleted = 0 AND IsCompleted = 1',
        'ItemOrder DESC',
        categoryId);

    List<Item> completedItems = dataListCompletedItems
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

    state = [...pendingItems, ...completedItems];
  }

  //Function that is called when updating an item that is already marked complete
  //The selected item is updated along with the itemOrder of any other completed items that precede this one
  Future<void> updateIsCompletedFalseForItem(int? itemId) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsCompleted': 0,
        'ItemOrder': _getNextAvailableItemOrder(),
      },
    );

    List<Item> itemOrdersToUpdate = _getItemsCompletedToUpdateOrder(itemId!);

    for (var item in itemOrdersToUpdate) {
      DBHelper.updateWithId(
        'item',
        'ItemId = ?',
        item.itemId,
        {
          'ItemOrder': item.itemOrder - 1,
        },
      );
    }
  }

  //Function that is called when updating an item as completed
  //The selected item is updated along with the itemOrder of any other pending items that precede this one
  Future<void> updateIsCompletedTrueForItem(int? itemId) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsCompleted': 1,
        'ItemOrder': _getNextAvailableCompletedItemOrder(itemId!),
      },
    );

    List<Item> itemOrdersToUpdate = _getItemsPendingToUpdateOrder(itemId);

    for (var item in itemOrdersToUpdate) {
      DBHelper.updateWithId(
        'item',
        'ItemId = ?',
        item.itemId,
        {
          'ItemOrder': item.itemOrder - 1,
        },
      );
    }
  }

  Future<void> updateIsDeletedForItem(int? itemId) async {
    Item deletedItem = state.firstWhere((item) => item.itemId == itemId);

    if (deletedItem.isCompleted) {
      //Deleting a Completed item
      List<Item> itemOrdersToUpdate = _getItemsCompletedToUpdateOrder(itemId!);

      for (var item in itemOrdersToUpdate) {
        DBHelper.updateWithId(
          'item',
          'ItemId = ?',
          item.itemId,
          {
            'ItemOrder': item.itemOrder - 1,
          },
        );
      }
    } else {
      //Deleting a Pending item
      List<Item> itemOrdersToUpdate = _getItemsPendingToUpdateOrder(itemId!);

      for (var item in itemOrdersToUpdate) {
        DBHelper.updateWithId(
          'item',
          'ItemId = ?',
          item.itemId,
          {
            'ItemOrder': item.itemOrder - 1,
          },
        );
      }
    }

    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsDeleted': 1,
        'ItemOrder': -1,
      },
    );

    state = state.where((item) => item.itemId != itemId).toList();
  }

  //Function to find the next available ItemOrder where isCompleted is false
  int _getNextAvailableItemOrder() {
    List<int> itemOrders = state
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

  List<Item> _getItemsPendingToUpdateOrder(int itemId) {
    Item completedItem = state.firstWhere((item) => item.itemId == itemId);

    List<Item> itemsItemOrderToUpdate = state
        .where((item) =>
            !item.isCompleted && item.itemOrder > completedItem.itemOrder)
        .toList();

    return itemsItemOrderToUpdate;
  }

  List<Item> _getItemsCompletedToUpdateOrder(int itemId) {
    Item pendingItem = state.firstWhere((item) => item.itemId == itemId);

    List<Item> itemsItemOrderToUpdate = state
        .where((item) =>
            item.isCompleted && item.itemOrder > pendingItem.itemOrder)
        .toList();

    return itemsItemOrderToUpdate;
  }

  //Function to find the next available ItemOrder where isCompleted is true
  int _getNextAvailableCompletedItemOrder(int itemId) {
    List<int> itemOrders = state
        .where((item) => item.isCompleted)
        .map((item) => item.itemOrder)
        .toList();

    //If there are no items with IsCompleted set to true then return 1
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
    state.forEach((item) {
      //print("itemId: " + item.itemId.toString());
      print("itemId: " + item.itemId.toString());
      print("itemName: " + item.itemName);
      print("itemOrder: " + item.itemOrder.toString());
      //print(item.dateAdded);
    });
  }
}

final itemProvider = StateNotifierProvider<ItemNotifier, List<Item>>((ref) {
  return ItemNotifier();
});
