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
      'IsPinned': 0
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
            isPinned: mapItem['IsPinned'] == 0 ? false : true,
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
            isPinned: mapItem['IsPinned'] == 0 ? false : true,
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
  //Also set IsPinned to false
  Future<void> updateIsCompletedTrueForItem(int? itemId) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsCompleted': 1,
        'IsPinned': 0,
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

  //Function that is called when tapping the pinned icon for an Item
  //It updates the isPinned property
  //It updates the ItemOrder for the necessary items
  Future<void> updateIsPinnedForItem(int? itemId, bool isPinned) async {
    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      itemId,
      {
        'IsPinned': isPinned ? 1 : 0,
      },
    );

    //Need to add the order change here - like how it works for is completed

    //First update the order of the unpinned items
    List<Item> itemOrdersToUpdate = _getItemsToUpdateAfterPinning(itemId!);

    for (var item in itemOrdersToUpdate) {
      DBHelper.updateWithId(
        'item',
        'ItemId = ?',
        item.itemId,
        {
          'ItemOrder': item.itemOrder + 1,
        },
      );
    }

    //Update the ItemOrder of the Pinned Item
    _updatePinnedItemOrder(itemId);
  }

  bool checkIfItemExists(String newItemName) {
    return state.any(
        (item) => item.itemName.toUpperCase() == newItemName.toUpperCase());
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

  List<Item> _getItemsToUpdateAfterPinning(int itemId) {
    Item pinnedItem = state.firstWhere((item) => item.itemId == itemId);

    List<Item> itemsItemOrderToUpdate = state
        .where((item) =>
            !item.isCompleted &&
            !item.isPinned &&
            item.itemOrder < pinnedItem.itemOrder)
        .toList();

    return itemsItemOrderToUpdate;
  }

  void _updatePinnedItemOrder(int itemId) {
    Item tappedItem = state.firstWhere((item) => item.itemId == itemId);

    List<Item> pinnedItems = state.where((item) => item.isPinned).toList();

    if (tappedItem.isPinned) {
      _updatePinnedItemOrderIfIsPinnedIsTrue(pinnedItems, tappedItem);
    } else {
      __updatePinnedItemOrderIfIsPinnedIsFalse(pinnedItems, tappedItem);
    }
  }

  //Function updates the ItemOrder when you set an Item isPinned to TRUE
  void _updatePinnedItemOrderIfIsPinnedIsTrue(
      List<Item> pinnedItems, Item tappedItem) {
    //isPinned is already set for this item so we check to see if there are at least 2 pinned items before going into the if block
    if (pinnedItems.length > 1) {
      tappedItem.itemOrder = pinnedItems.length;
    } else {
      //there are no pinned items
      tappedItem.itemOrder = 1;
    }

    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      tappedItem.itemId,
      {
        'ItemOrder': tappedItem.itemOrder,
      },
    );
  }

  //Function updates the ItemOrder when you set an Item isPinned to FALSE
  void __updatePinnedItemOrderIfIsPinnedIsFalse(
      List<Item> pinnedItems, Item tappedItem) {
    List<Item> itemsItemOrderToUpdate = state
        .where((item) => item.isPinned && item.itemOrder > tappedItem.itemOrder)
        .toList();

    if (pinnedItems.isNotEmpty) {
      for (var item in itemsItemOrderToUpdate) {
        DBHelper.updateWithId(
          'item',
          'ItemId = ?',
          item.itemId,
          {
            'ItemOrder': item.itemOrder - 1,
          },
        );
      }

      tappedItem.itemOrder =
          tappedItem.itemOrder + itemsItemOrderToUpdate.length;
    } else {
      tappedItem.itemOrder = 1;
    }

    DBHelper.updateWithId(
      'item',
      'ItemId = ?',
      tappedItem.itemId,
      {
        'ItemOrder': tappedItem.itemOrder,
      },
    );
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
    //print _items -uncomment the print to utilize
    //print('Printing records from item Table');
    for (var item in state) {
      item.itemId = 1; //comment out
      //print("itemId: " + item.itemId.toString());
      //print("itemName: " + item.itemName);
      //print("itemOrder: " + item.itemOrder.toString());
      //print(item.dateAdded);
    }
  }
}

//Insert this code into the widget to make use of the printItemsDebugMethod:

// TextButton(
//   onPressed: () {
//     ref
//         .watch(itemProvider.notifier)
//         .printItemsDebugMethod();
//   },
//   child: const Text('Print Items'),
//   ),

final itemProvider = StateNotifierProvider<ItemNotifier, List<Item>>((ref) {
  return ItemNotifier();
});
