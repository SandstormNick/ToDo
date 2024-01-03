import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';

import '../providers/note_provider.dart';

import '../screens/add_note_screen.dart';
import '../widgets/note_text_card.dart';

//If need be you can change this to only accomodate Item notes and add a sperate screen for categories if you struggle with routing
class NoteScreen extends ConsumerStatefulWidget {
  static const routeName = 'note';

  const NoteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.itemName} Notes',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddNoteScreen.routeName,
                  arguments: args);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: ref.read(noteProvider.notifier).fetchAndSetNotes(args.itemId!),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer(
                child: const Center(
                  child: Text('Add your first Note'),
                ),
                builder: (context, ref, child) => ref
                        .watch(noteProvider)
                        .isEmpty
                    ? child!
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i < ref.watch(noteProvider).length;
                                  i++)
                                NoteTextCard(note: ref.watch(noteProvider)[i], notifiyParent: refresh),
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
  
}