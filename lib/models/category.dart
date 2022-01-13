class Category {
  int categoryId;
  String categoryName;
  bool isDeleted;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.isDeleted = false,
  });
}
