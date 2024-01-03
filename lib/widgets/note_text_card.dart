import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';

import '../providers/note_provider.dart';

class NoteTextCard extends ConsumerStatefulWidget {
  final Note note;
  final Function() notifiyParent;

  const NoteTextCard({
    Key? key,
    required this.note, required this.notifiyParent
  }) : super(key: key);

  @override
  ConsumerState<NoteTextCard> createState() => _NoteTextCard();
}

class _NoteTextCard extends ConsumerState<NoteTextCard> {
  void _onDeletedPressed() => setState(
    () {
      //Should I be setting state still?
      ref
          .watch(noteProvider.notifier)
          .updateIsDeletedForNote(widget.note.noteId);

      widget.notifiyParent();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: _onDeletedPressed,
          motion: const InversedDrawerMotion(),
        ),
        children: [
          SlidableAction(
            onPressed: (_) {},
            //onPressed: _onDeletedPressed,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: SizedBox(
        child: Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.note.noteText, 
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}