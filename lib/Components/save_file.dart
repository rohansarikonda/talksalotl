import 'package:flutter/material.dart';

class SaveFileDialog extends StatefulWidget {
  const SaveFileDialog({super.key});

  @override
  _SaveFileDialogState createState() => _SaveFileDialogState();
}

class _SaveFileDialogState extends State<SaveFileDialog> {
  final _filenameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Recording'),
      content: TextField(
        controller: _filenameController,
        decoration: const InputDecoration(hintText: 'Enter filename'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _filenameController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
