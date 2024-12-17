import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController {
  String inputExpression = "";
  void onCalculatorPress(String value) {
    if (value == "C") {
      inputExpression = "";
    } else if (value == "ok") {
      try {
        Parser parser = Parser();
        Expression expression = parser.parse(inputExpression);
        ContextModel cm = ContextModel();
        double result = expression.evaluate(EvaluationType.REAL, cm);
        inputExpression = result.toStringAsFixed(2);
      } catch (e) {
        inputExpression = "Error";
      }
    } else if (value == "<") {
      if (inputExpression.isNotEmpty) {
        inputExpression =
            inputExpression.substring(0, inputExpression.length - 1);
      }
    } else {
      inputExpression += value;
    }
    ;
  }
}
