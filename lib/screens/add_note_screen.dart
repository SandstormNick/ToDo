import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  static const routeName = 'add-note';

  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNoteScreen();
}

class _AddNoteScreen extends ConsumerState<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _noteTextController = TextEditingController();

  Future<void> _saveItem() async {
    
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as Category;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _noteTextController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter note',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _saveItem(),
              icon: const Icon(Icons.add),
              label: const Text('Add Note'),
            )
          ],
        ),
      ),
    );
  }

}