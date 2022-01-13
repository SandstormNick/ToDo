import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemNameCard extends StatelessWidget {
  final Item item;

  const ItemNameCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(item.itemName),
            )
          ],
        ),
      ),
    );
  }
}
