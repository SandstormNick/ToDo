import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_list/models/note.dart';

import '../helpers/db_helper.dart';

class NoteProvider extends StateNotifier<List<Note>> {
  NoteProvider() : super([]);

  Future<void> fetchAndSetNotes() async {
    final dataList =
        await DBHelper.getDataNotDeleted('item_note', 'IsDeleted = 0');
    state = dataList
        .map(
          (mapItem) => Note(
            noteId: mapItem['ItemNoteId'],
            noteText: mapItem['NoteText'],
            isDeleted: mapItem['IsDeleted'] == 0 ? false : true,
            isItemNote: true,
            isCategoryNote: false,
            dateAdded: mapItem['DateAdded'],
            itemIdFk: mapItem['ItemId_FK'],
          ),
        )
        .toList();
  }
}

final noteProvider = StateNotifierProvider<NoteProvider, List<Note>>((ref) {
  return NoteProvider();
});