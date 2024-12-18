import 'dart:io';

import 'package:flutter/material.dart';

class ColorConfig {
  Color mainColor = Colors.blue;
  Color secondColor = Colors.blueAccent.shade200;
  Color listColor = Colors.lightBlueAccent.shade100;
  Color listColor2 = Colors.blue;
  Color calculatorColor1 = Colors.blue.shade50;
  Color calculatorColor2 = Colors.blue.shade200;
  void changeColor(String chosenColor) {
    if (chosenColor == "blue") {
      mainColor = Colors.blue;
      secondColor = Colors.blueAccent.shade200;
      listColor = Colors.lightBlueAccent.shade100;
    }
  }
}
