import 'package:flutter/material.dart';

import '../Controller/account_type_controller.dart';

class InsertTypeList extends StatelessWidget {
  final Function(String, IconData) onTypeSelected;
  final List<String> categories;
  final List<IconData> iconCategories;

  InsertTypeList({
    super.key,
    required this.onTypeSelected,
    required this.categories,
    required this.iconCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              onTypeSelected(categories[index], iconCategories[index]);
            },
            child: Row(children: [
              Icon(
                iconCategories[index],
                size: 18,
              ),
              Text(
                categories[index],
                style: const TextStyle(fontSize: 13),
              )
            ]), // 顯示文字
          );
        },
      ),
    );
  }
}
