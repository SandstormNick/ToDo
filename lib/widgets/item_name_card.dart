import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/item.dart';

import '../providers/item_provider.dart';

class ItemNameCard extends StatefulWidget {
  final Item item;
  final Function() notifiyParent;

  const ItemNameCard(
      {Key? key, required this.item, required this.notifiyParent})
      : super(key: key);

  @override
  State<ItemNameCard> createState() => _ItemNameCardState();
}

class _ItemNameCardState extends State<ItemNameCard> {
  void _onIsCompletedChanged(bool? newValue) => setState(
        () {
          if (newValue == true) {
            Provider.of<ItemProvider>(context, listen: false)
                .updateIsCompletedTrueForItem(widget.item.itemId);
            widget.item.isCompleted = true;
          } else {
            Provider.of<ItemProvider>(context, listen: false)
                .updateIsCompletedFalseForItem(widget.item.itemId);
            widget.item.isCompleted = false;
          }
          widget.notifiyParent();
        },
      );

  // void _onDeletedPressed(BuildContext context) => setState(
  //       () {
  //         Provider.of<ItemProvider>(context, listen: false)
  //             .updateIsDeletedForItem(widget.item.itemId);
  //       },
  //     );

  void _onDeletedPressed() => setState(
        () {
          Provider.of<ItemProvider>(context, listen: false)
              .updateIsDeletedForItem(widget.item.itemId);

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
        height: 100,
        child: Card(
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
                child: Text(widget.item.itemName),
              )
            ],
          ),
        ),
      ),
    );
  }
}
