import 'package:flutter/material.dart';

class RangeDialogBox extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback? onSort;
  final VoidCallback onCancel;

  const RangeDialogBox({
    Key? key,
    required this.fromController,
    required this.toController,
    required this.onCancel,
    required this.onSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        height: 120,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fromController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "from",
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: toController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "to",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: const Text("Cancel"),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onSort,
                  child: const Text("Sort"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
