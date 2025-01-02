import 'package:flutter/material.dart';
import '../Database/database_helper.dart';
import '../pages/insert_type_setting_page.dart';

class InsertTypeList extends StatelessWidget {
  final Function(String, IconData) onTypeSelected;
  final List<String> categories;
  final List<IconData> iconCategories;
  final String transactionType;
  late Future<List<Map<String, dynamic>>> _transactionTypes;
  final VoidCallback updatePage;

  InsertTypeList(
      {super.key,
      required this.onTypeSelected,
      required this.categories,
      required this.iconCategories,
      required this.transactionType,
      required this.updatePage}) {
    final isExpense = transactionType == "支出" ? 1 : 0;
    _transactionTypes = _fetchInsertTypesToList(isExpense);
  }
  Future<List<Map<String, dynamic>>> _fetchInsertTypesToList(
      int isExpense) async {
    final dbHelper = DatabaseHelper();
    final rawTypes = await dbHelper.fetchInsertTypes(isExpense);
    return rawTypes
        .map((type) => {
              'name': type['name'] as String,
              'icon': IconData(
                int.parse(type['iconName']),
                fontFamily: 'MaterialIcons',
              )
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _transactionTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 顯示加載中
        } else if (snapshot.hasError) {
          return Center(child: Text("加載失敗：${snapshot.error}"));
        } else {
          final dynamicTypes = snapshot.data ?? [];
          final allCategories = [
            ...categories,
            ...dynamicTypes.map((type) => type['name'] as String).toList(),
          ];
          final allIconCategories = [
            ...iconCategories,
            ...dynamicTypes.map((type) => type['icon'] as IconData).toList(),
          ];

          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              itemCount: allCategories.length + 1,
              itemBuilder: (context, index) {
                if (index < allCategories.length) {
                  return ElevatedButton(
                    onPressed: () {
                      onTypeSelected(
                          allCategories[index], allIconCategories[index]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          allIconCategories[index],
                          size: 18,
                        ),
                        Text(
                          allCategories[index],
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsertTypeSettingPage(
                                    updatePage: updatePage,
                                  ))).then((result) {
                        updatePage();
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 18,
                        ),
                        Text(
                          "設定",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
