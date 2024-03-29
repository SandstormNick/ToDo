class Item {
  int? itemId;
  String itemName;
  bool isCompleted;
  bool isDeleted;
  DateTime dateAdded;
  int categoryIdfK;
  int itemOrder;
  bool isPinned;

  Item({
    this.itemId,
    required this.itemName,
    this.isCompleted = false,
    this.isDeleted = false,
    required this.dateAdded,
    required this.categoryIdfK,
    required this.itemOrder,
    this.isPinned = false,
  });
}
