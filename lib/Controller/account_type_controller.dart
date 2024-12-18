import 'package:flutter/material.dart';

class AccountTypeController {
  final List<String> expenseTypeCategories = [
    "餐飲",
    "交通",
    "娛樂",
    "購物",
    "健康",
    "教育",
    "旅遊",
    "運動",
    "其他",
  ];
  final List<IconData> expenseIconCategories = [
    Icons.fastfood,
    Icons.traffic,
    Icons.videogame_asset_rounded,
    Icons.shopping_cart,
    Icons.healing,
    Icons.border_color_outlined,
    Icons.airplanemode_active,
    Icons.sports_volleyball,
    Icons.twenty_four_mp_outlined,
  ];
  final List<String> incomeTypeCategories = [
    "薪水",
    "獎金",
    "回饋",
    "交易",
    "股息",
    "租金",
    "投資",
    "其他",
  ];
  final List<IconData> incomeIconCategories = [
    Icons.wallet,
    Icons.monetization_on,
    Icons.attach_money,
    Icons.handshake,
    Icons.stacked_line_chart,
    Icons.home_outlined,
    Icons.account_balance,
    Icons.twenty_four_mp_outlined,
  ];
}
