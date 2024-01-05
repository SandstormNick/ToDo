import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/note_provider.dart';


class AddNoteScreen extends ConsumerStatefulWidget {
  static const routeAddItemNote = 'add-item-note';
  static const routeAddCategoryNote = 'add-category-note';

  final bool isItem;

  const AddNoteScreen({Key? key, required this.isItem}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNoteScreen();
}

class _AddNoteScreen extends ConsumerState<AddNoteScreen> {

  final _noteTextController = TextEditingController();

  Future<void> _saveNote(int id) async {
    ref.watch(noteProvider.notifier).addNote(
            _noteTextController.text,
            id,
            widget.isItem ? true : false
          );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;

    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _noteTextController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter note',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _saveNote(args),
              icon: const Icon(Icons.add),
              label: const Text('Add Note'),
            )
          ],
        ),
      ),
    );
  }

}