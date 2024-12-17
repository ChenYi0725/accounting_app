import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  late String summaryType;
  late int money;
  Summary({super.key, required this.summaryType, required this.money});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "總$summaryType",
          style:
              TextStyle(color: summaryType == "支出" ? Colors.red : Colors.green),
        ),
        Text(
          "\$$money",
          style: TextStyle(
            color: summaryType == "支出" ? Colors.red : Colors.green,
          ),
        )
      ],
    );
  }
}
