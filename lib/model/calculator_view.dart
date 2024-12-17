import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'calculator_button.dart';

class CalculatorView extends StatelessWidget {
  final Function(String) onCalculatorPress;

  CalculatorView({Key? key, required this.onCalculatorPress}) : super(key: key);

  String equation = "0";

  String result = "0";

  String expression = "";

  double equationFontSize = 38.0;

  double resultFontSize = 48.0;

  double bottomAlignAdjustment = 0.08;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CalculatorButton(
                buttonText: '7',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('7')),
            CalculatorButton(
                buttonText: '8',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('8')),
            CalculatorButton(
                buttonText: '9',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('9')),
            CalculatorButton(
                buttonText: '÷',
                buttonColor: Colors.white10,
                buttonPressed: () => onCalculatorPress('/')),
            CalculatorButton(
                buttonText: 'C',
                buttonColor: Colors.white10,
                buttonPressed: () => onCalculatorPress('C')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CalculatorButton(
                buttonText: '4',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('4')),
            CalculatorButton(
                buttonText: '5',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('5')),
            CalculatorButton(
                buttonText: '6',
                buttonColor: Colors.white24,
                buttonPressed: () => onCalculatorPress('6')),
            CalculatorButton(
                buttonText: "×",
                buttonColor: Colors.white10,
                buttonPressed: () => onCalculatorPress('*')),
            CalculatorButton(
                buttonText: '<',
                buttonColor: Colors.white10,
                buttonPressed: () => onCalculatorPress('<')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CalculatorButton(
                        buttonText: '1',
                        buttonColor: Colors.white24,
                        buttonPressed: () => onCalculatorPress('1')),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            bottomAlignAdjustment),
                    CalculatorButton(
                        buttonText: '2',
                        buttonColor: Colors.white24,
                        buttonPressed: () => onCalculatorPress('2')),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            bottomAlignAdjustment),
                    CalculatorButton(
                        buttonText: '3',
                        buttonColor: Colors.white24,
                        buttonPressed: () => onCalculatorPress('3')),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            bottomAlignAdjustment),
                    CalculatorButton(
                        buttonText: '+',
                        buttonColor: Colors.white24,
                        buttonPressed: () => onCalculatorPress('+')),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            bottomAlignAdjustment),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CalculatorButton(
                          buttonText: '00',
                          buttonColor: Colors.white24,
                          buttonPressed: () => onCalculatorPress('00')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width *
                              bottomAlignAdjustment),
                      CalculatorButton(
                          buttonText: '0',
                          buttonColor: Colors.white24,
                          buttonPressed: () => onCalculatorPress('0')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width *
                              bottomAlignAdjustment),
                      CalculatorButton(
                          buttonText: '.',
                          buttonColor: Colors.white24,
                          buttonPressed: () => onCalculatorPress('.')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width *
                              bottomAlignAdjustment),
                      CalculatorButton(
                          buttonText: '-',
                          buttonColor: Colors.white24,
                          buttonPressed: () => onCalculatorPress('-')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width *
                              bottomAlignAdjustment),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              // color: Colors.red,
              child: Flexible(
                fit: FlexFit.loose,
                child: CalculatorButton(
                    buttonText: '=',
                    buttonColor: Colors.pinkAccent,
                    buttonPressed: () => onCalculatorPress('=')),
              ),
            ),
          ],
        )
      ],
    );
  }
}
