import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_list/models/note.dart';

import '../helpers/db_helper.dart';

class NoteProvider extends StateNotifier<List<Note>> {
  NoteProvider() : super([]);

  Future<void> fetchAndSetNotes(int itemId) async {
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

  Future<void> addNote(String inputText, int itemId) async {
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);

    final newNote = Note(
      noteText: inputText,
      dateAdded: date,
      itemIdFk: itemId,
    );

    state = [...state, newNote];

    final int insertedId = await DBHelper.insertReturnId('item_note', {
      'ItemId_FK': itemId,
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