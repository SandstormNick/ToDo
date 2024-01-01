import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';

import '../providers/item_provider.dart';

//This widget is currently not being used - I need to update the state on the Category screen - not on the item_name_card widget
//So, I need to work out how to do that better
class PinnedIconToggle extends ConsumerStatefulWidget {
  final Item item;
  final Function() notifiyParent;

  const PinnedIconToggle({Key? key, required this.item, required this.notifiyParent}) : super(key: key);

  @override
  ConsumerState<PinnedIconToggle> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<PinnedIconToggle> {
  void _onIsPinnedTapped() => setState(() {
    widget.item.isPinned = !widget.item.isPinned;

    ref.watch(itemProvider.notifier).updateIsPinnedForItem(widget.item.itemId, widget.item.isPinned);

    widget.notifiyParent();
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onIsPinnedTapped,
      child: Icon(
        widget.item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
      ),
    );
  }
}