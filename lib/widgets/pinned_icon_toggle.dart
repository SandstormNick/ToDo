import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';

import '../providers/item_provider.dart';

class PinnedIconToggle extends ConsumerStatefulWidget {
  final Item item;

  const PinnedIconToggle({Key? key, required this.item}) : super(key: key);

  @override
  ConsumerState<PinnedIconToggle> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<PinnedIconToggle> {
  void _onIsPinnedTapped() => setState(() {
    widget.item.isPinned = !widget.item.isPinned;

    ref.watch(itemProvider.notifier).updateIsPinnedForItem(widget.item.itemId, widget.item.isPinned);
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