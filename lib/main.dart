import 'package:accounting_app/pages/MainPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AccountManager());
}

class AccountManager extends StatelessWidget {
  const AccountManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}
