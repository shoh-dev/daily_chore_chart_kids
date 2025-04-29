import 'package:flutter/material.dart';
import '../../utils/math_lock_helper.dart';

Future<bool> showMathLockDialog(BuildContext context) async {
  final q = MathLockHelper.generateQuestion();
  final controller = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Parent Access Only"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Solve to continue: ${q.label}"),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final answer = int.tryParse(controller.text.trim());
              final isCorrect = answer == q.answer;
              Navigator.of(context).pop(isCorrect);
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
