import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

import '../models/category.dart';

import '../screens/category_screen.dart';

class CategoryMenuCard extends StatefulWidget {
  final Category category;

  const CategoryMenuCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryMenuCard> createState() => _CategoryMenuCardState();
}

class _CategoryMenuCardState extends State<CategoryMenuCard> {
  void _onDeletedPressed() => setState(() {
        Provider.of<CategoryProvider>(context, listen: false)
            .updateIsDeletedForCategory(widget.category.categoryId);

        Navigator.of(context).pop(true);
      });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {},
          motion: const InversedDrawerMotion(),
          confirmDismiss: () async {
            return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete ' + widget.category.categoryName),
                    content: const Text(
                        'Are you sure you want to delete the category?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: _onDeletedPressed,
                        child: const Text('DELETE'),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'))
                    ],
                  );
                });
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {},
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
          child: InkWell(
            splashColor: Colors.green,
            onTap: () {
              Navigator.pushNamed(
                context,
                CategoryScreen.routeName,
                arguments: widget.category,
              );
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.category.categoryName),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
