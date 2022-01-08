import 'package:flutter/material.dart';

class CategoryMenuCard extends StatelessWidget {
  final String cardTitle;

  const CategoryMenuCard({
    Key? key,
    required this.cardTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: InkWell(
          splashColor: Colors.green,
          onTap: () {},
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(cardTitle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
