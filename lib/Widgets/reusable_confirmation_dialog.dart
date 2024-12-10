import 'package:flutter/material.dart';

class ReusableConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ReusableConfirmationDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(backgroundColor: Color.fromARGB(255, 190, 190, 190),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      actions: [
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 21, 49, 71),
            ),
          ),
          onPressed: onCancel,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 21, 49, 71),
            ),
          ),
          onPressed: onConfirm,
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
