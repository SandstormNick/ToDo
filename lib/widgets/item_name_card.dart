import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemNameCard extends StatefulWidget {
  final Item item;

  const ItemNameCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemNameCard> createState() => _ItemNameCardState();
}

class _ItemNameCardState extends State<ItemNameCard> {
  void _onIsCompletedChanged(bool? newValue) => setState(() {
        if (newValue == true) {
          widget.item.isCompleted = true;
        } else {
          widget.item.isCompleted = false;
        }
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
