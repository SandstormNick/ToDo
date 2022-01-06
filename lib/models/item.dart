class Item {
  int itemId;
  String itemName;
  bool isCompleted;
  bool isDeleted;
  DateTime dateAdded;
  int categoryIdfK;

  Item({
    required this.itemId,
    required this.itemName,
    this.isCompleted = false,
    this.isDeleted = false,
    required this.dateAdded,
    required this.categoryIdfK,
  });
}
