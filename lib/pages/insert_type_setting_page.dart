import 'package:accounting_app/config.dart';
import 'package:flutter/material.dart';
import '../Database/database_helper.dart';

class InsertTypeSettingPage extends StatefulWidget {
  @override
  _InsertTypeSettingPageState createState() => _InsertTypeSettingPageState();
}

class _InsertTypeSettingPageState extends State<InsertTypeSettingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  bool _isExpense = false;
  bool isIconChoose = false;
  late Future<List<Map<String, dynamic>>> _expenseTypes;
  late Future<List<Map<String, dynamic>>> _incomeTypes;
  ColorConfig colorConfig = ColorConfig();
  late String insertType;
  String transactionType = "支出";

  final List<IconData> _iconList = [
    Icons.home,
    Icons.access_alarm,
    Icons.add_shopping_cart,
    Icons.account_balance,
    Icons.star,
    Icons.shopping_cart,
    Icons.account_circle,
    Icons.assessment,
    Icons.beach_access,
    Icons.business,
  ];

  @override
  void initState() {
    super.initState();
    _iconController.text = Icons.home.codePoint.toString();

    _fetchTypes();
  }

  void _addType() async {
    if (_nameController.text.isEmpty || _iconController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇一個圖示'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String iconName = _iconController.text;
    await DatabaseHelper().insertType(
      _nameController.text,
      _isExpense,
      iconName,
    );
    _nameController.clear();
    _iconController.clear();
    _fetchTypes();
  }

  IconData? stringToIcon(String iconCodePoint) {
    try {
      return IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons');
    } catch (e) {
      isIconChoose = false;
      return null;
    }
  }

  void _fetchTypes() {
    _expenseTypes = DatabaseHelper().fetchTypes().then(
        (types) => types.where((type) => type['isExpense'] == 1).toList());
    _incomeTypes = DatabaseHelper().fetchTypes().then(
        (types) => types.where((type) => type['isExpense'] == 0).toList());
    setState(() {});
  }

  void _deleteType(int id) async {
    await DatabaseHelper().deleteType(id);
    _fetchTypes();
  }

  void _selectIcon() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: _iconList.length,
          itemBuilder: (context, index) {
            IconData iconData = _iconList[index];
            return IconButton(
              icon: Icon(iconData, size: 30), // 調整圖示大小
              onPressed: () {
                setState(() {
                  _iconController.text =
                      iconData.codePoint.toString(); // 設定選擇的圖標
                  isIconChoose = true;
                });
                Navigator.pop(context); // 關閉選擇器
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('收入/支出種類設定'),
        backgroundColor: colorConfig.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      transactionType = "支出";
                      _isExpense = true;
                    });
                  },
                  child: Text(
                    "支出",
                    style: TextStyle(
                        color: transactionType == "支出"
                            ? colorConfig.secondColor
                            : Colors.grey,
                        fontSize: 18), // 調整文字大小
                  ),
                ),
                Text("|",
                    style:
                        TextStyle(color: colorConfig.mainColor, fontSize: 18)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      transactionType = "收入";
                      _isExpense = false;
                    });
                  },
                  child: Text(
                    "收入",
                    style: TextStyle(
                      fontSize: 18,
                      color: transactionType == "收入"
                          ? colorConfig.secondColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '名稱'),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: _selectIcon,
                        child: Center(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              isIconChoose &&
                                      stringToIcon(_iconController.text) != null
                                  ? Icon(stringToIcon(_iconController.text),
                                      size: 24) // 調整圖示大小
                                  : const SizedBox.shrink(),
                              const Text("選擇圖示"),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                onPressed: _addType,
                child: const Text('新增'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // 顯示支出類型
                  if (_isExpense) ...[
                    const Text('目前自訂支出種類',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _expenseTypes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('沒有支出種類'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final type = snapshot.data![index];
                            return ListTile(
                              leading: Icon(
                                IconData(int.parse(type['iconName']),
                                    fontFamily: 'MaterialIcons'),
                                size: 20, // 調整圖示大小
                              ),
                              title: Text(type['name']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteType(type['id']);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  // 顯示收入類型
                  if (!_isExpense) ...[
                    const Text('目前自訂收入種類',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _incomeTypes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('沒有收入種類'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final type = snapshot.data![index];
                          return ListTile(
                            leading: Icon(
                              IconData(int.parse(type['iconName']),
                                  fontFamily: 'MaterialIcons'),
                              size: 20, // 調整圖示大小
                            ),
                            title: Text(type['name']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteType(type['id']);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
