import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/item.dart';

import '../providers/item_provider.dart';

import '../screens/note_item_screen.dart';

class ItemNameCard extends ConsumerStatefulWidget {
  final Item item;
  final Function() notifiyParent;

  const ItemNameCard(
      {Key? key, required this.item, required this.notifiyParent})
      : super(key: key);

  @override
  ConsumerState<ItemNameCard> createState() => _ItemNameCardState();
}

class _ItemNameCardState extends ConsumerState<ItemNameCard> {
  void _onIsCompletedChanged(bool? newValue) => setState(
        () {
          if (newValue == true) {
            ref
                .watch(itemProvider.notifier)
                .updateIsCompletedTrueForItem(widget.item.itemId);
            widget.item.isCompleted = true;
          } else {
            ref
                .watch(itemProvider.notifier)
                .updateIsCompletedFalseForItem(widget.item.itemId);
            widget.item.isCompleted = false;
          }
          widget.notifiyParent();
        },
      );

  void _onDeletedPressed() => setState(
        () {
          //Should I be setting state still?
          ref
              .watch(itemProvider.notifier)
              .updateIsDeletedForItem(widget.item.itemId);

          widget.notifiyParent();
        },
      );

  void _onIsPinnedTapped() => setState(() {
        widget.item.isPinned = !widget.item.isPinned;

        ref
            .watch(itemProvider.notifier)
            .updateIsPinnedForItem(widget.item.itemId, widget.item.isPinned);

        widget.notifiyParent();
      });

  String formatDate(DateTime dateTime) {
    var year = dateTime.year.toString();
    var month = dateTime.month.toString();
    var day = dateTime.day.toString();
    return "$day/$month/$year";
  }

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
        height: 75,
        child: Card(
          child: InkWell(
            splashColor: Theme.of(context).splashColor,
            onTap: () {
              Navigator.pushNamed(
                context,
                NoteItemScreen.routeName,
                arguments: widget.item,
              );
            },
            child: Row(
              children: <Widget>[
                Transform.scale(
                  //scale: 1.5,
                  scale: 1,
                  child: Checkbox(
                    value: widget.item.isCompleted,
                    activeColor: Colors.green,
                    onChanged: _onIsCompletedChanged,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.item.itemName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                !widget.item.isCompleted
                    ? GestureDetector(
                        onTap: _onIsPinnedTapped,
                        child: Icon(
                          widget.item.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                        ),
                      )
                    : const SizedBox(),
                Text(formatDate(widget.item.dateAdded)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
