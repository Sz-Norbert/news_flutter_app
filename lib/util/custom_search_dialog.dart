import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearch;
  final VoidCallback onCancel;

  const SearchDialog({
    Key? key,
    required this.searchController,
    required this.onCancel,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        height: 120,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "key word",
              ),
            ),

            Row(children: [
              TextButton(onPressed: onCancel, child: const Text("cancel"),),
              TextButton(onPressed: onSearch, child: const Text("search"),)
            ],),
          ],
        ),
      ),
    );
  }
}
