class Note {
  int? noteId;
  String noteText;
  bool isDeleted;
  bool isItemNote;
  bool isCategoryNote;
  DateTime dateAdded;
  int? categoryIdfK;
  int? itemIdFk;

  Note({
    this.noteId,
    required this.noteText,
    this.isDeleted = false,
    this.isItemNote = false,
    this.isCategoryNote = false,
    required this.dateAdded,
    this.categoryIdfK,
    this.itemIdFk,
  });
}
