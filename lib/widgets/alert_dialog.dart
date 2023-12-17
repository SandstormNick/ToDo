import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String alertType;

  const CustomAlertDialog({super.key, required this.alertType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$alertType Already Exists'),
      content: Text('This $alertType already exists. Do you want to add it anyway?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Close the dialog and pass true
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Close the dialog and pass false
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}