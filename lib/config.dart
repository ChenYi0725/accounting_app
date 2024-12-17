import 'package:flutter/material.dart';

class ColorConfig {
  Color mainColor = Colors.blue;
  Color? secondColor = Colors.blueAccent[200];
  Color? listColor = Colors.lightBlueAccent[100];
  Color? listColor2 = Colors.blue;
  void changeColor(String chosenColor) {
    if (chosenColor == "blue") {
      mainColor = Colors.blue;
      secondColor = Colors.blueAccent[200];
      listColor = Colors.blueAccent[500];
    }
  }
}
