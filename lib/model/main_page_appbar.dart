import 'package:flutter/material.dart';

class MainPageAppbar extends StatefulWidget {
  const MainPageAppbar({super.key});

  @override
  State<MainPageAppbar> createState() => _MainPageAppbarState();
}

class _MainPageAppbarState extends State<MainPageAppbar> {
  String buttonText = "按我"; // 初始按鈕文字
  String selectedMonth = "一月"; // 初始月份
  final List<String> months = [
    "一月",
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "十一月",
    "十二月",
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
