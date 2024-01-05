import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_list/models/note.dart';

import '../helpers/db_helper.dart';

class NoteProvider extends StateNotifier<List<Note>> {
  NoteProvider() : super([]);

  fetchAndSetNotes(int id, bool isItem) {
    if (isItem){
      _fetchAndSetItemNotes(id);
    }
    else {
      _fetchAndSetCategoryNotes(id);
    }
  }

  Future<void> addNote(String inputText, int id, bool isItem) async {
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);

    if (isItem) {
      _addItemNote(inputText, id, date);
    }
    else {
      _addCategoryNote(inputText, id, date);
    }
  }

  Future<void> updateIsDeletedForNote(int? noteId) async {
    DBHelper.updateWithId(
      'item_note',
      'ItemNoteId = ?',
      noteId,
      {
        'IsDeleted': 1
      },
    );

    state = state.where((note) => note.noteId != noteId).toList();
  }

  //Function fetches and sets notes for an Item
  Future<void> _fetchAndSetItemNotes(int itemId) async {
    final dataList = await DBHelper.getDataWithId(
      'item_note',
      'ItemId_FK = ? AND IsDeleted = 0',
      'DateAdded',
      itemId
      );

    state = dataList
        .map(
          (mapNote) => Note(
            noteId: mapNote['ItemNoteId'],
            noteText: mapNote['NoteText'],
            isDeleted: mapNote['IsDeleted'] == 0 ? false : true,
            isItemNote: true,
            isCategoryNote: false,
            dateAdded: DateTime.parse(mapNote['DateAdded']),
            itemIdFk: mapNote['ItemId_FK'],
          ),
        )
        .toList();
  }

  //Function fetches and sets notes for a Category
  Future<void> _fetchAndSetCategoryNotes(int categoryId) async {
    final dataList = await DBHelper.getDataWithId(
      'category_note',
      'CategoryId_FK = ? AND IsDeleted = 0',
      'DateAdded',
      categoryId
      );

    state = dataList
        .map(
          (mapNote) => Note(
            noteId: mapNote['ItemNoteId'],
            noteText: mapNote['NoteText'],
            isDeleted: mapNote['IsDeleted'] == 0 ? false : true,
            isItemNote: false,
            isCategoryNote: true,
            dateAdded: DateTime.parse(mapNote['DateAdded']),
            categoryIdfK: mapNote['CategoryId_FK'],
          ),
        )
        .toList();
  }

  Future<void> _addItemNote(String inputText, int id, DateTime date) async {
    final newNote = Note(
      noteText: inputText,
      dateAdded: date,
      itemIdFk: id,
    );

    state = [...state, newNote];

    final int insertedId = await DBHelper.insertReturnId('item_note', {
      'ItemId_FK': id,
      'NoteText': newNote.noteText,
      'DateAdded': newNote.dateAdded.toString(),
      'IsDeleted': 0
    });

    state.last.noteId = insertedId;
  }

  Future<void> _addCategoryNote(String inputText, int id, DateTime date) async {
    final newNote = Note(
      noteText: inputText,
      dateAdded: date,
      categoryIdfK: id,
    );

    state = [...state, newNote];

    final int insertedId = await DBHelper.insertReturnId('category_note', {
      'CategoryId_FK': id,
      'NoteText': newNote.noteText,
      'DateAdded': newNote.dateAdded.toString(),
      'IsDeleted': 0
    });

    state.last.noteId = insertedId;
  }

  //A method that can be used in debugging
  void printNotesDebugMethod() {
    //print _items -uncomment the print to utilize
    //print('Printing records from item Table');
    state.forEach((note) {
      print("noteText: " + note.noteText);
    });
  }
}

final noteProvider = StateNotifierProvider<NoteProvider, List<Note>>((ref) {
  return NoteProvider();
});