class Category {
  int? categoryId;
  String categoryName;
  int isDeleted; //0 = false, 1 = true

  Category({
    this.categoryId,
    required this.categoryName,
    this.isDeleted = 0,
  });
}
