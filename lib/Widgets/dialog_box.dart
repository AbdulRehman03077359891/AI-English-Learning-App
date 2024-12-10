import 'package:flutter/material.dart';
import 'reusable_confirmation_dialog.dart';

void showConfirmationDialog(BuildContext context, Function action) {
  showDialog(
    context: context,
    builder: (_) => ReusableConfirmationDialog(
      title: "Are you sure?",
      onConfirm: () {
        action(); // Call your delete logic
        Navigator.pop(context); // Close the dialog
      },
      onCancel: () {
        Navigator.pop(context); // Close the dialog
      },
    ),
  );
}
