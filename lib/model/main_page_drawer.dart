import 'package:flutter/material.dart';

class MainPageDrawer extends StatelessWidget {
  const MainPageDrawer({super.key});

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
            title: Text('選項 1'),
            onTap: () {
              // 點擊選項後的操作
            },
          ),
          ListTile(
            title: Text('選項 2'),
            onTap: () {
              // 點擊選項後的操作
            },
          ),
        ],
      ),
    );
  }
}
