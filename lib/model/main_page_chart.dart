import 'package:flutter/material.dart';
import 'dart:math';

class DonutChart extends StatelessWidget {
  final double firstSectionValue;
  final double secondSectionValue;
  final int balance;
  final String centerText = "總計";
  final String firstLabel = "收入";
  final String secondLabel = "支出";

  DonutChart(
      {required this.firstSectionValue,
      required this.secondSectionValue,
      required this.balance});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(250, 250),
      painter: DonutChartPainter(
        firstSectionValue: firstSectionValue,
        secondSectionValue: secondSectionValue,
        centerText: centerText,
        balance: balance,
        firstLabel: firstLabel,
        secondLabel: secondLabel,
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double firstSectionValue;
  final double secondSectionValue;
  final String centerText;
  final int balance;
  final String firstLabel;
  final String secondLabel;

  DonutChartPainter({
    required this.firstSectionValue,
    required this.secondSectionValue,
    required this.centerText,
    required this.balance,
    required this.firstLabel,
    required this.secondLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    double total = firstSectionValue + secondSectionValue;

    if (firstSectionValue == 0) {
      total = secondSectionValue;
    } else if (secondSectionValue == 0) {
      total = firstSectionValue;
    }

    double firstSweepAngle =
        firstSectionValue == 0 ? 0 : 2 * pi * (firstSectionValue / total);
    double secondSweepAngle =
        secondSectionValue == 0 ? 0 : 2 * pi * (secondSectionValue / total);

    // 圓環背景
    paint.color = Colors.grey[300]!;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.5, paint);

    if (firstSectionValue > 0) {
      paint.color = Colors.green;
      canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2.5),
        -pi / 2, // 開始角度
        firstSweepAngle, // 持續角度
        false,
        paint,
      );
    }

    if (secondSectionValue > 0) {
      paint.color = Colors.redAccent;
      canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2.5),
        -pi / 2 + firstSweepAngle,
        secondSweepAngle,
        false,
        paint,
      );
    }

    TextSpan textSpan = TextSpan(
      text: "$centerText\n$balance",
      style: TextStyle(
          color: balance > 0
              ? Colors.green
              : (balance < 0 ? Colors.red : Colors.grey.shade700),
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        size.center(Offset(-textPainter.width / 2, -textPainter.height / 2)));

    if (firstSectionValue > 0) {
      double firstLabelAngle = -pi / 2 + firstSweepAngle / 2;
      _drawLabelText(canvas, firstLabel, firstLabelAngle, size, Colors.green);
    }

    if (secondSectionValue > 0) {
      double secondLabelAngle =
          -pi / 2 + firstSweepAngle + secondSweepAngle / 2;
      _drawLabelText(
          canvas, secondLabel, secondLabelAngle, size, Colors.redAccent);
    }
  }

  void _drawLabelText(
      Canvas canvas, String label, double angle, Size size, Color textColor) {
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 文字位置
    double radius = size.width / 2 + 30;
    double x = size.width / 2 + radius * cos(angle) - textPainter.width / 2;
    double y = size.height / 2 + radius * sin(angle) - textPainter.height / 2;
    if (y > 250 && label == "收入") {
      y = size.height / 2 + radius * sin(0) - textPainter.height / 2;
      x = size.width / 2 + radius * cos(0) - textPainter.width / 2;
    } else if (y > 250 && label == "支出") {
      y = size.height / 2 - radius * sin(0) - textPainter.height / 2;
      x = size.width / 2 - radius * cos(0) - textPainter.width / 2;
    }
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
