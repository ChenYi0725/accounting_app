import 'package:accounting_app/Database/database_helper.dart';
import 'package:flutter/material.dart';

import '../pages/insert_page.dart';
import '../pages/insert_type_setting_page.dart';

class MainPageDrawer extends StatefulWidget {
  final VoidCallback updateMainPage;
  MainPageDrawer({super.key, required this.updateMainPage});

  @override
  _MainPageDrawerState createState() => _MainPageDrawerState();
}

class _MainPageDrawerState extends State<MainPageDrawer> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String? vehicleNumber;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentVehicle();
  }

  void _loadCurrentVehicle() async {
    Map<String, dynamic>? vehicle = await databaseHelper.fetchVehicle();
    setState(() {
      vehicleNumber = vehicle != null ? vehicle['number'] : null;
    });
  }

  void _updateVehicleNumber(String number) async {
    await databaseHelper.updateVehicle(number);
    _loadCurrentVehicle();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '選單標題',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('設定載具條碼'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('更新載具號碼'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          vehicleNumber != null
                              ? '目前的載具號碼：$vehicleNumber'
                              : '目前沒有載具',
                        ),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(hintText: '輸入新載具號碼'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          _updateVehicleNumber(_controller.text);
                          Navigator.of(context).pop();
                          widget.updateMainPage();
                        },
                        child: Text('確認'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('自訂義記帳種類'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InsertTypeSettingPage(
                            updatePage: () {},
                          )));
            },
          ),
        ],
      ),
    );
  }
}
