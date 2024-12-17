import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.buttonPressed});

  final String buttonText;
  final Color buttonColor;
  final void Function()? buttonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonPressed,
      child: Container(
        width: 50,
        height: buttonText == '=' ? 100 : 50,
        decoration: buttonText == '='
            ? BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(50),
              )
            : BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: buttonText == '00' ? 23 : 25),
        ),
      ),
    );
  }
}
