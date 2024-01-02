import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';

import 'package:todo_list/screens/add_note_screen.dart';

//If need be you can change this to only accomodate Item notes and add a sperate screen for categories if you struggle with routing
class NoteScreen extends ConsumerWidget {
  static const routeName = 'note';

  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          key: key,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddNoteScreen.routeName);
            },
          )
        ],
      ),
      body: const Text('Add your first Note'),
    );
  }
  
}