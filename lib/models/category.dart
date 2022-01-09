class Category {
  int? categoryId;
  String categoryName;
  bool isDeleted;

  Category({
    this.categoryId,
    required this.categoryName,
    this.isDeleted = false,
  });

  Category.add({
    required this.categoryName,
    this.isDeleted = false,
  });
}
