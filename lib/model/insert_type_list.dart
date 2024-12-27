import 'package:flutter/material.dart';
import '../pages/insert_type_setting_page.dart';

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
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index < categories.length) {
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
          } else {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InsertTypeSettingPage()))
                    .then((result) {});
              },
              child: const Row(children: [
                Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 18,
                ),
                Text(
                  "設定",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                )
              ]), // 顯示文字
            );
          }
        },
      ),
    );
  }
}
